import 'package:flutter/material.dart';

/// Gestionnaire de navigation simplifié pour l'application
class NavigationSimple {
  static final GlobalKey<NavigatorState> _navigateurGlobal = GlobalKey<NavigatorState>();
  
  static GlobalKey<NavigatorState> get navigateurGlobal => _navigateurGlobal;
  
  /// Naviguer vers une nouvelle page
  static Future<T?> versPage<T extends Object?>(String route, {Object? arguments}) {
    return _navigateurGlobal.currentState!.pushNamed<T>(route, arguments: arguments);
  }
  
  /// Retour à la page précédente
  static void retour<T extends Object?>([T? resultat]) {
    return _navigateurGlobal.currentState!.pop<T>(resultat);
  }
  
  /// Remplacer la page actuelle
  static Future<T?> remplacerPar<T extends Object?, TO extends Object?>(
    String route, {
    Object? arguments,
    TO? resultat,
  }) {
    return _navigateurGlobal.currentState!.pushReplacementNamed<T, TO>(
      route,
      arguments: arguments,
      result: resultat,
    );
  }
  
  /// Naviguer et effacer toute la pile
  static Future<T?> versPageEtEffacer<T extends Object?>(String route, {Object? arguments}) {
    return _navigateurGlobal.currentState!.pushNamedAndRemoveUntil<T>(
      route,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }
  
  /// Vérifier si on peut revenir en arrière
  static bool peutRevenir() {
    return _navigateurGlobal.currentState!.canPop();
  }
}

/// Routes de l'application
class RoutesApp {
  static const String accueil = '/';
  static const String selectionPays = '/selection-pays';
  static const String connexion = '/connexion';
  static const String inscription = '/inscription';
  static const String verificationOtp = '/verification-otp';
  static const String detailContenu = '/contenu';
  static const String live = '/live';
  static const String replay = '/replay';
  static const String programmeTv = '/programme';
  static const String recherche = '/recherche';
  static const String profil = '/profil';
  static const String parametres = '/parametres';
}