/// Constantes globales de l'application MediPlus
/// URLs, durées, limites et valeurs par défaut
class ConstantesApp {
  // Informations de l'application
  static const String nomApp = 'MediPlus';
  static const String versionApp = '1.0.0';
  static const String descriptionApp = 'Plateforme d\'information santé pour l\'Afrique francophone';
  
  // URLs de base (à remplacer par les vraies URLs en production)
  static const String urlApiBase = 'https://api.hostonew.tv/v1';
  static const String urlWebSocket = 'wss://live.hostonew.tv';
  static const String urlCdn = 'https://cdn.hostonew.tv';
  static const String urlSiteWeb = 'https://hostonew.tv';
  
  // Endpoints API principaux
  static const String endpointAuth = '/auth';
  static const String endpointContenu = '/contenus';
  static const String endpointPays = '/pays';
  static const String endpointLive = '/live';
  static const String endpointUtilisateurs = '/utilisateurs';
  static const String endpointCommentaires = '/commentaires';
  
  // Durées et timeouts
  static const Duration timeoutApi = Duration(seconds: 30);
  static const Duration timeoutConnexion = Duration(seconds: 10);
  static const Duration dureeAnimationNormale = Duration(milliseconds: 300);
  static const Duration dureeAnimationRapide = Duration(milliseconds: 200);
  static const Duration dureeAnimationLente = Duration(milliseconds: 500);
  static const Duration intervalleRafraichissement = Duration(minutes: 5);
  
  // Limites de contenu
  static const int limiteCommentaire = 500;
  static const int limiteTitreArticle = 200;
  static const int limiteDescriptionCourte = 160;
  static const int limiteNomUtilisateur = 50;
  static const int limiteBio = 300;
  static const int taillePageDefaut = 20;
  static const int tailleMaxFichier = 10; // MB
  
  // Durées d'expiration
  static const Duration dureeExpirationToken = Duration(hours: 24);
  static const Duration dureeExpirationRefresh = Duration(days: 30);
  static const Duration dureeExpirationOtp = Duration(minutes: 5);
  static const Duration dureeExpirationCache = Duration(hours: 1);
  
  // URLs par défaut pour les images et médias
  static const String imageParDefautProfil = 'assets/images/profil_defaut.png';
  static const String imageParDefautContenu = 'assets/images/contenu_defaut.jpg';
  static const String imageLogoApp = 'assets/images/logo_hostonew.png';
  static const String imageFondAccueil = 'assets/images/fond_accueil.jpg';
  
  // Catégories de contenu santé
  static const List<String> categoriesSante = [
    'Actualités Santé',
    'Nutrition',
    'Prévention',
    'Maladies Tropicales',
    'Santé Maternelle',
    'Pédiatrie',
    'Médecine Traditionnelle',
    'Santé Publique',
    'Vaccination',
    'Hygiène',
    'Bien-être',
    'Sport et Santé',
    'Santé Mentale'
  ];
  
  // Liste des 13 pays couverts
  static const List<Map<String, String>> paysCouverts = [
    {'code': 'CI', 'nom': 'Côte d\'Ivoire', 'indicatif': '+225'},
    {'code': 'BF', 'nom': 'Burkina Faso', 'indicatif': '+226'},
    {'code': 'ML', 'nom': 'Mali', 'indicatif': '+223'},
    {'code': 'BJ', 'nom': 'Bénin', 'indicatif': '+229'},
    {'code': 'TG', 'nom': 'Togo', 'indicatif': '+228'},
    {'code': 'GA', 'nom': 'Gabon', 'indicatif': '+241'},
    {'code': 'FR', 'nom': 'France', 'indicatif': '+33'},
    {'code': 'SN', 'nom': 'Sénégal', 'indicatif': '+221'},
    {'code': 'GH', 'nom': 'Ghana', 'indicatif': '+233'},
    {'code': 'TD', 'nom': 'Tchad', 'indicatif': '+235'},
    {'code': 'GN', 'nom': 'Guinée', 'indicatif': '+224'},
    {'code': 'LR', 'nom': 'Libéria', 'indicatif': '+231'},
    {'code': 'NG', 'nom': 'Nigeria', 'indicatif': '+234'},
  ];
  
  // Types de contenu
  static const String typeArticle = 'article';
  static const String typeVideo = 'video';
  static const String typeLive = 'live';
  static const String typeReplay = 'replay';
  static const String typeEmission = 'emission';
  static const String typePodcast = 'podcast';
  
  // États de contenu
  static const String statutBrouillon = 'brouillon';
  static const String statutEnModeration = 'en_moderation';
  static const String statutPublie = 'publie';
  static const String statutRejete = 'rejete';
  static const String statutArchive = 'archive';
  
  // Types de notification
  static const String notifNouveauContenu = 'nouveau_contenu';
  static const String notifCommentaire = 'commentaire';
  static const String notifReponse = 'reponse';
  static const String notifLive = 'live';
  static const String notifValidation = 'validation';
  
  // Messages d'erreur standard
  static const String erreurReseau = 'Problème de connexion internet';
  static const String erreurServeur = 'Erreur du serveur, réessayez plus tard';
  static const String erreurDonneesInvalides = 'Données invalides';
  static const String erreurUtilisateurIntrouvable = 'Utilisateur non trouvé';
  static const String erreurMotDePasseIncorrect = 'Mot de passe incorrect';
  static const String erreurTokenExpire = 'Session expirée, veuillez vous reconnecter';
  
  // Messages de succès
  static const String successConnexion = 'Connexion réussie !';
  static const String successInscription = 'Inscription réussie !';
  static const String successSauvegarde = 'Sauvegardé avec succès !';
  static const String successSuppressionComplete = 'Suppression effectuée !';
  
  // URLs de contact et assistance
  static const String emailContact = 'contact@hostonew.tv';
  static const String emailAssistance = 'support@hostonew.tv';
  static const String numeroAssistance = '+225 07 00 00 00 00';
  
  // URLs réseaux sociaux
  static const String urlFacebook = 'https://facebook.com/hostonew';
  static const String urlTwitter = 'https://twitter.com/hostonew';
  static const String urlInstagram = 'https://instagram.com/hostonew';
  static const String urlYoutube = 'https://youtube.com/hostonew';
  
  // Configuration streaming
  static const int qualiteVideoDefaut = 720;
  static const int bitrateAudioDefaut = 128;
  static const Duration delaiReconnexionLive = Duration(seconds: 5);
  static const int maxTentativesReconnexion = 3;
  
  // Configuration chat live
  static const int maxMessagesChatAffiches = 100;
  static const int maxLongueurMessageChat = 200;
  static const Duration intervalleAntiSpam = Duration(seconds: 2);
}

/// Extensions utiles pour les constantes
extension ConstantesExtensions on String {
  /// Retourne l'URL complète de l'API
  String get urlApiComplete => '${ConstantesApp.urlApiBase}$this';
  
  /// Retourne l'URL complète du CDN pour une ressource
  String get urlCdnComplete => '${ConstantesApp.urlCdn}/$this';
}

/// Classe pour la gestion des valeurs par défaut de l'utilisateur test
class UtilisateurTest {
  static const String nom = 'Konan Alla Aime';
  static const String email = 'president.alla@gmail.com';
  static const String telephone = '+225 07 00 31 17 77';
  static const String pays = 'CI'; // Côte d'Ivoire
  static const String ville = 'Abidjan';
  static const String profession = 'Médecin';
  static const String bio = 'Passionné de santé publique et d\'information médicale pour l\'Afrique.';
  static const String motDePasse = 'MotDePasseTest123!';
  
  /// Retourne les informations complètes de l'utilisateur test
  static Map<String, dynamic> get donneesCompletes => {
    'nom': nom,
    'email': email,
    'telephone': telephone,
    'pays': pays,
    'ville': ville,
    'profession': profession,
    'bio': bio,
    'dateInscription': DateTime.now().toString(),
    'estVerifie': true,
    'estActif': true,
  };
}