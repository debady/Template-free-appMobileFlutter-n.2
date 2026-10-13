/// Modèle de données pour un utilisateur MediPlus
class UtilisateurModele {
  final String id;
  final String nom;
  final String? prenom;
  final String email;
  final String? telephone;
  final String? photoProfil;
  final String pays;
  final String? ville;
  final String? profession;
  final String? bio;
  final DateTime dateInscription;
  final DateTime? dateDerniereConnexion;
  final bool estVerifie;
  final bool estActif;
  final TypeUtilisateur typeUtilisateur;
  final Map<String, bool> preferencesNotifications;
  final List<String> categoriesPreferees;
  final int nombreContenus; // Pour les correspondants
  final int nombreCommentaires;
  final int nombreLikes;
  
  const UtilisateurModele({
    required this.id,
    required this.nom,
    this.prenom,
    required this.email,
    this.telephone,
    this.photoProfil,
    required this.pays,
    this.ville,
    this.profession,
    this.bio,
    required this.dateInscription,
    this.dateDerniereConnexion,
    this.estVerifie = false,
    this.estActif = true,
    this.typeUtilisateur = TypeUtilisateur.utilisateurStandard,
    this.preferencesNotifications = const {},
    this.categoriesPreferees = const [],
    this.nombreContenus = 0,
    this.nombreCommentaires = 0,
    this.nombreLikes = 0,
  });
  
  /// Constructeur à partir d'un Map JSON
  factory UtilisateurModele.depuisJson(Map<String, dynamic> json) {
    return UtilisateurModele(
      id: json['id'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'],
      email: json['email'] ?? '',
      telephone: json['telephone'],
      photoProfil: json['photo_profil'],
      pays: json['pays'] ?? 'CI',
      ville: json['ville'],
      profession: json['profession'],
      bio: json['bio'],
      dateInscription: DateTime.tryParse(json['date_inscription'] ?? '') ?? DateTime.now(),
      dateDerniereConnexion: json['date_derniere_connexion'] != null 
          ? DateTime.tryParse(json['date_derniere_connexion']) 
          : null,
      estVerifie: json['est_verifie'] ?? false,
      estActif: json['est_actif'] ?? true,
      typeUtilisateur: TypeUtilisateur.values.firstWhere(
        (type) => type.valeur == json['type_utilisateur'],
        orElse: () => TypeUtilisateur.utilisateurStandard,
      ),
      preferencesNotifications: Map<String, bool>.from(json['preferences_notifications'] ?? {}),
      categoriesPreferees: List<String>.from(json['categories_preferees'] ?? []),
      nombreContenus: json['nombre_contenus'] ?? 0,
      nombreCommentaires: json['nombre_commentaires'] ?? 0,
      nombreLikes: json['nombre_likes'] ?? 0,
    );
  }
  
  /// Conversion vers Map JSON
  Map<String, dynamic> versJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'photo_profil': photoProfil,
      'pays': pays,
      'ville': ville,
      'profession': profession,
      'bio': bio,
      'date_inscription': dateInscription.toIso8601String(),
      'date_derniere_connexion': dateDerniereConnexion?.toIso8601String(),
      'est_verifie': estVerifie,
      'est_actif': estActif,
      'type_utilisateur': typeUtilisateur.valeur,
      'preferences_notifications': preferencesNotifications,
      'categories_preferees': categoriesPreferees,
      'nombre_contenus': nombreContenus,
      'nombre_commentaires': nombreCommentaires,
      'nombre_likes': nombreLikes,
    };
  }
  
  /// Copie de l'utilisateur avec des modifications
  UtilisateurModele copierAvec({
    String? id,
    String? nom,
    String? prenom,
    String? email,
    String? telephone,
    String? photoProfil,
    String? pays,
    String? ville,
    String? profession,
    String? bio,
    DateTime? dateInscription,
    DateTime? dateDerniereConnexion,
    bool? estVerifie,
    bool? estActif,
    TypeUtilisateur? typeUtilisateur,
    Map<String, bool>? preferencesNotifications,
    List<String>? categoriesPreferees,
    int? nombreContenus,
    int? nombreCommentaires,
    int? nombreLikes,
  }) {
    return UtilisateurModele(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      telephone: telephone ?? this.telephone,
      photoProfil: photoProfil ?? this.photoProfil,
      pays: pays ?? this.pays,
      ville: ville ?? this.ville,
      profession: profession ?? this.profession,
      bio: bio ?? this.bio,
      dateInscription: dateInscription ?? this.dateInscription,
      dateDerniereConnexion: dateDerniereConnexion ?? this.dateDerniereConnexion,
      estVerifie: estVerifie ?? this.estVerifie,
      estActif: estActif ?? this.estActif,
      typeUtilisateur: typeUtilisateur ?? this.typeUtilisateur,
      preferencesNotifications: preferencesNotifications ?? this.preferencesNotifications,
      categoriesPreferees: categoriesPreferees ?? this.categoriesPreferees,
      nombreContenus: nombreContenus ?? this.nombreContenus,
      nombreCommentaires: nombreCommentaires ?? this.nombreCommentaires,
      nombreLikes: nombreLikes ?? this.nombreLikes,
    );
  }
  
  /// Retourne le nom complet de l'utilisateur
  String get nomComplet {
    if (prenom != null && prenom!.isNotEmpty) {
      return '$prenom $nom';
    }
    return nom;
  }
  
  /// Retourne les initiales de l'utilisateur pour l'avatar
  String get initiales {
    if (prenom != null && prenom!.isNotEmpty) {
      return '${prenom![0].toUpperCase()}${nom[0].toUpperCase()}';
    }
    return nom.length > 1 ? nom.substring(0, 2).toUpperCase() : nom[0].toUpperCase();
  }
  
  /// Vérifie si l'utilisateur peut publier des contenus
  bool get peutPublier {
    return typeUtilisateur == TypeUtilisateur.correspondant || 
           typeUtilisateur == TypeUtilisateur.moderateur ||
           typeUtilisateur == TypeUtilisateur.administrateur;
  }
  
  /// Vérifie si l'utilisateur peut modérer
  bool get peutModerer {
    return typeUtilisateur == TypeUtilisateur.moderateur ||
           typeUtilisateur == TypeUtilisateur.administrateur;
  }
  
  /// Vérifie si l'utilisateur est un administrateur
  bool get estAdmin {
    return typeUtilisateur == TypeUtilisateur.administrateur;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UtilisateurModele && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() => 'UtilisateurModele(id: $id, nom: $nomComplet, email: $email)';
}

/// Énumération des types d'utilisateurs
enum TypeUtilisateur {
  utilisateurStandard('utilisateur_standard', 'Utilisateur'),
  correspondant('correspondant', 'Correspondant'),
  moderateur('moderateur', 'Modérateur'),
  administrateur('administrateur', 'Administrateur');
  
  const TypeUtilisateur(this.valeur, this.libelle);
  
  final String valeur;
  final String libelle;
}

/// Classe pour les données de connexion/inscription
class DonneesAuthentification {
  final String? email;
  final String? telephone;
  final String motDePasse;
  final String? nom;
  final String? prenom;
  final String? pays;
  
  const DonneesAuthentification({
    this.email,
    this.telephone,
    required this.motDePasse,
    this.nom,
    this.prenom,
    this.pays,
  });
  
  Map<String, dynamic> versJson() {
    return {
      'email': email,
      'telephone': telephone,
      'mot_de_passe': motDePasse,
      'nom': nom,
      'prenom': prenom,
      'pays': pays,
    };
  }
  
  /// Vérifie si les données sont valides pour la connexion
  bool get estValideConnexion {
    return (email != null && email!.isNotEmpty) || 
           (telephone != null && telephone!.isNotEmpty) &&
           motDePasse.isNotEmpty;
  }
  
  /// Vérifie si les données sont valides pour l'inscription
  bool get estValideInscription {
    return estValideConnexion &&
           nom != null && nom!.isNotEmpty &&
           pays != null && pays!.isNotEmpty;
  }
}

/// Modèle pour les informations de session utilisateur
class SessionUtilisateur {
  final UtilisateurModele utilisateur;
  final String tokenAccess;
  final String tokenRefresh;
  final DateTime dateExpiration;
  
  const SessionUtilisateur({
    required this.utilisateur,
    required this.tokenAccess,
    required this.tokenRefresh,
    required this.dateExpiration,
  });
  
  factory SessionUtilisateur.depuisJson(Map<String, dynamic> json) {
    return SessionUtilisateur(
      utilisateur: UtilisateurModele.depuisJson(json['utilisateur']),
      tokenAccess: json['token_access'] ?? '',
      tokenRefresh: json['token_refresh'] ?? '',
      dateExpiration: DateTime.tryParse(json['date_expiration'] ?? '') ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> versJson() {
    return {
      'utilisateur': utilisateur.versJson(),
      'token_access': tokenAccess,
      'token_refresh': tokenRefresh,
      'date_expiration': dateExpiration.toIso8601String(),
    };
  }
  
  /// Vérifie si la session est encore valide
  bool get estValide {
    return DateTime.now().isBefore(dateExpiration);
  }
  
  /// Vérifie si la session expire bientôt (dans les 5 prochaines minutes)
  bool get expireBientot {
    return DateTime.now().add(const Duration(minutes: 5)).isAfter(dateExpiration);
  }
}