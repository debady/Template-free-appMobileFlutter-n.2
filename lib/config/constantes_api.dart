/// Configuration des constantes API et URLs
class ConstantesApi {
  // URLs de base
  static const String urlBaseApi = 'https://api.hostonew.tv/api';
  static const String urlBaseCdn = 'https://cdn.hostonew.tv';
  
  // Endpoints authentification
  static const String connexion = '$urlBaseApi/auth/login';
  static const String inscription = '$urlBaseApi/auth/register';
  static const String verificationOtp = '$urlBaseApi/auth/verify-otp';
  static const String motDePasseOublie = '$urlBaseApi/auth/forgot-password';
  
  // Endpoints contenus
  static const String contenus = '$urlBaseApi/content';
  static const String contenuDetail = '$urlBaseApi/content';
  static const String categories = '$urlBaseApi/categories';
  static const String pays = '$urlBaseApi/countries';
  
  // Endpoints live et programme
  static const String livesActifs = '$urlBaseApi/live/active';
  static const String programme = '$urlBaseApi/program';
  static const String replay = '$urlBaseApi/content?type=replay';
  
  // Endpoints utilisateur
  static const String profil = '$urlBaseApi/user/profile';
  static const String favoris = '$urlBaseApi/user/favorites';
  static const String historique = '$urlBaseApi/user/history';
  
  // Configuration timeouts
  static const int timeoutConnexion = 30000; // 30 secondes
  static const int timeoutReception = 60000; // 60 secondes
  
  // Configuration pagination
  static const int nombreElementsParPage = 20;
  static const int nombreElementsGrille = 6;
  
  // Clés de stockage local
  static const String cleTokenAcces = 'token_acces';
  static const String cleTokenRefresh = 'token_refresh';
  static const String cleUtilisateur = 'utilisateur';
  static const String clePaysSelectionne = 'pays_selectionne';
  static const String clePreferences = 'preferences';
}