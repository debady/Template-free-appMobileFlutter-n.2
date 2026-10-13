// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'couleurs_app.dart';
import 'tailles_app.dart';

/// Thème global de l'application MediPlus
/// Combine couleurs santé et dimensions pour une interface cohérente
class ThemeApp {
  /// Thème clair principal de l'application
  static ThemeData get themeClair {
    return ThemeData(
      // Configuration de base
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Couleurs principales
      primarySwatch: _creerMaterialColor(CouleursApp.vertSantePrimaire),
      primaryColor: CouleursApp.vertSantePrimaire,
      scaffoldBackgroundColor: CouleursApp.grisClairFond,
      
      // Schéma de couleurs Material 3
      colorScheme: const ColorScheme.light(
        primary: CouleursApp.vertSantePrimaire,
        secondary: CouleursApp.bleuCalme,
        surface: CouleursApp.blanc,
        background: CouleursApp.grisClairFond,
        error: CouleursApp.erreurRouge,
        onPrimary: CouleursApp.blanc,
        onSecondary: CouleursApp.blanc,
        onSurface: CouleursApp.grisFonce,
        onBackground: CouleursApp.grisFonce,
        onError: CouleursApp.blanc,
      ),
      
      // Style des textes
      textTheme: _textTheme,
      
      // Style des boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CouleursApp.vertSantePrimaire,
          foregroundColor: CouleursApp.blanc,
          elevation: TaillesApp.elevationNormale,
          minimumSize: const Size(TaillesApp.largeurBoutonNormal, TaillesApp.hauteurBoutonNormal),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
          ),
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CouleursApp.vertSantePrimaire,
          minimumSize: const Size(TaillesApp.largeurBoutonNormal, TaillesApp.hauteurBoutonNormal),
          side: const BorderSide(
            color: CouleursApp.vertSantePrimaire,
            width: 2.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
          ),
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: CouleursApp.vertSantePrimaire,
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Style des champs de saisie
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CouleursApp.blanc,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
          borderSide: const BorderSide(color: CouleursApp.grisClair),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
          borderSide: const BorderSide(color: CouleursApp.grisClair),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
          borderSide: const BorderSide(color: CouleursApp.vertSantePrimaire, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
          borderSide: const BorderSide(color: CouleursApp.erreurRouge, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: TaillesApp.espaceNormal,
          vertical: TaillesApp.espaceNormal,
        ),
        hintStyle: const TextStyle(
          color: CouleursApp.grisMoyen,
          fontSize: 16.0,
        ),
      ),
      
      // Style des cartes
      cardTheme: CardThemeData(
        color: CouleursApp.blanc,
        elevation: TaillesApp.elevationNormale,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
        ),
        margin: const EdgeInsets.all(TaillesApp.espaceMin),
      ),
      
      // Style de l'AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: CouleursApp.blanc,
        foregroundColor: CouleursApp.grisFonce,
        elevation: TaillesApp.elevationMin,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: CouleursApp.grisFonce,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      
      // Style des onglets
      tabBarTheme: const TabBarThemeData(
        labelColor: CouleursApp.vertSantePrimaire,
        unselectedLabelColor: CouleursApp.grisMoyen,
        indicatorColor: CouleursApp.vertSantePrimaire,
        indicatorSize: TabBarIndicatorSize.label,
      ),
      
      // Style des icônes
      iconTheme: const IconThemeData(
        color: CouleursApp.grisMoyen,
        size: TaillesApp.iconeNormale,
      ),
      
      // Style des dividers
      dividerTheme: const DividerThemeData(
        color: CouleursApp.grisClair,
        thickness: 1.0,
      ),
      
      // Style des dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: CouleursApp.blanc,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TaillesApp.rayonGrand),
        ),
        elevation: TaillesApp.elevationHaute,
      ),
    );
  }
  
  /// Thème typographique personnalisé
  static const TextTheme _textTheme = TextTheme(
    // Titres principaux
    headlineLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: CouleursApp.grisFonce,
      height: 1.2,
    ),
    headlineMedium: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: CouleursApp.grisFonce,
      height: 1.2,
    ),
    headlineSmall: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: CouleursApp.grisFonce,
      height: 1.3,
    ),
    
    // Titres de sections
    titleLarge: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: CouleursApp.grisFonce,
      height: 1.3,
    ),
    titleMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: CouleursApp.grisFonce,
      height: 1.3,
    ),
    titleSmall: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: CouleursApp.grisFonce,
      height: 1.3,
    ),
    
    // Texte corporel
    bodyLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: CouleursApp.grisFonce,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: CouleursApp.grisFonce,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: CouleursApp.grisMoyen,
      height: 1.4,
    ),
    
    // Labels et annotations
    labelLarge: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: CouleursApp.grisMoyen,
    ),
    labelMedium: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w600,
      color: CouleursApp.grisMoyen,
    ),
    labelSmall: TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.w600,
      color: CouleursApp.grisMoyen,
    ),
  );
  
  /// Création d'un MaterialColor à partir d'une couleur
  static MaterialColor _creerMaterialColor(Color couleur) {
    final int rouge = couleur.red;
    final int vert = couleur.green;
    final int bleu = couleur.blue;
    
    final Map<int, Color> nuances = {
      50: Color.fromRGBO(rouge, vert, bleu, 0.1),
      100: Color.fromRGBO(rouge, vert, bleu, 0.2),
      200: Color.fromRGBO(rouge, vert, bleu, 0.3),
      300: Color.fromRGBO(rouge, vert, bleu, 0.4),
      400: Color.fromRGBO(rouge, vert, bleu, 0.5),
      500: Color.fromRGBO(rouge, vert, bleu, 0.6),
      600: Color.fromRGBO(rouge, vert, bleu, 0.7),
      700: Color.fromRGBO(rouge, vert, bleu, 0.8),
      800: Color.fromRGBO(rouge, vert, bleu, 0.9),
      900: Color.fromRGBO(rouge, vert, bleu, 1.0),
    };
    
    return MaterialColor(couleur.value, nuances);
  }
}

/// Styles de texte personnalisés pour des cas spécifiques
class StylesTextePersonnalises {
  // Style pour les titres de cartes de contenu
  static const TextStyle titreCarte = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: CouleursApp.grisFonce,
    height: 1.3,
  );
  
  // Style pour les métadonnées (auteur, date, etc.)
  static const TextStyle metadonnees = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: CouleursApp.grisMoyen,
    height: 1.2,
  );
  
  // Style pour les badges et étiquettes
  static const TextStyle badge = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: CouleursApp.blanc,
  );
  
  // Style pour les liens
  static const TextStyle lien = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: CouleursApp.vertSantePrimaire,
    decoration: TextDecoration.underline,
  );
}