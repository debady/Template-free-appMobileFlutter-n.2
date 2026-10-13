import 'package:flutter/material.dart';
import '../modeles/utilisateur_modele.dart';
import '../../config/constantes_app.dart';

/// Provider pour la gestion de l'authentification
/// Gère l'état de connexion, inscription et session utilisateur
class AuthentificationProvider with ChangeNotifier {
  // État privé
  SessionUtilisateur? _sessionCourante;
  bool _estConnecte = false;
  bool _chargementEnCours = false;
  String? _messageDErreur;
  
  // Getters publics
  SessionUtilisateur? get sessionCourante => _sessionCourante;
  UtilisateurModele? get utilisateurCourant => _sessionCourante?.utilisateur;
  bool get estConnecte => _estConnecte;
  bool get chargementEnCours => _chargementEnCours;
  String? get messageDErreur => _messageDErreur;
  
  /// Initialise le provider en vérifiant une session existante
  Future<void> initialiser() async {
    _definirChargement(true);
    
    try {
      // Simulation du chargement de session depuis le stockage local
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Pour les tests, on peut avoir une session par défaut
      await _chargerSessionSauvegardee();
      
    } catch (e) {
      _definirErreur('Erreur lors de l\'initialisation: ${e.toString()}');
    } finally {
      _definirChargement(false);
    }
  }
  
  /// Connexion utilisateur avec email/téléphone et mot de passe
  Future<bool> connecter({
    String? email,
    String? telephone,
    required String motDePasse,
  }) async {
    if (_chargementEnCours) return false;
    
    _effacerErreur();
    _definirChargement(true);
    
    try {
      // Validation des données
      if ((email == null || email.isEmpty) && 
          (telephone == null || telephone.isEmpty)) {
        throw Exception('Email ou téléphone requis');
      }
      
      if (motDePasse.isEmpty) {
        throw Exception('Mot de passe requis');
      }
      
      // Simulation appel API connexion
      await Future.delayed(const Duration(seconds: 1));
      
      // Pour les tests, on accepte les identifiants de l'utilisateur test
      if (_estUtilisateurTest(email, telephone, motDePasse)) {
        final utilisateur = _creerUtilisateurTest();
        final session = _creerSessionTest(utilisateur);
        await _definirSession(session);
        return true;
      }
      
      throw Exception('Identifiants incorrects');
      
    } catch (e) {
      _definirErreur(e.toString());
      return false;
    } finally {
      _definirChargement(false);
    }
  }
  
  /// Inscription utilisateur
  Future<bool> inscrire(DonneesAuthentification donnees) async {
    if (_chargementEnCours) return false;
    
    _effacerErreur();
    _definirChargement(true);
    
    try {
      // Validation des données
      if (!donnees.estValideInscription) {
        throw Exception('Données d\'inscription invalides');
      }
      
      // Simulation appel API inscription
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulation réussie - création utilisateur
      final utilisateur = UtilisateurModele(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nom: donnees.nom!,
        prenom: donnees.prenom,
        email: donnees.email!,
        telephone: donnees.telephone,
        pays: donnees.pays ?? 'CI',
        dateInscription: DateTime.now(),
        estVerifie: false, // Nécessite vérification OTP
        estActif: true,
      );
      
      // Note: En réalité, on ne créerait pas la session avant vérification OTP
      // Ici on simule pour les tests
      final session = SessionUtilisateur(
        utilisateur: utilisateur,
        tokenAccess: _genererTokenTest(),
        tokenRefresh: _genererTokenTest(),
        dateExpiration: DateTime.now().add(ConstantesApp.dureeExpirationToken),
      );
      
      await _definirSession(session);
      return true;
      
    } catch (e) {
      _definirErreur(e.toString());
      return false;
    } finally {
      _definirChargement(false);
    }
  }
  
  /// Vérification code OTP
  Future<bool> verifierOtp(String code, {String? email, String? telephone}) async {
    if (_chargementEnCours) return false;
    
    _effacerErreur();
    _definirChargement(true);
    
    try {
      // Simulation appel API vérification OTP
      await Future.delayed(const Duration(seconds: 1));
      
      // Pour les tests, on accepte le code "123456"
      if (code == '123456') {
        // Marquer utilisateur comme vérifié
        if (_sessionCourante != null) {
          final utilisateurVerifie = _sessionCourante!.utilisateur.copierAvec(
            estVerifie: true,
          );
          
          final nouvelleSession = SessionUtilisateur(
            utilisateur: utilisateurVerifie,
            tokenAccess: _sessionCourante!.tokenAccess,
            tokenRefresh: _sessionCourante!.tokenRefresh,
            dateExpiration: _sessionCourante!.dateExpiration,
          );
          
          await _definirSession(nouvelleSession);
        }
        return true;
      }
      
      throw Exception('Code OTP incorrect');
      
    } catch (e) {
      _definirErreur(e.toString());
      return false;
    } finally {
      _definirChargement(false);
    }
  }
  
  /// Déconnexion utilisateur
  Future<void> deconnecter() async {
    _definirChargement(true);
    
    try {
      // Simulation appel API déconnexion
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Effacer session locale
      await _supprimerSession();
      
    } catch (e) {
      _definirErreur('Erreur lors de la déconnexion: ${e.toString()}');
    } finally {
      _definirChargement(false);
    }
  }
  
  /// Met à jour les informations de l'utilisateur
  Future<bool> mettreAJourUtilisateur(UtilisateurModele utilisateurModifie) async {
    if (_chargementEnCours || _sessionCourante == null) return false;
    
    _effacerErreur();
    _definirChargement(true);
    
    try {
      // Simulation appel API mise à jour
      await Future.delayed(const Duration(seconds: 1));
      
      final nouvelleSession = SessionUtilisateur(
        utilisateur: utilisateurModifie,
        tokenAccess: _sessionCourante!.tokenAccess,
        tokenRefresh: _sessionCourante!.tokenRefresh,
        dateExpiration: _sessionCourante!.dateExpiration,
      );
      
      await _definirSession(nouvelleSession);
      return true;
      
    } catch (e) {
      _definirErreur('Erreur lors de la mise à jour: ${e.toString()}');
      return false;
    } finally {
      _definirChargement(false);
    }
  }
  
  /// Rafraîchit le token d'accès
  Future<bool> rafraichirToken() async {
    if (_sessionCourante == null) return false;
    
    try {
      // Simulation appel API refresh token
      await Future.delayed(const Duration(milliseconds: 500));
      
      final nouvelleSession = SessionUtilisateur(
        utilisateur: _sessionCourante!.utilisateur,
        tokenAccess: _genererTokenTest(),
        tokenRefresh: _sessionCourante!.tokenRefresh,
        dateExpiration: DateTime.now().add(ConstantesApp.dureeExpirationToken),
      );
      
      await _definirSession(nouvelleSession);
      return true;
      
    } catch (e) {
      _definirErreur('Erreur lors du rafraîchissement: ${e.toString()}');
      return false;
    }
  }
  
  // Méthodes privées
  
  void _definirChargement(bool chargement) {
    _chargementEnCours = chargement;
    notifyListeners();
  }
  
  void _definirErreur(String erreur) {
    _messageDErreur = erreur;
    notifyListeners();
  }
  
  void _effacerErreur() {
    _messageDErreur = null;
    notifyListeners();
  }
  
  Future<void> _definirSession(SessionUtilisateur session) async {
    _sessionCourante = session;
    _estConnecte = true;
    
    // Simulation sauvegarde session locale
    await Future.delayed(const Duration(milliseconds: 100));
    
    notifyListeners();
  }
  
  Future<void> _supprimerSession() async {
    _sessionCourante = null;
    _estConnecte = false;
    
    // Simulation suppression session locale
    await Future.delayed(const Duration(milliseconds: 100));
    
    notifyListeners();
  }
  
  Future<void> _chargerSessionSauvegardee() async {
    // Simulation chargement depuis stockage local
    // En réalité, on chargerait depuis SharedPreferences ou autre
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Pour les tests, on peut automatiquement connecter l'utilisateur test
    // Décommentez les lignes suivantes pour une session automatique :
    /*
    final utilisateur = _creerUtilisateurTest();
    final session = _creerSessionTest(utilisateur);
    await _definirSession(session);
    */
  }
  
  bool _estUtilisateurTest(String? email, String? telephone, String motDePasse) {
    return (email == UtilisateurTest.email || 
            telephone == UtilisateurTest.telephone) &&
           motDePasse == UtilisateurTest.motDePasse;
  }
  
  UtilisateurModele _creerUtilisateurTest() {
    return UtilisateurModele(
      id: 'test_user_001',
      nom: 'Aime',
      prenom: 'Konan Alla',
      email: UtilisateurTest.email,
      telephone: UtilisateurTest.telephone,
      pays: UtilisateurTest.pays,
      ville: UtilisateurTest.ville,
      profession: UtilisateurTest.profession,
      bio: UtilisateurTest.bio,
      dateInscription: DateTime.now().subtract(const Duration(days: 30)),
      dateDerniereConnexion: DateTime.now().subtract(const Duration(hours: 2)),
      estVerifie: true,
      estActif: true,
      typeUtilisateur: TypeUtilisateur.utilisateurStandard,
      nombreCommentaires: 12,
      nombreLikes: 45,
      categoriesPreferees: ['Actualités Santé', 'Nutrition', 'Prévention'],
      preferencesNotifications: {
        'nouveaux_contenus': true,
        'commentaires': true,
        'lives': true,
        'newsletters': false,
      },
    );
  }
  
  SessionUtilisateur _creerSessionTest(UtilisateurModele utilisateur) {
    return SessionUtilisateur(
      utilisateur: utilisateur,
      tokenAccess: _genererTokenTest(),
      tokenRefresh: _genererTokenTest(),
      dateExpiration: DateTime.now().add(ConstantesApp.dureeExpirationToken),
    );
  }
  
  String _genererTokenTest() {
    return 'token_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (9000 * (DateTime.now().millisecondsSinceEpoch % 100) / 100)).round()}';
  }
}