// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../donnees/providers/contenu_provider.dart';
import '../../../donnees/providers/pays_provider.dart';
import '../../../donnees/modeles/contenu_modele.dart';
import '../../../config/couleurs_app.dart';
import '../../../config/tailles_app.dart';
import '../../../config/constantes_app.dart';
import '../../../utilitaires/navigation/routes_app.dart';
import '../../composants/navigation/header_app.dart';
import '../../composants/contenu/carte_contenu.dart';
import '../../composants/communs/bouton_personnalise.dart';
import '../../composants/communs/chargement_widget.dart';

/// Page de liste de contenus avec filtrage par catégorie et pays
class ListeContenusPage extends StatefulWidget {
  final String? categorie;
  final String? pays;
  
  const ListeContenusPage({
    super.key,
    this.categorie,
    this.pays,
  });

  @override
  State<ListeContenusPage> createState() => _ListeContenusPageState();
}

class _ListeContenusPageState extends State<ListeContenusPage>
    with TickerProviderStateMixin {
  
  late AnimationController _controllerAnimation;
  late Animation<double> _animationFade;
  
  final ScrollController _scrollController = ScrollController();
  
  // Filtres
  String? _categorieSelectionnee;
  String? _paysSelectionne;
  TypeContenu? _typeSelectionne;
  String _trierPar = 'recent'; // recent, populaire, ancien
  
  // État
  List<ContenuModele> _contenusAffiches = [];
  bool _chargementEnCours = false;
  bool _peutChargerPlus = false;
  
  @override
  void initState() {
    super.initState();
    
    _initializerEtat();
    _initializerAnimations();
    _chargerContenus();
  }
  
  void _initializerEtat() {
    _categorieSelectionnee = widget.categorie;
    _paysSelectionne = widget.pays;
  }
  
  void _initializerAnimations() {
    _controllerAnimation = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _animationFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controllerAnimation,
      curve: Curves.easeOut,
    ));
    
    _controllerAnimation.forward();
  }
  
  void _chargerContenus() async {
    setState(() {
      _chargementEnCours = true;
    });
    
    final contenuProvider = Provider.of<ContenuProvider>(context, listen: false);
    
    // Appliquer les filtres
    if (_categorieSelectionnee != null) {
      await contenuProvider.chargerContenusParCategorie(_categorieSelectionnee!);
    } else if (_paysSelectionne != null) {
      await contenuProvider.chargerContenusParPays(_paysSelectionne!);
    }
    
    _appliquerFiltresEtTri();
    
    setState(() {
      _chargementEnCours = false;
    });
  }
  
  void _appliquerFiltresEtTri() {
    final contenuProvider = Provider.of<ContenuProvider>(context, listen: false);
    List<ContenuModele> contenus = contenuProvider.contenus;
    
    // Filtrer par type si sélectionné
    if (_typeSelectionne != null) {
      contenus = contenus.where((c) => c.typeContenu == _typeSelectionne).toList();
    }
    
    // Trier
    switch (_trierPar) {
      case 'populaire':
        contenus.sort((a, b) {
          final scoreA = a.nombreVues + (a.nombreLikes * 5) + (a.nombreCommentaires * 3);
          final scoreB = b.nombreVues + (b.nombreLikes * 5) + (b.nombreCommentaires * 3);
          return scoreB.compareTo(scoreA);
        });
        break;
      case 'ancien':
        contenus.sort((a, b) => a.datePublication.compareTo(b.datePublication));
        break;
      case 'recent':
      default:
        contenus.sort((a, b) => b.datePublication.compareTo(a.datePublication));
        break;
    }
    
    _contenusAffiches = contenus;
    _peutChargerPlus = contenus.length > 20; // Simulation pagination
  }
  
  @override
  void dispose() {
    _controllerAnimation.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderSimple(
        titre: _obtenirTitrePage(),
      ),
      body: FadeTransition(
        opacity: _animationFade,
        child: Column(
          children: [
            _construireBarreFiltres(context),
            Expanded(
              child: _construireListeContenus(context),
            ),
          ],
        ),
      ),
    );
  }
  
  String _obtenirTitrePage() {
    if (_categorieSelectionnee != null) {
      return _categorieSelectionnee!;
    }
    if (_paysSelectionne != null) {
      final paysProvider = Provider.of<PaysProvider>(context, listen: false);
      final pays = paysProvider.trouverParCode(_paysSelectionne!);
      return 'Contenus ${pays?.nom ?? _paysSelectionne}';
    }
    return 'Tous les contenus';
  }
  
  Widget _construireBarreFiltres(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TaillesApp.espaceNormal),
      decoration: BoxDecoration(
        color: CouleursApp.blanc,
        boxShadow: [
          BoxShadow(
            color: CouleursApp.grisClair.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Première ligne : Types de contenu
          _construireFiltresTypes(context),
          const SizedBox(height: TaillesApp.espaceNormal),
          
          // Deuxième ligne : Tri et statistiques
          Row(
            children: [
              _construireSecteurTri(context),
              const SizedBox(width: TaillesApp.espaceMin),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _construireStatistiques(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _construireFiltresTypes(BuildContext context) {
    final types = [
      null, // Tous
      ...TypeContenu.values,
    ];
    
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: types.length,
        itemBuilder: (context, index) {
          final type = types[index];
          final estSelectionne = _typeSelectionne == type;
          
          return Container(
            margin: const EdgeInsets.only(right: TaillesApp.espaceMin),
            child: FilterChip(
              label: Text(
                type?.libelle ?? 'Tous',
                style: TextStyle(
                  color: estSelectionne ? CouleursApp.blanc : CouleursApp.grisMoyen,
                  fontWeight: FontWeight.w600,
                ),
              ),
              selected: estSelectionne,
              onSelected: (selectionne) {
                setState(() {
                  _typeSelectionne = selectionne ? type : null;
                });
                _appliquerFiltresEtTri();
              },
              selectedColor: CouleursApp.vertSantePrimaire,
              backgroundColor: CouleursApp.grisClairFond,
              checkmarkColor: CouleursApp.blanc,
            ),
          );
        },
      ),
    );
  }
  
  Widget _construireSecteurTri(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: _trierPar,
      onSelected: (valeur) {
        setState(() {
          _trierPar = valeur;
        });
        _appliquerFiltresEtTri();
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'recent',
          child: Row(
            children: [
              Icon(Icons.schedule, size: 20),
              SizedBox(width: 8),
              Text('Plus récents'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'populaire',
          child: Row(
            children: [
              Icon(Icons.trending_up, size: 20),
              SizedBox(width: 8),
              Text('Plus populaires'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'ancien',
          child: Row(
            children: [
              Icon(Icons.history, size: 20),
              SizedBox(width: 8),
              Text('Plus anciens'),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TaillesApp.espaceNormal,
          vertical: TaillesApp.espaceMin,
        ),
        decoration: BoxDecoration(
          color: CouleursApp.grisClairFond,
          borderRadius: BorderRadius.circular(TaillesApp.rayonPetit),
          border: Border.all(color: CouleursApp.grisClair),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _obtenirIconeTri(),
              size: 16,
              color: CouleursApp.grisMoyen,
            ),
            const SizedBox(width: TaillesApp.espaceMin),
            Text(
              _obtenirLibelleTri(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: CouleursApp.grisMoyen,
              ),
            ),
            const SizedBox(width: TaillesApp.espaceMin),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: CouleursApp.grisMoyen,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _construireStatistiques(BuildContext context) {
    return Text(
      '${_contenusAffiches.length} contenu${_contenusAffiches.length > 1 ? 's' : ''}',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: CouleursApp.grisMoyen,
      ),
    );
  }
  
  Widget _construireListeContenus(BuildContext context) {
    if (_chargementEnCours && _contenusAffiches.isEmpty) {
      return const ChargementWidget(
        message: 'Chargement des contenus...',
        afficherMessage: true,
      );
    }
    
    if (_contenusAffiches.isEmpty) {
      return _construireEtatVide(context);
    }
    
    return Consumer<ContenuProvider>(
      builder: (context, contenuProvider, child) {
        return RefreshIndicator(
          onRefresh: () async {
             _chargerContenus();
          },
          child: _construireGrilleContenus(context, contenuProvider),
        );
      },
    );
  }
  
  Widget _construireGrilleContenus(BuildContext context, ContenuProvider contenuProvider) {
    // Déterminer le type d'affichage selon la taille d'écran
    final largeurEcran = MediaQuery.of(context).size.width;
    final nombreColonnes = largeurEcran > TaillesApp.tablettMax ? 2 : 1;
    final typeAffichage = largeurEcran > TaillesApp.mobileMax 
        ? TypeAffichageCarte.normale 
        : TypeAffichageCarte.compacte;
    
    final nombreElements = _contenusAffiches.length + (_peutChargerPlus ? 1 : 0);

    Widget construireElement(BuildContext context, int index) {
      if (index >= _contenusAffiches.length) {
        return _construireChargementSuivant(context);
      }

      final contenu = _contenusAffiches[index];
      return CarteContenu(
        contenu: contenu,
        typeAffichage: typeAffichage,
        onLike: () => _gererLike(contenu),
        onFavori: () => _gererFavori(contenu),
        onPartage: () => _gererPartage(contenu),
      );
    }

    // Une colonne : liste à hauteur libre (aucun débordement possible)
    if (nombreColonnes == 1) {
      return ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(TaillesApp.espaceNormal),
        itemCount: nombreElements,
        itemBuilder: construireElement,
      );
    }

    return GridView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(TaillesApp.espaceNormal),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 560,
        crossAxisSpacing: TaillesApp.espaceNormal,
        mainAxisSpacing: TaillesApp.espaceNormal,
      ),
      itemCount: nombreElements,
      itemBuilder: construireElement,
    );
  }
  
  Widget _construireChargementSuivant(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_chargementEnCours)
            const CircularProgressIndicator()
          else
            BoutonPersonnalise(
              texte: 'Charger plus',
              type: TypeBouton.secondaire,
              onPressed: () => _chargerPlus(),
            ),
        ],
      ),
    );
  }
  
  Widget _construireEtatVide(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TaillesApp.espaceGrand),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: CouleursApp.grisClair.withOpacity(0.3),
                borderRadius: BorderRadius.circular(TaillesApp.rayonTresGrand),
              ),
              child: Icon(
                Icons.inbox_outlined,
                size: 64,
                color: CouleursApp.grisMoyen.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: TaillesApp.espaceGrand),
            Text(
              'Aucun contenu trouvé',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: CouleursApp.grisFonce,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: TaillesApp.espaceNormal),
            Text(
              _obtenirMessageEtatVide(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: CouleursApp.grisMoyen,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TaillesApp.espaceGrand),
            Column(
              children: [
                BoutonPersonnalise(
                  texte: 'Effacer les filtres',
                  icone: Icons.clear_all,
                  type: TypeBouton.primaire,
                  onPressed: () => _effacerFiltres(),
                ),
                const SizedBox(height: TaillesApp.espaceNormal),
                BoutonPersonnalise(
                  texte: 'Retour à l\'accueil',
                  type: TypeBouton.secondaire,
                  onPressed: () => NavigationService.allerAccueil(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  String _obtenirMessageEtatVide() {
    if (_categorieSelectionnee != null) {
      return 'Aucun contenu disponible dans la catégorie "$_categorieSelectionnee".';
    }
    if (_paysSelectionne != null) {
      return 'Aucun contenu disponible pour ce pays.';
    }
    if (_typeSelectionne != null) {
      return 'Aucun ${_typeSelectionne!.libelle.toLowerCase()} disponible.';
    }
    return 'Aucun contenu disponible pour le moment.';
  }
  
  // Actions sur les contenus
  
  Future<void> _gererLike(ContenuModele contenu) async {
    final contenuProvider = Provider.of<ContenuProvider>(context, listen: false);
    await contenuProvider.basculerLike(contenu.id);
    _appliquerFiltresEtTri();
  }
  
  Future<void> _gererFavori(ContenuModele contenu) async {
    final contenuProvider = Provider.of<ContenuProvider>(context, listen: false);
    final success = await contenuProvider.basculerFavori(contenu.id);
    
    if (success) {
      _appliquerFiltresEtTri();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            contenu.estFavori 
                ? 'Retiré des favoris'
                : 'Ajouté aux favoris',
          ),
          backgroundColor: CouleursApp.successVert,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
  
  void _gererPartage(ContenuModele contenu) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Partage de "${contenu.titre}"'),
        action: SnackBarAction(
          label: 'Copier',
          onPressed: () {
          },
        ),
      ),
    );
  }
  
  // Actions de filtrage et tri
  
  void _effacerFiltres() {
    setState(() {
      _typeSelectionne = null;
      _trierPar = 'recent';
    });
    _appliquerFiltresEtTri();
  }
  
  Future<void> _chargerPlus() async {
    if (_chargementEnCours) return;
    
    setState(() {
      _chargementEnCours = true;
    });
    
    // Simulation chargement plus de contenus
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _chargementEnCours = false;
      _peutChargerPlus = false; // Pas plus de contenu pour cette simulation
    });
  }
  
  // Méthodes utilitaires
  
  IconData _obtenirIconeTri() {
    switch (_trierPar) {
      case 'populaire':
        return Icons.trending_up;
      case 'ancien':
        return Icons.history;
      case 'recent':
      default:
        return Icons.schedule;
    }
  }
  
  String _obtenirLibelleTri() {
    switch (_trierPar) {
      case 'populaire':
        return 'Populaires';
      case 'ancien':
        return 'Anciens';
      case 'recent':
      default:
        return 'Récents';
    }
  }
}

/// Widget pour afficher les filtres avancés
class FiltresAvances extends StatefulWidget {
  final String? categorieSelectionnee;
  final String? paysSelectionne;
  final TypeContenu? typeSelectionne;
  final Function(String?, String?, TypeContenu?) onFiltresChanged;
  
  const FiltresAvances({
    super.key,
    this.categorieSelectionnee,
    this.paysSelectionne,
    this.typeSelectionne,
    required this.onFiltresChanged,
  });

  @override
  State<FiltresAvances> createState() => _FiltresAvancesState();
}

class _FiltresAvancesState extends State<FiltresAvances> {
  String? _categorieSelectionnee;
  String? _paysSelectionne;
  TypeContenu? _typeSelectionne;
  
  @override
  void initState() {
    super.initState();
    _categorieSelectionnee = widget.categorieSelectionnee;
    _paysSelectionne = widget.paysSelectionne;
    _typeSelectionne = widget.typeSelectionne;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TaillesApp.espaceGrand),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtres avancés',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: TaillesApp.espaceGrand),
          
          // Filtre par catégorie
          _construireFiltreCategorie(context),
          const SizedBox(height: TaillesApp.espaceGrand),
          
          // Filtre par pays
          _construireFiltrePays(context),
          const SizedBox(height: TaillesApp.espaceGrand),
          
          // Filtre par type
          _construireFiltreType(context),
          const SizedBox(height: TaillesApp.espaceGrand),
          
          // Actions
          Row(
            children: [
              Expanded(
                child: BoutonPersonnalise(
                  texte: 'Effacer',
                  type: TypeBouton.secondaire,
                  onPressed: () {
                    _categorieSelectionnee = null;
                    _paysSelectionne = null;
                    _typeSelectionne = null;
                    widget.onFiltresChanged(null, null, null);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: TaillesApp.espaceNormal),
              Expanded(
                child: BoutonPersonnalise(
                  texte: 'Appliquer',
                  type: TypeBouton.primaire,
                  onPressed: () {
                    widget.onFiltresChanged(
                      _categorieSelectionnee,
                      _paysSelectionne,
                      _typeSelectionne,
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _construireFiltreCategorie(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catégorie',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TaillesApp.espaceMin),
        DropdownButtonFormField<String>(
          value: _categorieSelectionnee,
          decoration: const InputDecoration(
            hintText: 'Toutes les catégories',
            border: OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('Toutes les catégories'),
            ),
            ...ConstantesApp.categoriesSante.map((categorie) {
              return DropdownMenuItem(
                value: categorie,
                child: Text(categorie),
              );
            }),
          ],
          onChanged: (valeur) {
            setState(() {
              _categorieSelectionnee = valeur;
            });
          },
        ),
      ],
    );
  }
  
  Widget _construireFiltrePays(BuildContext context) {
    return Consumer<PaysProvider>(
      builder: (context, paysProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pays',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: TaillesApp.espaceMin),
            DropdownButtonFormField<String>(
              value: _paysSelectionne,
              decoration: const InputDecoration(
                hintText: 'Tous les pays',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Tous les pays'),
                ),
                ...paysProvider.paysOrdonnes.map((pays) {
                  return DropdownMenuItem(
                    value: pays.code,
                    child: Row(
                      children: [
                        Text(pays.emojeDrapeau),
                        const SizedBox(width: TaillesApp.espaceMin),
                        Text(pays.nom),
                      ],
                    ),
                  );
                }),
              ],
              onChanged: (valeur) {
                setState(() {
                  _paysSelectionne = valeur;
                });
              },
            ),
          ],
        );
      },
    );
  }
  
  Widget _construireFiltreType(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type de contenu',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TaillesApp.espaceMin),
        DropdownButtonFormField<TypeContenu>(
          value: _typeSelectionne,
          decoration: const InputDecoration(
            hintText: 'Tous les types',
            border: OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('Tous les types'),
            ),
            ...TypeContenu.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Row(
                  children: [
                    Text(type.icone),
                    const SizedBox(width: TaillesApp.espaceMin),
                    Text(type.libelle),
                  ],
                ),
              );
            }),
          ],
          onChanged: (valeur) {
            setState(() {
              _typeSelectionne = valeur;
            });
          },
        ),
      ],
    );
  }
}