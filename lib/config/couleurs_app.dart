// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// Palette de couleurs pour MediPlus
/// Couleurs douces et rassurantes dans l'esprit santé/bien-être
class CouleursApp {
  // Couleurs primaires santé
  static const Color vertSantePrimaire = Color(0xFF4CAF50);      // Vert nature principal
  static const Color vertSanteSecondaire = Color(0xFF81C784);     // Vert plus clair
  static const Color vertSanteClair = Color(0xFFE8F5E8);         // Vert très clair pour fonds
  
  // Couleurs complémentaires
  static const Color bleuCalme = Color(0xFF2196F3);              // Bleu apaisant
  static const Color bleuClair = Color(0xFFE3F2FD);              // Bleu très clair
  static const Color orangeVitalite = Color(0xFFFF9800);         // Orange énergisant
  static const Color orangeClair = Color(0xFFFFF3E0);            // Orange très clair
  
  // Couleurs neutres
  static const Color blanc = Color(0xFFFFFFFF);
  static const Color grisClairFond = Color(0xFFF8F9FA);          // Fond principal
  static const Color grisClair = Color(0xFFE9ECEF);              // Bordures légères
  static const Color grisMoyen = Color(0xFF6C757D);              // Texte secondaire
  static const Color grisFonce = Color(0xFF343A40);              // Texte principal
  static const Color noir = Color(0xFF000000);
  
  // Couleurs d'état
  static const Color successVert = Color(0xFF28A745);            // Succès
  static const Color infoBleu = Color(0xFF17A2B8);               // Information
  static const Color warningOrange = Color(0xFFFFC107);          // Avertissement
  static const Color erreurRouge = Color(0xFFDC3545);            // Erreur
  
  // Couleurs avec transparence pour animations
  static const Color overlay = Color(0x80000000);                // Overlay sombre
  static const Color overlayBlanc = Color(0x80FFFFFF);           // Overlay blanc
  
  // Gradients santé
  static const LinearGradient gradientVertSante = LinearGradient(
    colors: [vertSantePrimaire, vertSanteSecondaire],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient gradientBleuCalme = LinearGradient(
    colors: [bleuCalme, Color(0xFF64B5F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient gradientFondSubtil = LinearGradient(
    colors: [blanc, grisClairFond],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// Extensions pour faciliter l'utilisation des couleurs
extension CouleurExtensions on Color {
  /// Retourne une version plus claire de la couleur
  Color get plusClair => withOpacity(0.1);
  
  /// Retourne une version semi-transparente de la couleur
  Color get semiTransparent => withOpacity(0.7);
  
  /// Retourne une version très transparente pour les overlays
  Color get overlay => withOpacity(0.3);
}