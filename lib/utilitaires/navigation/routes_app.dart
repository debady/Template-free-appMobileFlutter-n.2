import 'package:flutter/material.dart';
import '../../interface/pages/accueil/accueil_page.dart';
import '../../interface/pages/authentification/connexion_page.dart';
import '../../interface/pages/authentification/inscription_page.dart';
import '../../interface/pages/authentification/verification_otp_page.dart';
import '../../interface/pages/contenu/detail_contenu_page.dart';
import '../../interface/pages/contenu/liste_contenus_page.dart';
import '../../interface/pages/systeme/selection_pays_page.dart';
import '../../interface/pages/systeme/erreur_page.dart';
import '../../interface/pages/systeme/maintenance_page.dart';

/// Gestionnaire centralisé des routes de l'application MediPlus
/// Navigation simple et cohérente pour toute l'application
class RoutesApp {
  // Routes principales
  static const String accueil = '/';
  static const String selectionPays = '/pays';
  
  // Routes authentification
  static const String connexion = '/connexion';
  static const String inscription = '/inscription';
  static const String verificationOtp = '/verification-otp';
  
  // Routes contenu
  static const String detailContenu = '/contenu';
  static const String listeContenus = '/contenus';
  static const String recherche = '/recherche';
  
  // Routes live et programme
  static const String live = '/live';
  static const String programmeTv = '/programme';
  static const String replay = '/replay';
  
  // Routes profil utilisateur
  static const String profil = '/profil';
  static const String favoris = '/favoris';
  static const String historique = '/historique';
  static const String parametres = '/parametres';
  
  // Routes système
  static const String erreur = '/erreur';
  static const String maintenance = '/maintenance';
  
  /// Générateur de routes principal de l'application
  static Route<dynamic> genererRoute(RouteSettings settings) {
    // Arguments passés à la route
    final args = settings.arguments as Map<String, dynamic>?;
    
    switch (settings.name) {
      // Page d'accueil
      case accueil:
        return _creerRoute(const AccueilPage());
      
      // Sélection pays
      case selectionPays:
        return _creerRoute(const SelectionPaysPage());
      
      // Authentification
      case connexion:
        return _creerRoute(const ConnexionPage());
      
      case inscription:
        return _creerRoute(const InscriptionPage());
      
      case verificationOtp:
        final email = args?['email'] as String?;
        final telephone = args?['telephone'] as String?;
        return _creerRoute(VerificationOtpPage(
          email: email,
          telephone: telephone,
        ));
      
      // Contenu
      case detailContenu:
        final contenuId = args?['id'] as String?;
        if (contenuId == null) {
          return _creerRoute(const ErreurPage(message: 'Contenu introuvable'));
        }
        return _creerRoute(DetailContenuPage(contenuId: contenuId));
      
      case listeContenus:
        final categorie = args?['categorie'] as String?;
        final pays = args?['pays'] as String?;
        return _creerRoute(ListeContenusPage(
          categorie: categorie,
          pays: pays,
        ));
      
      // case recherche:
      //   final requete = args?['requete'] as String?;
      //   return _creerRoute(RecherchePage(requeteInitiale: requete));
      
      // // Live et programme
      // case live:
      //   final liveId = args?['id'] as String?;
      //   return _creerRoute(LivePage(liveId: liveId));
      
      // case programmeTv:
      //   return _creerRoute(const ProgrammeTvPage());
      
      // case replay:
      //   final replayId = args?['id'] as String?;
      //   return _creerRoute(ReplayPage(replayId: replayId));
      
      // // Profil utilisateur
      // case profil:
      //   return _creerRoute(const ProfilPage());
      
      // case favoris:
      //   return _creerRoute(const FavorisPage());
      
      // case historique:
      //   return _creerRoute(const HistoriquePage());
      
      // case parametres:
      //   return _creerRoute(const ParametresPage());
      
      // Système
      case erreur:
        final message = args?['message'] as String?;
        return _creerRoute(ErreurPage(message: message));
      
      case maintenance:
        return _creerRoute(const MaintenancePage());
      
      // Route par défaut
      default:
        return _creerRoute(const ErreurPage(message: 'Page non trouvée'));
    }
  }
  
  /// Crée une route avec transition personnalisée
  static PageRoute<T> _creerRoute<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Animation de glissement fluide
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

/// Service de navigation global pour l'application
/// Facilite la navigation depuis n'importe où dans l'app
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  /// Context global pour la navigation
  static BuildContext? get contexte => navigatorKey.currentContext;
  
  /// Navigue vers une nouvelle page
  static Future<dynamic> naviguerVers(String route, {Map<String, dynamic>? arguments}) {
    return navigatorKey.currentState!.pushNamed(route, arguments: arguments);
  }
  
  /// Remplace la page actuelle
  static Future<dynamic> remplacer(String route, {Map<String, dynamic>? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(route, arguments: arguments);
  }
  
  /// Retourne à la page précédente
  static void retour([dynamic resultat]) {
    return navigatorKey.currentState!.pop(resultat);
  }
  
  /// Navigue vers l'accueil en vidant la pile
  static Future<dynamic> retourAccueil() {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      RoutesApp.accueil,
      (route) => false,
    );
  }
  
  /// Méthodes de navigation spécifiques
  
  // Navigation vers les pages principales
  static Future<void> allerAccueil() => naviguerVers(RoutesApp.accueil);
  static Future<void> allerSelectionPays() => naviguerVers(RoutesApp.selectionPays);
  static Future<void> allerRecherche({String? requete}) => naviguerVers(
    RoutesApp.recherche,
    arguments: {'requete': requete},
  );
  
  // Navigation authentification
  static Future<void> allerConnexion() => naviguerVers(RoutesApp.connexion);
  static Future<void> allerInscription() => naviguerVers(RoutesApp.inscription);
  static Future<void> allerVerificationOtp({String? email, String? telephone}) => naviguerVers(
    RoutesApp.verificationOtp,
    arguments: {'email': email, 'telephone': telephone},
  );
  
  // Navigation contenu
  static Future<void> allerDetailContenu(String contenuId) => naviguerVers(
    RoutesApp.detailContenu,
    arguments: {'id': contenuId},
  );
  
  static Future<void> allerListeContenus({String? categorie, String? pays}) => naviguerVers(
    RoutesApp.listeContenus,
    arguments: {'categorie': categorie, 'pays': pays},
  );
  
  // Navigation live
  static Future<void> allerLive({String? liveId}) => naviguerVers(
    RoutesApp.live,
    arguments: {'id': liveId},
  );
  
  static Future<void> allerProgrammeTv() => naviguerVers(RoutesApp.programmeTv);
  
  static Future<void> allerReplay(String replayId) => naviguerVers(
    RoutesApp.replay,
    arguments: {'id': replayId},
  );
  
  // Navigation profil
  static Future<void> allerProfil() => naviguerVers(RoutesApp.profil);
  static Future<void> allerFavoris() => naviguerVers(RoutesApp.favoris);
  static Future<void> allerHistorique() => naviguerVers(RoutesApp.historique);
  static Future<void> allerParametres() => naviguerVers(RoutesApp.parametres);
  
  // Navigation erreur
  static Future<void> allerErreur(String message) => naviguerVers(
    RoutesApp.erreur,
    arguments: {'message': message},
  );
  
  static Future<void> allerMaintenance() => naviguerVers(RoutesApp.maintenance);
}

/// Mixin pour faciliter l'utilisation de la navigation dans les widgets
mixin NavigationMixin {
  /// Navigation rapide vers l'accueil
  void allerAccueil() => NavigationService.allerAccueil();
  
  /// Navigation rapide avec gestion d'erreur
  void naviguerAvecGestion(String route, {Map<String, dynamic>? arguments}) {
    try {
      NavigationService.naviguerVers(route, arguments: arguments);
    } catch (e) {
      NavigationService.allerErreur('Erreur de navigation: ${e.toString()}');
    }
  }
  
  /// Retour sécurisé (vérifie qu'on peut revenir)
  void retourSecurise([dynamic resultat]) {
    if (NavigationService.navigatorKey.currentState?.canPop() ?? false) {
      NavigationService.retour(resultat);
    } else {
      NavigationService.allerAccueil();
    }
  }
}

/// Extension pour faciliter la navigation depuis les BuildContext
extension NavigationExtension on BuildContext {
  /// Navigation simplifiée depuis un BuildContext
  Future<dynamic> allerVers(String route, {Map<String, dynamic>? arguments}) {
    return Navigator.of(this).pushNamed(route, arguments: arguments);
  }
  
  /// Retour avec le contexte
  void revenir([dynamic resultat]) {
    Navigator.of(this).pop(resultat);
  }
  
  /// Vérifie si on peut revenir
  bool get peutRevenir => Navigator.of(this).canPop();
}