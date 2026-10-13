import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modeles/pays_modele.dart';

/// Provider pour la gestion des pays
/// Gère la sélection du pays courant et la liste des pays disponibles
class PaysProvider with ChangeNotifier {
  // État privé
  List<PaysModele> _paysDisponibles = [];
  PaysModele? _paysCourant;
  bool _chargementEnCours = false;
  String? _messageDErreur;
  bool _geolocationActive = true;
  
  // Getters publics
  List<PaysModele> get paysDisponibles => _paysDisponibles;
  PaysModele? get paysCourant => _paysCourant;
  bool get chargementEnCours => _chargementEnCours;
  String? get messageDErreur => _messageDErreur;
  bool get geolocationActive => _geolocationActive;
  
  /// Retourne les pays triés par nom
  List<PaysModele> get paysOrdonnes {
    final paysOrdonnes = List<PaysModele>.from(_paysDisponibles);
    paysOrdonnes.sort((a, b) => a.nom.compareTo(b.nom));
    return paysOrdonnes;
  }
  
  /// Retourne les pays les plus actifs
  List<PaysModele> get paysPlusActifs {
    final paysActifs = List<PaysModele>.from(_paysDisponibles);
    paysActifs.sort((a, b) => b.nombreContenus.compareTo(a.nombreContenus));
    return paysActifs.take(8).toList();
  }
  
  /// Retourne les pays par région
  Map<String, List<PaysModele>> get paysParRegion {
    final Map<String, List<PaysModele>> regionsMap = {};
    
    for (final pays in _paysDisponibles) {
      regionsMap.putIfAbsent(pays.region, () => []);
      regionsMap[pays.region]!.add(pays);
    }
    
    // Trier chaque région
    regionsMap.forEach((region, paysList) {
      paysList.sort((a, b) => a.nom.compareTo(b.nom));
    });
    
    return regionsMap;
  }
  
  /// Initialise le provider avec les pays disponibles
  Future<void> initialiser() async {
    _definirChargement(true);
    
    try {
      // Charger la liste des pays depuis les données statiques
      _paysDisponibles = GestionnairePays.paysCouverts;
      
      // Charger le pays courant depuis les préférences ou détecter automatiquement
      await _chargerPaysCourant();
      
    } catch (e) {
      _definirErreur('Erreur lors du chargement des pays: ${e.toString()}');
    } finally {
      _definirChargement(false);
    }
  }
  
  /// Sélectionne un pays manuellement
  Future<void> selectionnerPays(String codePays) async {
    _effacerErreur();
    
    try {
      final pays = GestionnairePays.trouverParCode(codePays);
      if (pays == null) {
        throw Exception('Pays non trouvé: $codePays');
      }
      
      if (_paysCourant?.code != codePays) {
        _paysCourant = pays;
        
        // Sauvegarder la préférence localement
        await _sauvegarderPreferencePays(codePays);
        
        notifyListeners();
      }
      
    } catch (e) {
      _definirErreur('Erreur lors de la sélection du pays: ${e.toString()}');
    }
  }
  
  /// Détecte automatiquement le pays via géolocalisation
  Future<void> detecterPaysAutomatiquement() async {
    if (!_geolocationActive) return;
    
    _definirChargement(true);
    _effacerErreur();
    
    try {
      // Simulation de la géolocalisation
      await Future.delayed(const Duration(seconds: 2));
      
      // Pour les tests, on simule une détection en Côte d'Ivoire
      final paysDetecte = GestionnairePays.trouverParCode('CI');
      
      if (paysDetecte != null) {
        _paysCourant = paysDetecte;
        await _sauvegarderPreferencePays('CI');
        notifyListeners();
      } else {
        throw Exception('Impossible de détecter votre localisation');
      }
      
    } catch (e) {
      _definirErreur('Géolocalisation échouée: ${e.toString()}');
      
      // Fallback vers la Côte d'Ivoire
      await selectionnerPays('CI');
    } finally {
      _definirChargement(false);
    }
  }
  
  /// Recherche des pays par nom ou code
  List<PaysModele> rechercherPays(String requete) {
    if (requete.isEmpty) return _paysDisponibles;
    
    final requeteLower = requete.toLowerCase();
    return _paysDisponibles.where((pays) {
      return pays.nom.toLowerCase().contains(requeteLower) ||
             pays.nomComplet.toLowerCase().contains(requeteLower) ||
             pays.code.toLowerCase().contains(requeteLower) ||
             pays.capitale?.toLowerCase().contains(requeteLower) == true;
    }).toList();
  }
  
  /// Trouve un pays par son code
  PaysModele? trouverParCode(String code) {
    return GestionnairePays.trouverParCode(code);
  }
  
  /// Active ou désactive la géolocalisation
  void definirGeolocation(bool activer) {
    if (_geolocationActive != activer) {
      _geolocationActive = activer;
      notifyListeners();
    }
  }
  
  /// Rafraîchit les données des pays
  Future<void> rafraichir() async {
    await initialiser();
  }
  
  /// Vérifie si un pays a du contenu disponible
  bool paysPossedeDuContenu(String codePays) {
    final pays = trouverParCode(codePays);
    return pays?.nombreContenus != null && pays!.nombreContenus > 0;
  }
  
  /// Retourne les statistiques globales
  Map<String, dynamic> get statistiquesGlobales {
    final totalContenus = _paysDisponibles.fold<int>(
      0, 
      (sum, pays) => sum + pays.nombreContenus,
    );
    
    final totalCorrespondants = _paysDisponibles.fold<int>(
      0, 
      (sum, pays) => sum + pays.nombreCorrespondants,
    );
    
    final paysActifs = _paysDisponibles.where((pays) => pays.estActif).length;
    
    return {
      'totalPays': _paysDisponibles.length,
      'paysActifs': paysActifs,
      'totalContenus': totalContenus,
      'totalCorrespondants': totalCorrespondants,
      'paysPlusActif': _paysDisponibles.isNotEmpty
          ? _paysDisponibles.reduce((a, b) => 
              a.nombreContenus > b.nombreContenus ? a : b).nom
          : null,
    };
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
  
  Future<void> _chargerPaysCourant() async {
    try {
      // Simulation du chargement depuis les préférences locales
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Pour les tests, on commence avec la Côte d'Ivoire
      final paysParDefaut = GestionnairePays.trouverParCode('CI');
      
      if (paysParDefaut != null) {
        _paysCourant = paysParDefaut;
      } else if (_paysDisponibles.isNotEmpty) {
        _paysCourant = _paysDisponibles.first;
      }
      
    } catch (e) {
      // En cas d'erreur, sélectionner le premier pays disponible
      if (_paysDisponibles.isNotEmpty) {
        _paysCourant = _paysDisponibles.first;
      }
    }
  }
  
  Future<void> _sauvegarderPreferencePays(String codePays) async {
    try {
      // Simulation de la sauvegarde dans SharedPreferences
      await Future.delayed(const Duration(milliseconds: 100));
      
      // En réalité, on sauvegarderait avec :
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('pays_courant', codePays);
      
    } catch (e) {
      // Erreur silencieuse pour la sauvegarde
    }
  }
}

/// Extension utile pour les widgets qui utilisent les pays
extension PaysProviderExtension on BuildContext {
  /// Accès rapide au provider des pays
  PaysProvider get pays => Provider.of<PaysProvider>(this, listen: false);
  
  /// Pays courant avec écoute des changements
  PaysModele? get paysCourant => Provider.of<PaysProvider>(this).paysCourant;
}

/// Classe utilitaire pour les informations sur les pays
class InformationsPays {
  /// Retourne l'indicatif téléphonique formaté
  static String formaterIndicatif(String indicatif) {
    if (indicatif.startsWith('+')) {
      return indicatif;
    }
    return '+$indicatif';
  }
  
  /// Valide un numéro de téléphone pour un pays donné
  static bool validerNumeroTelephone(String numero, String codePays) {
    final pays = GestionnairePays.trouverParCode(codePays);
    if (pays == null) return false;
    
    // Supprime les espaces et caractères spéciaux
    final numeroNettoye = numero.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Vérifie si commence par l'indicatif du pays
    final indicatifSansPlus = pays.indicatifTelephonique.substring(1);
    
    return numeroNettoye.startsWith(indicatifSansPlus) ||
           numeroNettoye.startsWith(pays.indicatifTelephonique);
  }
  
  /// Formate un numéro de téléphone pour un pays
  static String formaterNumeroTelephone(String numero, String codePays) {
    final pays = GestionnairePays.trouverParCode(codePays);
    if (pays == null) return numero;
    
    final numeroNettoye = numero.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final indicatifSansPlus = pays.indicatifTelephonique.substring(1);
    
    if (numeroNettoye.startsWith(indicatifSansPlus)) {
      return '${pays.indicatifTelephonique} ${numeroNettoye.substring(indicatifSansPlus.length)}';
    }
    
    return numero;
  }
  
  /// Retourne les fuseaux horaires approximatifs par région
  static String obtenirFuseauHoraire(String region) {
    switch (region) {
      case 'Afrique de l\'Ouest':
        return 'GMT+0';
      case 'Afrique Centrale':
        return 'GMT+1';
      case 'Europe':
        return 'GMT+1';
      default:
        return 'GMT+0';
    }
  }
}