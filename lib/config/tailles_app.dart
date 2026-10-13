import 'package:flutter/material.dart';

/// Dimensions et espacements standardisés pour MediPlus
/// Système d'espacement cohérent et responsive
class TaillesApp {
  // Espacements de base
  static const double espaceTresMin = 4.0;
  static const double espaceMin = 8.0;
  static const double espacePetit = 12.0;
  static const double espaceNormal = 16.0;
  static const double espaceMoyen = 20.0;
  static const double espaceGrand = 24.0;
  static const double espaceTresGrand = 32.0;
  static const double espaceEnorme = 48.0;
  
  // Hauteurs des éléments
  static const double hauteurBoutonNormal = 48.0;
  static const double hauteurBoutonGrand = 56.0;
  static const double hauteurChampSaisie = 52.0;
  static const double hauteurHeader = 64.0;
  static const double hauteurHeaderMobile = 56.0;
  static const double hauteurBottomNav = 60.0;
  
  // Largeurs des éléments
  static const double largeurBoutonMin = 120.0;
  static const double largeurBoutonNormal = 160.0;
  static const double largeurBoutonGrand = 200.0;
  static const double largeurMaxContenu = 1200.0;
  static const double largeurMaxArticle = 800.0;
  
  // Rayons de bordure pour les éléments arrondis
  static const double rayonMin = 4.0;
  static const double rayonPetit = 8.0;
  static const double rayonNormal = 12.0;
  static const double rayonGrand = 16.0;
  static const double rayonTresGrand = 24.0;
  static const double rayonCirculaire = 50.0;
  
  // Élévations pour les ombres Material
  static const double elevationMin = 1.0;
  static const double elevationNormale = 4.0;
  static const double elevationMoyenne = 8.0;
  static const double elevationHaute = 16.0;
  
  // Tailles des icônes
  static const double iconePetite = 16.0;
  static const double iconeNormale = 24.0;
  static const double iconeGrande = 32.0;
  static const double iconeTresGrande = 48.0;
  
  // Tailles des avatars
  static const double avatarPetit = 32.0;
  static const double avatarNormal = 48.0;
  static const double avatarGrand = 64.0;
  static const double avatarTresGrand = 96.0;
  
  // Breakpoints responsive
  static const double mobileMax = 600.0;
  static const double tablettMin = 601.0;
  static const double tablettMax = 1024.0;
  static const double desktopMin = 1025.0;
  static const double desktopGrandMin = 1440.0;
  
  // Padding horizontal standard selon la taille d'écran
  static double paddingHorizontal(BuildContext context) {
    final largeur = MediaQuery.of(context).size.width;
    if (largeur <= mobileMax) return espaceNormal;
    if (largeur <= tablettMax) return espaceMoyen;
    return espaceGrand;
  }
  
  // Espacement vertical entre sections selon la taille d'écran
  static double espacementSections(BuildContext context) {
    final largeur = MediaQuery.of(context).size.width;
    if (largeur <= mobileMax) return espaceGrand;
    if (largeur <= tablettMax) return espaceTresGrand;
    return espaceEnorme;
  }
  
  // Taille de police adaptée selon l'écran
  static double taillePoliceTitre(BuildContext context) {
    final largeur = MediaQuery.of(context).size.width;
    if (largeur <= mobileMax) return 20.0;
    if (largeur <= tablettMax) return 24.0;
    return 28.0;
  }
  
  // Nombre de colonnes pour les grilles selon la taille d'écran
  static int nombreColonnesGrille(BuildContext context) {
    final largeur = MediaQuery.of(context).size.width;
    if (largeur <= mobileMax) return 1;
    if (largeur <= tablettMax) return 2;
    if (largeur <= desktopGrandMin) return 3;
    return 4;
  }
}

/// Extensions utiles pour les dimensions
extension DimensionsExtensions on BuildContext {
  /// Retourne la largeur de l'écran
  double get largeurEcran => MediaQuery.of(this).size.width;
  
  /// Retourne la hauteur de l'écran
  double get hauteurEcran => MediaQuery.of(this).size.height;
  
  /// Vérifie si on est sur mobile
  bool get estMobile => largeurEcran <= TaillesApp.mobileMax;
  
  /// Vérifie si on est sur tablette
  bool get estTablette => largeurEcran > TaillesApp.mobileMax && largeurEcran <= TaillesApp.tablettMax;
  
  /// Vérifie si on est sur desktop
  bool get estDesktop => largeurEcran > TaillesApp.tablettMax;
  
  /// Retourne le padding horizontal adaptatif
  double get paddingAdaptatif => TaillesApp.paddingHorizontal(this);
  
  /// Retourne l'espacement entre sections adaptatif
  double get espacementAdaptatif => TaillesApp.espacementSections(this);
}