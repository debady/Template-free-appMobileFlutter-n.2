import 'package:permission_handler/permission_handler.dart';

/// Gestionnaire centralisé des permissions de l'application
class PermissionsManager {
  
  /// Vérifier si une permission est accordée
  static Future<bool> estAccordee(Permission permission) async {
    return await permission.isGranted;
  }
  
  /// Demander une permission
  static Future<PermissionStatus> demander(Permission permission) async {
    return await permission.request();
  }
  
  /// Obtenir permission caméra (pour scan QR ou photos profil)
  static Future<bool> obtenirPermissionCamera() async {
    if (await estAccordee(Permission.camera)) return true;
    
    final statut = await demander(Permission.camera);
    return statut == PermissionStatus.granted;
  }
  
  /// Obtenir permission microphone (pour commentaires vocaux futurs)
  static Future<bool> obtenirPermissionMicrophone() async {
    if (await estAccordee(Permission.microphone)) return true;
    
    final statut = await demander(Permission.microphone);
    return statut == PermissionStatus.granted;
  }
  
  /// Obtenir permission notifications
  // static Future<bool> obtenirPermissionNotifications() async {
  //   if (await estAccordee(Permission.notification)) return true;
    
  //   final statut = await demander(Permission.notification);
  //   return statut == PermissionStatus.granted;
  // }
  
  /// Obtenir permission stockage (pour télécharger contenus)
  static Future<bool> obtenirPermissionStockage() async {
    if (await estAccordee(Permission.storage)) return true;
    
    final statut = await demander(Permission.storage);
    return statut == PermissionStatus.granted;
  }
  
  /// Vérifier si permission refusée définitivement
  static Future<bool> estRefuseeDefinitivement(Permission permission) async {
    return await permission.isPermanentlyDenied;
  }
  
  /// Ouvrir paramètres de l'application
  static Future<bool> ouvrirParametresApp() async {
    return await openAppSettings();
  }
  
  /// Demander toutes les permissions nécessaires au démarrage
  // static Future<Map<String, bool>> demanderPermissionsBase() async {
  //   return {
  //     'notifications': await obtenirPermissionNotifications(),
  //     'stockage': await obtenirPermissionStockage(),
  //   };
  // }
}