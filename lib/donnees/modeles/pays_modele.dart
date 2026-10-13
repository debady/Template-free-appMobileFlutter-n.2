/// Modèle de données pour un pays couvert par MediPlus
class PaysModele {
  final String code;
  final String nom;
  final String nomComplet;
  final String indicatifTelephonique;
  final String? drapeau;
  final String? capitale;
  final String langue;
  final String devise;
  final String region;
  final int nombreCorrespondants;
  final int nombreContenus;
  final bool estActif;
  final DateTime? dateLancement;
  
  const PaysModele({
    required this.code,
    required this.nom,
    required this.nomComplet,
    required this.indicatifTelephonique,
    this.drapeau,
    this.capitale,
    this.langue = 'Français',
    this.devise = '',
    this.region = 'Afrique de l\'Ouest',
    this.nombreCorrespondants = 0,
    this.nombreContenus = 0,
    this.estActif = true,
    this.dateLancement,
  });
  
  /// Constructeur à partir d'un Map JSON
  factory PaysModele.depuisJson(Map<String, dynamic> json) {
    return PaysModele(
      code: json['code'] ?? '',
      nom: json['nom'] ?? '',
      nomComplet: json['nom_complet'] ?? '',
      indicatifTelephonique: json['indicatif_telephonique'] ?? '',
      drapeau: json['drapeau'],
      capitale: json['capitale'],
      langue: json['langue'] ?? 'Français',
      devise: json['devise'] ?? '',
      region: json['region'] ?? 'Afrique de l\'Ouest',
      nombreCorrespondants: json['nombre_correspondants'] ?? 0,
      nombreContenus: json['nombre_contenus'] ?? 0,
      estActif: json['est_actif'] ?? true,
      dateLancement: json['date_lancement'] != null
          ? DateTime.tryParse(json['date_lancement'])
          : null,
    );
  }
  
  /// Conversion vers Map JSON
  Map<String, dynamic> versJson() {
    return {
      'code': code,
      'nom': nom,
      'nom_complet': nomComplet,
      'indicatif_telephonique': indicatifTelephonique,
      'drapeau': drapeau,
      'capitale': capitale,
      'langue': langue,
      'devise': devise,
      'region': region,
      'nombre_correspondants': nombreCorrespondants,
      'nombre_contenus': nombreContenus,
      'est_actif': estActif,
      'date_lancement': dateLancement?.toIso8601String(),
    };
  }
  
  /// Copie du pays avec des modifications
  PaysModele copierAvec({
    String? code,
    String? nom,
    String? nomComplet,
    String? indicatifTelephonique,
    String? drapeau,
    String? capitale,
    String? langue,
    String? devise,
    String? region,
    int? nombreCorrespondants,
    int? nombreContenus,
    bool? estActif,
    DateTime? dateLancement,
  }) {
    return PaysModele(
      code: code ?? this.code,
      nom: nom ?? this.nom,
      nomComplet: nomComplet ?? this.nomComplet,
      indicatifTelephonique: indicatifTelephonique ?? this.indicatifTelephonique,
      drapeau: drapeau ?? this.drapeau,
      capitale: capitale ?? this.capitale,
      langue: langue ?? this.langue,
      devise: devise ?? this.devise,
      region: region ?? this.region,
      nombreCorrespondants: nombreCorrespondants ?? this.nombreCorrespondants,
      nombreContenus: nombreContenus ?? this.nombreContenus,
      estActif: estActif ?? this.estActif,
      dateLancement: dateLancement ?? this.dateLancement,
    );
  }
  
  /// Retourne l'emoji du drapeau basé sur le code pays
  String get emojeDrapeau {
    if (drapeau != null && drapeau!.isNotEmpty) {
      return drapeau!;
    }
    
    // Mapping des codes pays vers les emojis de drapeaux
    switch (code.toLowerCase()) {
      case 'ci': return '🇨🇮';
      case 'bf': return '🇧🇫';
      case 'ml': return '🇲🇱';
      case 'bj': return '🇧🇯';
      case 'tg': return '🇹🇬';
      case 'ga': return '🇬🇦';
      case 'fr': return '🇫🇷';
      case 'sn': return '🇸🇳';
      case 'gh': return '🇬🇭';
      case 'td': return '🇹🇩';
      case 'gn': return '🇬🇳';
      case 'lr': return '🇱🇷';
      case 'ng': return '🇳🇬';
      default: return '🌍';
    }
  }
  
  /// Vérifie si le pays a une présence significative
  bool get aPresenceSignificative {
    return nombreCorrespondants > 0 || nombreContenus > 10;
  }
  
  /// Retourne une description du niveau d'activité
  String get niveauActivite {
    if (!estActif) return 'Inactif';
    if (nombreContenus > 100) return 'Très actif';
    if (nombreContenus > 50) return 'Actif';
    if (nombreContenus > 10) return 'Modérément actif';
    return 'En développement';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaysModele && other.code == code;
  }
  
  @override
  int get hashCode => code.hashCode;
  
  @override
  String toString() => 'PaysModele(code: $code, nom: $nom)';
}

/// Classe utilitaire pour la gestion des pays
class GestionnairePays {
  /// Liste des pays couverts par MediPlus avec données complètes
  static List<PaysModele> get paysCouverts => [
    const PaysModele(
      code: 'CI',
      nom: 'Côte d\'Ivoire',
      nomComplet: 'République de Côte d\'Ivoire',
      indicatifTelephonique: '+225',
      drapeau: '🇨🇮',
      capitale: 'Yamoussoukro',
      langue: 'Français',
      devise: 'Franc CFA (XOF)',
      region: 'Afrique de l\'Ouest',
      nombreCorrespondants: 3,
      nombreContenus: 156,
      estActif: true,
    ),
    const PaysModele(
      code: 'BF',
      nom: 'Burkina Faso',
      nomComplet: 'Burkina Faso',
      indicatifTelephonique: '+226',
      drapeau: '🇧🇫',
      capitale: 'Ouagadougou',
      langue: 'Français',
      devise: 'Franc CFA (XOF)',
      region: 'Afrique de l\'Ouest',
      nombreCorrespondants: 2,
      nombreContenus: 89,
      estActif: true,
    ),
    const PaysModele(
      code: 'ML',
      nom: 'Mali',
      nomComplet: 'République du Mali',
      indicatifTelephonique: '+223',
      drapeau: '🇲🇱',
      capitale: 'Bamako',
      langue: 'Français',
      devise: 'Franc CFA (XOF)',
      region: 'Afrique de l\'Ouest',
      nombreCorrespondants: 2,
      nombreContenus: 67,
      estActif: true,
    ),
    const PaysModele(
      code: 'BJ',
      nom: 'Bénin',
      nomComplet: 'République du Bénin',
      indicatifTelephonique: '+229',
      drapeau: '🇧🇯',
      capitale: 'Porto-Novo',
      langue: 'Français',
      devise: 'Franc CFA (XOF)',
      region: 'Afrique de l\'Ouest',
      nombreCorrespondants: 1,
      nombreContenus: 43,
      estActif: true,
    ),
    const PaysModele(
      code: 'TG',
      nom: 'Togo',
      nomComplet: 'République togolaise',
      indicatifTelephonique: '+228',
      drapeau: '🇹🇬',
      capitale: 'Lomé',
      langue: 'Français',
      devise: 'Franc CFA (XOF)',
      region: 'Afrique de l\'Ouest',
      nombreCorrespondants: 1,
      nombreContenus: 34,
      estActif: true,
    ),
    const PaysModele(
      code: 'GA',
      nom: 'Gabon',
      nomComplet: 'République gabonaise',
      indicatifTelephonique: '+241',
      drapeau: '🇬🇦',
      capitale: 'Libreville',
      langue: 'Français',
      devise: 'Franc CFA (XAF)',
      region: 'Afrique Centrale',
      nombreCorrespondants: 1,
      nombreContenus: 28,
      estActif: true,
    ),
    const PaysModele(
      code: 'FR',
      nom: 'France',
      nomComplet: 'République française',
      indicatifTelephonique: '+33',
      drapeau: '🇫🇷',
      capitale: 'Paris',
      langue: 'Français',
      devise: 'Euro (EUR)',
      region: 'Europe',
      nombreCorrespondants: 4,
      nombreContenus: 198,
      estActif: true,
    ),
    const PaysModele(
      code: 'SN',
      nom: 'Sénégal',
      nomComplet: 'République du Sénégal',
      indicatifTelephonique: '+221',
      drapeau: '🇸🇳',
      capitale: 'Dakar',
      langue: 'Français',
      devise: 'Franc CFA (XOF)',
      region: 'Afrique de l\'Ouest',
      nombreCorrespondants: 2,
      nombreContenus: 76,
      estActif: true,
    ),
    const PaysModele(
      code: 'GH',
      nom: 'Ghana',
      nomComplet: 'République du Ghana',
      indicatifTelephonique: '+233',
      drapeau: '🇬🇭',
      capitale: 'Accra',
      langue: 'Anglais',
      devise: 'Cedi ghanéen (GHS)',
      region: 'Afrique de l\'Ouest',
      nombreCorrespondants: 1,
      nombreContenus: 21,
      estActif: true,
    ),
    const PaysModele(
      code: 'TD',
      nom: 'Tchad',
      nomComplet: 'République du Tchad',
      indicatifTelephonique: '+235',
      drapeau: '🇹🇩',
      capitale: 'N\'Djaména',
      langue: 'Français',
      devise: 'Franc CFA (XAF)',
      region: 'Afrique Centrale',
      nombreCorrespondants: 1,
      nombreContenus: 15,
      estActif: true,
    ),
    const PaysModele(
      code: 'GN',
      nom: 'Guinée',
      nomComplet: 'République de Guinée',
      indicatifTelephonique: '+224',
      drapeau: '🇬🇳',
      capitale: 'Conakry',
      langue: 'Français',
      devise: 'Franc guinéen (GNF)',
      region: 'Afrique de l\'Ouest',
      nombreCorrespondants: 1,
      nombreContenus: 12,
      estActif: true,
    ),
    const PaysModele(
      code: 'LR',
      nom: 'Libéria',
      nomComplet: 'République du Libéria',
      indicatifTelephonique: '+231',
      drapeau: '🇱🇷',
      capitale: 'Monrovia',
      langue: 'Anglais',
      devise: 'Dollar libérien (LRD)',
      region: 'Afrique de l\'Ouest',
      nombreCorrespondants: 0,
      nombreContenus: 8,
      estActif: true,
    ),
    const PaysModele(
      code: 'NG',
      nom: 'Nigeria',
      nomComplet: 'République fédérale du Nigeria',
      indicatifTelephonique: '+234',
      drapeau: '🇳🇬',
      capitale: 'Abuja',
      langue: 'Anglais',
      devise: 'Naira (NGN)',
      region: 'Afrique de l\'Ouest',
      nombreCorrespondants: 2,
      nombreContenus: 45,
      estActif: true,
    ),
  ];
  
  /// Trouve un pays par son code
  static PaysModele? trouverParCode(String code) {
    try {
      return paysCouverts.firstWhere((pays) => pays.code.toLowerCase() == code.toLowerCase());
    } catch (e) {
      return null;
    }
  }
  
  /// Trouve un pays par son nom
  static PaysModele? trouverParNom(String nom) {
    try {
      return paysCouverts.firstWhere(
        (pays) => pays.nom.toLowerCase() == nom.toLowerCase() ||
                   pays.nomComplet.toLowerCase() == nom.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
  
  /// Retourne les pays par région
  static List<PaysModele> paysParRegion(String region) {
    return paysCouverts.where((pays) => pays.region == region).toList();
  }
  
  /// Retourne les pays les plus actifs
  static List<PaysModele> paysPlusActifs({int limite = 5}) {
    final paysActifs = List<PaysModele>.from(paysCouverts);
    paysActifs.sort((a, b) => b.nombreContenus.compareTo(a.nombreContenus));
    return paysActifs.take(limite).toList();
  }
  
  /// Retourne les régions uniques
  static List<String> get regionsUniques {
    return paysCouverts.map((pays) => pays.region).toSet().toList()..sort();
  }
  
  /// Retourne les pays par ordre alphabétique
  static List<PaysModele> get paysOrdonnes {
    final paysOrdonnes = List<PaysModele>.from(paysCouverts);
    paysOrdonnes.sort((a, b) => a.nom.compareTo(b.nom));
    return paysOrdonnes;
  }
}