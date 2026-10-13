/// Modèle de données pour un contenu MediPlus (article, vidéo, live, etc.)
class ContenuModele {
  final String id;
  final String titre;
  final String descriptionCourte;
  final String? contenuComplet;
  final String? urlMiniature;
  final String? urlMedia;
  final String? urlLive;
  final TypeContenu typeContenu;
  final String categorie;
  final String pays;
  final String auteurId;
  final String nomAuteur;
  final String? photoAuteur;
  final DateTime datePublication;
  final DateTime? dateModification;
  final DateTime? dateLive; // Pour les lives programmés
  final int dureeMinutes; // Durée estimée ou réelle
  final StatutContenu statut;
  final int nombreVues;
  final int nombreLikes;
  final int nombreCommentaires;
  final int nombrePartages;
  final List<String> tags;
  final Map<String, dynamic> metadonnees;
  final bool estFavori; // Pour l'utilisateur connecté
  final bool aLike; // Pour l'utilisateur connecté
  final bool estEnDirecte; // Pour les lives
  final int? nombreSpectateurs; // Pour les lives
  
  const ContenuModele({
    required this.id,
    required this.titre,
    required this.descriptionCourte,
    this.contenuComplet,
    this.urlMiniature,
    this.urlMedia,
    this.urlLive,
    required this.typeContenu,
    required this.categorie,
    required this.pays,
    required this.auteurId,
    required this.nomAuteur,
    this.photoAuteur,
    required this.datePublication,
    this.dateModification,
    this.dateLive,
    this.dureeMinutes = 0,
    this.statut = StatutContenu.publie,
    this.nombreVues = 0,
    this.nombreLikes = 0,
    this.nombreCommentaires = 0,
    this.nombrePartages = 0,
    this.tags = const [],
    this.metadonnees = const {},
    this.estFavori = false,
    this.aLike = false,
    this.estEnDirecte = false,
    this.nombreSpectateurs,
  });
  
  /// Constructeur à partir d'un Map JSON
  factory ContenuModele.depuisJson(Map<String, dynamic> json) {
    return ContenuModele(
      id: json['id'] ?? '',
      titre: json['titre'] ?? '',
      descriptionCourte: json['description_courte'] ?? '',
      contenuComplet: json['contenu_complet'],
      urlMiniature: json['url_miniature'],
      urlMedia: json['url_media'],
      urlLive: json['url_live'],
      typeContenu: TypeContenu.values.firstWhere(
        (type) => type.valeur == json['type_contenu'],
        orElse: () => TypeContenu.article,
      ),
      categorie: json['categorie'] ?? '',
      pays: json['pays'] ?? 'CI',
      auteurId: json['auteur_id'] ?? '',
      nomAuteur: json['nom_auteur'] ?? '',
      photoAuteur: json['photo_auteur'],
      datePublication: DateTime.tryParse(json['date_publication'] ?? '') ?? DateTime.now(),
      dateModification: json['date_modification'] != null
          ? DateTime.tryParse(json['date_modification'])
          : null,
      dateLive: json['date_live'] != null
          ? DateTime.tryParse(json['date_live'])
          : null,
      dureeMinutes: json['duree_minutes'] ?? 0,
      statut: StatutContenu.values.firstWhere(
        (statut) => statut.valeur == json['statut'],
        orElse: () => StatutContenu.publie,
      ),
      nombreVues: json['nombre_vues'] ?? 0,
      nombreLikes: json['nombre_likes'] ?? 0,
      nombreCommentaires: json['nombre_commentaires'] ?? 0,
      nombrePartages: json['nombre_partages'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      metadonnees: Map<String, dynamic>.from(json['metadonnees'] ?? {}),
      estFavori: json['est_favori'] ?? false,
      aLike: json['a_like'] ?? false,
      estEnDirecte: json['est_en_directe'] ?? false,
      nombreSpectateurs: json['nombre_spectateurs'],
    );
  }
  
  /// Conversion vers Map JSON
  Map<String, dynamic> versJson() {
    return {
      'id': id,
      'titre': titre,
      'description_courte': descriptionCourte,
      'contenu_complet': contenuComplet,
      'url_miniature': urlMiniature,
      'url_media': urlMedia,
      'url_live': urlLive,
      'type_contenu': typeContenu.valeur,
      'categorie': categorie,
      'pays': pays,
      'auteur_id': auteurId,
      'nom_auteur': nomAuteur,
      'photo_auteur': photoAuteur,
      'date_publication': datePublication.toIso8601String(),
      'date_modification': dateModification?.toIso8601String(),
      'date_live': dateLive?.toIso8601String(),
      'duree_minutes': dureeMinutes,
      'statut': statut.valeur,
      'nombre_vues': nombreVues,
      'nombre_likes': nombreLikes,
      'nombre_commentaires': nombreCommentaires,
      'nombre_partages': nombrePartages,
      'tags': tags,
      'metadonnees': metadonnees,
      'est_favori': estFavori,
      'a_like': aLike,
      'est_en_directe': estEnDirecte,
      'nombre_spectateurs': nombreSpectateurs,
    };
  }
  
  /// Copie du contenu avec des modifications
  ContenuModele copierAvec({
    String? id,
    String? titre,
    String? descriptionCourte,
    String? contenuComplet,
    String? urlMiniature,
    String? urlMedia,
    String? urlLive,
    TypeContenu? typeContenu,
    String? categorie,
    String? pays,
    String? auteurId,
    String? nomAuteur,
    String? photoAuteur,
    DateTime? datePublication,
    DateTime? dateModification,
    DateTime? dateLive,
    int? dureeMinutes,
    StatutContenu? statut,
    int? nombreVues,
    int? nombreLikes,
    int? nombreCommentaires,
    int? nombrePartages,
    List<String>? tags,
    Map<String, dynamic>? metadonnees,
    bool? estFavori,
    bool? aLike,
    bool? estEnDirecte,
    int? nombreSpectateurs,
  }) {
    return ContenuModele(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      descriptionCourte: descriptionCourte ?? this.descriptionCourte,
      contenuComplet: contenuComplet ?? this.contenuComplet,
      urlMiniature: urlMiniature ?? this.urlMiniature,
      urlMedia: urlMedia ?? this.urlMedia,
      urlLive: urlLive ?? this.urlLive,
      typeContenu: typeContenu ?? this.typeContenu,
      categorie: categorie ?? this.categorie,
      pays: pays ?? this.pays,
      auteurId: auteurId ?? this.auteurId,
      nomAuteur: nomAuteur ?? this.nomAuteur,
      photoAuteur: photoAuteur ?? this.photoAuteur,
      datePublication: datePublication ?? this.datePublication,
      dateModification: dateModification ?? this.dateModification,
      dateLive: dateLive ?? this.dateLive,
      dureeMinutes: dureeMinutes ?? this.dureeMinutes,
      statut: statut ?? this.statut,
      nombreVues: nombreVues ?? this.nombreVues,
      nombreLikes: nombreLikes ?? this.nombreLikes,
      nombreCommentaires: nombreCommentaires ?? this.nombreCommentaires,
      nombrePartages: nombrePartages ?? this.nombrePartages,
      tags: tags ?? this.tags,
      metadonnees: metadonnees ?? this.metadonnees,
      estFavori: estFavori ?? this.estFavori,
      aLike: aLike ?? this.aLike,
      estEnDirecte: estEnDirecte ?? this.estEnDirecte,
      nombreSpectateurs: nombreSpectateurs ?? this.nombreSpectateurs,
    );
  }
  
  /// Retourne une description formatée de la durée
  String get dureeFormatee {
    if (dureeMinutes <= 0) return '';
    
    final heures = dureeMinutes ~/ 60;
    final minutes = dureeMinutes % 60;
    
    if (heures > 0) {
      return minutes > 0 ? '${heures}h ${minutes}min' : '${heures}h';
    }
    return '${minutes}min';
  }
  
  /// Retourne une description du temps écoulé depuis la publication
  String get tempsEcoule {
    final maintenant = DateTime.now();
    final difference = maintenant.difference(datePublication);
    
    if (difference.inMinutes < 1) return 'À l\'instant';
    if (difference.inMinutes < 60) return '${difference.inMinutes}min';
    if (difference.inHours < 24) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}j';
    if (difference.inDays < 30) return '${difference.inDays ~/ 7} sem.';
    if (difference.inDays < 365) return '${difference.inDays ~/ 30} mois';
    return '${difference.inDays ~/ 365} an${difference.inDays ~/ 365 > 1 ? 's' : ''}';
  }
  
  /// Vérifie si le contenu est récent (moins de 24h)
  bool get estRecent {
    return DateTime.now().difference(datePublication).inHours < 24;
  }
  
  /// Vérifie si le contenu est un live programmé dans le futur
  bool get estLiveProgramme {
    return typeContenu == TypeContenu.live && 
           dateLive != null && 
           dateLive!.isAfter(DateTime.now());
  }
  
  /// Vérifie si le contenu est populaire (basé sur les interactions)
  bool get estPopulaire {
    final scorePopularite = nombreVues + (nombreLikes * 10) + (nombreCommentaires * 5);
    return scorePopularite > 1000;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContenuModele && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() => 'ContenuModele(id: $id, titre: $titre, type: ${typeContenu.libelle})';
}

/// Énumération des types de contenu
enum TypeContenu {
  article('article', 'Article', '📰'),
  video('video', 'Vidéo', '🎥'),
  live('live', 'Live', '🔴'),
  replay('replay', 'Replay', '📹'),
  emission('emission', 'Émission', '📺'),
  podcast('podcast', 'Podcast', '🎧');
  
  const TypeContenu(this.valeur, this.libelle, this.icone);
  
  final String valeur;
  final String libelle;
  final String icone;
}

/// Énumération des statuts de contenu
enum StatutContenu {
  brouillon('brouillon', 'Brouillon'),
  enModeration('en_moderation', 'En modération'),
  publie('publie', 'Publié'),
  rejete('rejete', 'Rejeté'),
  archive('archive', 'Archivé');
  
  const StatutContenu(this.valeur, this.libelle);
  
  final String valeur;
  final String libelle;
}

/// Classe pour les données de création de contenu
class DonneesContenu {
  final String titre;
  final String descriptionCourte;
  final String? contenuComplet;
  final TypeContenu typeContenu;
  final String categorie;
  final String pays;
  final List<String> tags;
  final DateTime? dateLive;
  final int? dureeMinutes;
  
  const DonneesContenu({
    required this.titre,
    required this.descriptionCourte,
    this.contenuComplet,
    required this.typeContenu,
    required this.categorie,
    required this.pays,
    this.tags = const [],
    this.dateLive,
    this.dureeMinutes,
  });
  
  Map<String, dynamic> versJson() {
    return {
      'titre': titre,
      'description_courte': descriptionCourte,
      'contenu_complet': contenuComplet,
      'type_contenu': typeContenu.valeur,
      'categorie': categorie,
      'pays': pays,
      'tags': tags,
      'date_live': dateLive?.toIso8601String(),
      'duree_minutes': dureeMinutes,
    };
  }
  
  /// Vérifie si les données sont valides
  bool get estValide {
    return titre.isNotEmpty &&
           descriptionCourte.isNotEmpty &&
           categorie.isNotEmpty &&
           pays.isNotEmpty;
  }
}