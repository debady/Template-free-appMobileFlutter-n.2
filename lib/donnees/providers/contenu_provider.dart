import 'package:flutter/material.dart';
import '../modeles/contenu_modele.dart';

/// Provider pour la gestion des contenus
/// Gère l'affichage, le filtrage et les interactions avec les contenus
class ContenuProvider with ChangeNotifier {
  // État privé
  List<ContenuModele> _contenus = [];
  List<ContenuModele> _contenusAffiches = [];
  List<ContenuModele> _contenusALaUne = [];
  List<ContenuModele> _contenusPopulaires = [];
  List<ContenuModele> _contenusRecents = [];
  List<ContenuModele> _livesEnCours = [];
  List<ContenuModele> _livesAProgrammer = [];
  
  bool _chargementEnCours = false;
  String? _messageDErreur;
  
  // Filtres actuels
  String? _paysFiltre;
  String? _categorieFiltre;
  TypeContenu? _typeFiltre;
  String _requeteRecherche = '';
  
  // Getters publics
  List<ContenuModele> get contenus => _contenusAffiches;
  List<ContenuModele> get contenusALaUne => _contenusALaUne;
  List<ContenuModele> get contenusPopulaires => _contenusPopulaires;
  List<ContenuModele> get contenusRecents => _contenusRecents;
  List<ContenuModele> get livesEnCours => _livesEnCours;
  List<ContenuModele> get livesAProgrammer => _livesAProgrammer;
  
  bool get chargementEnCours => _chargementEnCours;
  String? get messageDErreur => _messageDErreur;
  
  String? get paysFiltre => _paysFiltre;
  String? get categorieFiltre => _categorieFiltre;
  TypeContenu? get typeFiltre => _typeFiltre;
  String get requeteRecherche => _requeteRecherche;
  
  /// Initialise le provider avec les données de test
  Future<void> initialiser() async {
    _definirChargement(true);
    
    try {
      await _chargerDonneesTest();
      _appliquerFiltres();
      _organiserContenus();
    } catch (e) {
      _definirErreur('Erreur lors du chargement: ${e.toString()}');
    } finally {
      _definirChargement(false);
    }
  }
  
  /// Charge les contenus pour un pays spécifique
  Future<void> chargerContenusParPays(String codePays) async {
    _effacerErreur();
    _definirChargement(true);
    
    try {
      // Simulation appel API
      await Future.delayed(const Duration(seconds: 1));
      
      _paysFiltre = codePays;
      _appliquerFiltres();
      _organiserContenus();
      
    } catch (e) {
      _definirErreur('Erreur lors du chargement par pays: ${e.toString()}');
    } finally {
      _definirChargement(false);
    }
  }
  
  /// Charge les contenus par catégorie
  Future<void> chargerContenusParCategorie(String categorie) async {
    _effacerErreur();
    _definirChargement(true);
    
    try {
      // Simulation appel API
      await Future.delayed(const Duration(milliseconds: 800));
      
      _categorieFiltre = categorie;
      _appliquerFiltres();
      
    } catch (e) {
      _definirErreur('Erreur lors du chargement par catégorie: ${e.toString()}');
    } finally {
      _definirChargement(false);
    }
  }
  
  /// Effectue une recherche dans les contenus
  Future<void> rechercher(String requete) async {
    _effacerErreur();
    _definirChargement(true);
    
    try {
      // Simulation appel API recherche
      await Future.delayed(const Duration(milliseconds: 600));
      
      _requeteRecherche = requete.trim();
      _appliquerFiltres();
      
    } catch (e) {
      _definirErreur('Erreur lors de la recherche: ${e.toString()}');
    } finally {
      _definirChargement(false);
    }
  }
  
  /// Ajoute/retire un contenu des favoris
  Future<bool> basculerFavori(String contenuId) async {
    try {
      // Simulation appel API
      await Future.delayed(const Duration(milliseconds: 300));
      
      final index = _contenus.indexWhere((c) => c.id == contenuId);
      if (index != -1) {
        _contenus[index] = _contenus[index].copierAvec(
          estFavori: !_contenus[index].estFavori,
        );
        
        _appliquerFiltres();
        _organiserContenus();
        return true;
      }
      
      return false;
    } catch (e) {
      _definirErreur('Erreur lors de la modification des favoris');
      return false;
    }
  }
  
  /// Ajoute/retire un like sur un contenu
  Future<bool> basculerLike(String contenuId) async {
    try {
      // Simulation appel API
      await Future.delayed(const Duration(milliseconds: 300));
      
      final index = _contenus.indexWhere((c) => c.id == contenuId);
      if (index != -1) {
        final contenu = _contenus[index];
        final nouveauLike = !contenu.aLike;
        final nouveauNombreLikes = nouveauLike 
            ? contenu.nombreLikes + 1 
            : contenu.nombreLikes - 1;
        
        _contenus[index] = contenu.copierAvec(
          aLike: nouveauLike,
          nombreLikes: nouveauNombreLikes,
        );
        
        _appliquerFiltres();
        _organiserContenus();
        return true;
      }
      
      return false;
    } catch (e) {
      _definirErreur('Erreur lors de la modification des likes');
      return false;
    }
  }
  
  /// Met à jour le nombre de vues d'un contenu
  Future<void> incrementerVues(String contenuId) async {
    try {
      final index = _contenus.indexWhere((c) => c.id == contenuId);
      if (index != -1) {
        _contenus[index] = _contenus[index].copierAvec(
          nombreVues: _contenus[index].nombreVues + 1,
        );
        
        // Pas besoin de notifier pour les vues
      }
    } catch (e) {
      // Erreur silencieuse pour les vues
    }
  }
  
  /// Trouve un contenu par son ID
  ContenuModele? trouverContenuParId(String id) {
    try {
      return _contenus.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Efface tous les filtres
  void effacerFiltres() {
    _paysFiltre = null;
    _categorieFiltre = null;
    _typeFiltre = null;
    _requeteRecherche = '';
    
    _appliquerFiltres();
    _organiserContenus();
  }
  
  /// Applique un filtre par type
  void filtrerParType(TypeContenu? type) {
    _typeFiltre = type;
    _appliquerFiltres();
  }
  
  /// Rafraîchit les données
  Future<void> rafraichir() async {
    await initialiser();
  }
  
  // Méthodes privées
  
  void _definirChargement(bool chargement) {
    _chargementEnCours = chargement;
    notifyListeners();
  }
  
  void _definirErreur(String erreur) {
    _messageDErreur = erreur;
    notifyListeners();
  }
  
  void _effacerErreur() {
    _messageDErreur = null;
    notifyListeners();
  }
  
  void _appliquerFiltres() {
    _contenusAffiches = _contenus.where((contenu) {
      // Filtre par pays
      if (_paysFiltre != null && contenu.pays != _paysFiltre) {
        return false;
      }
      
      // Filtre par catégorie
      if (_categorieFiltre != null && contenu.categorie != _categorieFiltre) {
        return false;
      }
      
      // Filtre par type
      if (_typeFiltre != null && contenu.typeContenu != _typeFiltre) {
        return false;
      }
      
      // Filtre par recherche
      if (_requeteRecherche.isNotEmpty) {
        final requeteLower = _requeteRecherche.toLowerCase();
        return contenu.titre.toLowerCase().contains(requeteLower) ||
               contenu.descriptionCourte.toLowerCase().contains(requeteLower) ||
               contenu.nomAuteur.toLowerCase().contains(requeteLower) ||
               contenu.tags.any((tag) => tag.toLowerCase().contains(requeteLower));
      }
      
      return contenu.statut == StatutContenu.publie;
    }).toList();
    
    notifyListeners();
  }
  
  void _organiserContenus() {
    // Contenus à la une (les plus récents et populaires)
    _contenusALaUne = _contenusAffiches
        .where((c) => c.estPopulaire || c.estRecent)
        .take(5)
        .toList();
    
    // Contenus populaires (triés par score de popularité)
    _contenusPopulaires = List.from(_contenusAffiches)
      ..sort((a, b) {
        final scoreA = a.nombreVues + (a.nombreLikes * 10) + (a.nombreCommentaires * 5);
        final scoreB = b.nombreVues + (b.nombreLikes * 10) + (b.nombreCommentaires * 5);
        return scoreB.compareTo(scoreA);
      })
      ..take(10);
    
    // Contenus récents (dernières 24h)
    _contenusRecents = _contenusAffiches
        .where((c) => c.estRecent)
        .toList()
      ..sort((a, b) => b.datePublication.compareTo(a.datePublication));
    
    // Lives en cours
    _livesEnCours = _contenusAffiches
        .where((c) => c.typeContenu == TypeContenu.live && c.estEnDirecte)
        .toList();
    
    // Lives programmés
    _livesAProgrammer = _contenusAffiches
        .where((c) => c.estLiveProgramme)
        .toList()
      ..sort((a, b) => a.dateLive!.compareTo(b.dateLive!));
    
    notifyListeners();
  }
  
  Future<void> _chargerDonneesTest() async {
    // Données de test simulant des contenus variés
    _contenus = [
      // Articles santé
      ContenuModele(
        id: 'article_001',
        titre: 'Les bienfaits de l\'alimentation équilibrée en Afrique',
        descriptionCourte: 'Découvrez comment adapter votre alimentation aux produits locaux africains pour une santé optimale.',
        contenuComplet: 'Article complet sur la nutrition africaine...',
        urlMiniature: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=400',
        typeContenu: TypeContenu.article,
        categorie: 'Nutrition',
        pays: 'CI',
        auteurId: 'auteur_001',
        nomAuteur: 'Dr. Aminata Traoré',
        datePublication: DateTime.now().subtract(const Duration(hours: 2)),
        nombreVues: 1250,
        nombreLikes: 89,
        nombreCommentaires: 23,
        tags: ['nutrition', 'alimentation', 'santé', 'afrique'],
        dureeMinutes: 5,
      ),
      
      ContenuModele(
        id: 'article_002',
        titre: 'Prévention du paludisme : les gestes essentiels',
        descriptionCourte: 'Guide pratique pour se protéger efficacement contre le paludisme au quotidien.',
        urlMiniature: 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
        typeContenu: TypeContenu.article,
        categorie: 'Prévention',
        pays: 'BF',
        auteurId: 'auteur_002',
        nomAuteur: 'Dr. Ousmane Sankara',
        datePublication: DateTime.now().subtract(const Duration(days: 1)),
        nombreVues: 2100,
        nombreLikes: 156,
        nombreCommentaires: 45,
        tags: ['paludisme', 'prévention', 'santé tropicale'],
        dureeMinutes: 8,
      ),
      
      // Vidéos
      ContenuModele(
        id: 'video_001',
        titre: 'Vaccination des enfants : réponses aux questions fréquentes',
        descriptionCourte: 'Le Dr. Koffi répond aux principales préoccupations des parents sur la vaccination.',
        urlMiniature: 'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=400',
        urlMedia: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
        typeContenu: TypeContenu.video,
        categorie: 'Vaccination',
        pays: 'CI',
        auteurId: 'auteur_003',
        nomAuteur: 'Dr. Jean Koffi',
        datePublication: DateTime.now().subtract(const Duration(hours: 6)),
        nombreVues: 850,
        nombreLikes: 67,
        nombreCommentaires: 12,
        tags: ['vaccination', 'enfants', 'pédiatrie'],
        dureeMinutes: 12,
      ),
      
      ContenuModele(
        id: 'video_002',
        titre: 'Hygiène bucco-dentaire : les bonnes pratiques',
        descriptionCourte: 'Techniques et conseils pour maintenir une bonne hygiène bucco-dentaire.',
        urlMiniature: 'https://images.unsplash.com/photo-1609840114035-3c981b782dfe?w=400',
        urlMedia: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
        typeContenu: TypeContenu.video,
        categorie: 'Hygiène',
        pays: 'SN',
        auteurId: 'auteur_004',
        nomAuteur: 'Dr. Fatou Diop',
        datePublication: DateTime.now().subtract(const Duration(days: 2)),
        nombreVues: 1350,
        nombreLikes: 98,
        nombreCommentaires: 31,
        tags: ['hygiène', 'dentaire', 'santé bucco-dentaire'],
        dureeMinutes: 15,
      ),
      
      // Lives et émissions
      ContenuModele(
        id: 'live_001',
        titre: 'Live : Santé maternelle et infantile',
        descriptionCourte: 'Discussion en direct avec des spécialistes sur la santé des mères et enfants.',
        urlMiniature: 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?w=400',
        urlLive: 'https://live.hostonew.tv/stream_001',
        typeContenu: TypeContenu.live,
        categorie: 'Santé Maternelle',
        pays: 'CI',
        auteurId: 'auteur_005',
        nomAuteur: 'Équipe MediPlus',
        datePublication: DateTime.now().subtract(const Duration(minutes: 30)),
        dateLive: DateTime.now().subtract(const Duration(minutes: 30)),
        nombreVues: 234,
        nombreLikes: 45,
        nombreCommentaires: 78,
        nombreSpectateurs: 156,
        estEnDirecte: true,
        tags: ['live', 'santé maternelle', 'pédiatrie'],
        dureeMinutes: 60,
      ),
      
      ContenuModele(
        id: 'live_002',
        titre: 'Émission spéciale : Médecine traditionnelle africaine',
        descriptionCourte: 'Débat sur l\'intégration de la médecine traditionnelle dans les soins modernes.',
        urlMiniature: 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
        typeContenu: TypeContenu.live,
        categorie: 'Médecine Traditionnelle',
        pays: 'ML',
        auteurId: 'auteur_006',
        nomAuteur: 'Dr. Mamadou Keita',
        datePublication: DateTime.now().add(const Duration(days: 1, hours: 2)),
        dateLive: DateTime.now().add(const Duration(days: 1, hours: 2)),
        nombreVues: 0,
        nombreLikes: 23,
        nombreCommentaires: 5,
        tags: ['médecine traditionnelle', 'débat', 'émission'],
        dureeMinutes: 90,
      ),
      
      // Podcasts
      ContenuModele(
        id: 'podcast_001',
        titre: 'Podcast : Gestion du stress en milieu professionnel',
        descriptionCourte: 'Conseils pratiques pour gérer le stress au travail avec la psychologue Dr. Adjoua.',
        urlMiniature: 'https://images.unsplash.com/photo-1478737270239-2f02b77fc618?w=400',
        urlMedia: 'https://sample-audio.com/podcast_001.mp3',
        typeContenu: TypeContenu.podcast,
        categorie: 'Santé Mentale',
        pays: 'CI',
        auteurId: 'auteur_007',
        nomAuteur: 'Dr. Adjoua N\'Guessan',
        datePublication: DateTime.now().subtract(const Duration(days: 3)),
        nombreVues: 567,
        nombreLikes: 78,
        nombreCommentaires: 19,
        tags: ['stress', 'travail', 'psychologie', 'podcast'],
        dureeMinutes: 25,
      ),
    ];
  }
}