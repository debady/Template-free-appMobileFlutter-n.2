// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../donnees/providers/pays_provider.dart';
import '../../../donnees/modeles/pays_modele.dart';
import '../../../config/couleurs_app.dart';
import '../../../config/tailles_app.dart';
import '../../../utilitaires/navigation/routes_app.dart';
import '../../composants/navigation/header_app.dart';
import '../../composants/communs/bouton_personnalise.dart';
import '../../composants/communs/chargement_widget.dart';

/// Page de sélection du pays pour personnaliser le contenu
class SelectionPaysPage extends StatefulWidget {
  const SelectionPaysPage({super.key});

  @override
  State<SelectionPaysPage> createState() => _SelectionPaysPageState();
}

class _SelectionPaysPageState extends State<SelectionPaysPage>
    with TickerProviderStateMixin {
  
  late AnimationController _controllerAnimation;
  late Animation<double> _animationFade;
  late Animation<Offset> _animationSlide;
  
  final TextEditingController _controllerRecherche = TextEditingController();
  List<PaysModele> _paysAffiches = [];
  String _requeteRecherche = '';
  
  @override
  void initState() {
    super.initState();
    
    _initializerAnimations();
    _initialiserDonnees();
  }
  
  void _initializerAnimations() {
    _controllerAnimation = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _animationFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controllerAnimation,
      curve: Curves.easeOut,
    ));
    
    _animationSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controllerAnimation,
      curve: Curves.easeOut,
    ));
    
    _controllerAnimation.forward();
  }
  
  void _initialiserDonnees() {
    final paysProvider = Provider.of<PaysProvider>(context, listen: false);
    _paysAffiches = paysProvider.paysOrdonnes;
    _controllerRecherche.addListener(_filtrerPays);
  }
  
  void _filtrerPays() {
    final requete = _controllerRecherche.text;
    if (requete != _requeteRecherche) {
      setState(() {
        _requeteRecherche = requete;
        final paysProvider = Provider.of<PaysProvider>(context, listen: false);
        _paysAffiches = paysProvider.rechercherPays(requete);
      });
    }
  }
  
  @override
  void dispose() {
    _controllerAnimation.dispose();
    _controllerRecherche.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderSimple(titre: 'Choisir votre pays'),
      body: Consumer<PaysProvider>(
        builder: (context, paysProvider, child) {
          return FadeTransition(
            opacity: _animationFade,
            child: SlideTransition(
              position: _animationSlide,
              child: Column(
                children: [
                  _construireHeader(context, paysProvider),
                  _construireBarreRecherche(context),
                  Expanded(
                    child: _construireListePays(context, paysProvider),
                  ),
                  _construirePiedPage(context, paysProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _construireHeader(BuildContext context, PaysProvider paysProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TaillesApp.espaceGrand),
      decoration: const BoxDecoration(
        gradient: CouleursApp.gradientVertSante,
      ),
      child: Column(
        children: [
          Icon(
            Icons.public,
            size: 64,
            color: CouleursApp.blanc,
          ),
          const SizedBox(height: TaillesApp.espaceNormal),
          Text(
            'Sélectionnez votre pays',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: CouleursApp.blanc,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: TaillesApp.espaceMin),
          Text(
            'Personnalisez votre expérience avec du contenu adapté à votre région',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CouleursApp.blanc.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TaillesApp.espaceGrand),
          if (paysProvider.paysCourant != null)
            Container(
              padding: const EdgeInsets.all(TaillesApp.espaceNormal),
              decoration: BoxDecoration(
                color: CouleursApp.blanc.withOpacity(0.2),
                borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    paysProvider.paysCourant!.emojeDrapeau,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: TaillesApp.espaceMin),
                  Text(
                    'Actuellement: ${paysProvider.paysCourant!.nom}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CouleursApp.blanc,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _construireBarreRecherche(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(TaillesApp.espaceNormal),
      child: TextField(
        controller: _controllerRecherche,
        decoration: InputDecoration(
          hintText: 'Rechercher un pays...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controllerRecherche.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controllerRecherche.clear();
                    _filtrerPays();
                  },
                )
              : null,
          filled: true,
          fillColor: CouleursApp.blanc,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
  
  Widget _construireListePays(BuildContext context, PaysProvider paysProvider) {
    if (paysProvider.chargementEnCours) {
      return const Center(child: ChargementWidget());
    }
    
    if (_paysAffiches.isEmpty) {
      return _construireEtatVide(context);
    }
    
    // Grouper par région
    final paysParRegion = <String, List<PaysModele>>{};
    for (final pays in _paysAffiches) {
      paysParRegion.putIfAbsent(pays.region, () => []);
      paysParRegion[pays.region]!.add(pays);
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: TaillesApp.espaceNormal),
      itemCount: paysParRegion.length,
      itemBuilder: (context, index) {
        final region = paysParRegion.keys.elementAt(index);
        final paysRegion = paysParRegion[region]!;
        return _construireSectionRegion(context, region, paysRegion, paysProvider);
      },
    );
  }
  
  Widget _construireSectionRegion(
    BuildContext context,
    String region,
    List<PaysModele> pays,
    PaysProvider paysProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TaillesApp.espaceNormal),
          child: Text(
            region,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: CouleursApp.grisFonce,
            ),
          ),
        ),
        ...pays.map((paysCourant) => _construireTuilePays(context, paysCourant, paysProvider)),
        const SizedBox(height: TaillesApp.espaceNormal),
      ],
    );
  }
  
  Widget _construireTuilePays(BuildContext context, PaysModele pays, PaysProvider paysProvider) {
    final estSelectionne = paysProvider.paysCourant?.code == pays.code;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: TaillesApp.espaceMin),
      child: Card(
        elevation: estSelectionne ? TaillesApp.elevationMoyenne : TaillesApp.elevationMin,
        color: estSelectionne ? CouleursApp.vertSanteClair : CouleursApp.blanc,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
          side: estSelectionne 
              ? BorderSide(color: CouleursApp.vertSantePrimaire, width: 2)
              : BorderSide.none,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(TaillesApp.espaceNormal),
          onTap: () => _selectionnerPays(pays, paysProvider),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: estSelectionne 
                  ? CouleursApp.vertSantePrimaire.withOpacity(0.1)
                  : CouleursApp.grisClairFond,
              borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
            ),
            child: Center(
              child: Text(
                pays.emojeDrapeau,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          title: Text(
            pays.nom,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: estSelectionne ? FontWeight.bold : FontWeight.w600,
              color: estSelectionne ? CouleursApp.vertSantePrimaire : CouleursApp.grisFonce,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: TaillesApp.espaceTresMin),
              Text(
                pays.nomComplet,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: CouleursApp.grisMoyen,
                ),
              ),
              const SizedBox(height: TaillesApp.espaceTresMin),
              Row(
                children: [
                  _construireBadgeInfo(
                    context,
                    '${pays.nombreContenus} contenus',
                    Icons.article,
                  ),
                  const SizedBox(width: TaillesApp.espaceMin),
                  _construireBadgeInfo(
                    context,
                    '${pays.nombreCorrespondants} correspondants',
                    Icons.people,
                  ),
                ],
              ),
            ],
          ),
          trailing: estSelectionne 
              ? Icon(
                  Icons.check_circle,
                  color: CouleursApp.vertSantePrimaire,
                  size: 32,
                )
              : Icon(
                  Icons.radio_button_unchecked,
                  color: CouleursApp.grisClair,
                  size: 32,
                ),
        ),
      ),
    );
  }
  
  Widget _construireBadgeInfo(BuildContext context, String texte, IconData icone) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TaillesApp.espaceMin,
        vertical: TaillesApp.espaceTresMin,
      ),
      decoration: BoxDecoration(
        color: CouleursApp.grisClair.withOpacity(0.5),
        borderRadius: BorderRadius.circular(TaillesApp.rayonMin),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icone,
            size: 12,
            color: CouleursApp.grisMoyen,
          ),
          const SizedBox(width: TaillesApp.espaceTresMin),
          Text(
            texte,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: CouleursApp.grisMoyen,
            ),
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
            Icon(
              Icons.search_off,
              size: 64,
              color: CouleursApp.grisMoyen.withOpacity(0.5),
            ),
            const SizedBox(height: TaillesApp.espaceGrand),
            Text(
              'Aucun pays trouvé',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: CouleursApp.grisMoyen,
              ),
            ),
            const SizedBox(height: TaillesApp.espaceNormal),
            Text(
              'Essayez avec un autre terme de recherche',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: CouleursApp.grisMoyen,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TaillesApp.espaceGrand),
            BoutonPersonnalise(
              texte: 'Effacer la recherche',
              type: TypeBouton.secondaire,
              onPressed: () {
                _controllerRecherche.clear();
                _filtrerPays();
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _construirePiedPage(BuildContext context, PaysProvider paysProvider) {
    return Container(
      padding: const EdgeInsets.all(TaillesApp.espaceGrand),
      decoration: BoxDecoration(
        color: CouleursApp.grisClairFond,
        border: Border(
          top: BorderSide(
            color: CouleursApp.grisClair.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              BoutonPersonnalise(
                texte: 'Détecter automatiquement',
                type: TypeBouton.secondaire,
                icone: Icons.my_location,
                onPressed: paysProvider.chargementEnCours 
                    ? null 
                    : () => _detecterPaysAutomatiquement(paysProvider),
                chargementEnCours: paysProvider.chargementEnCours,
              ),
              const Spacer(),
              BoutonPersonnalise(
                texte: 'Confirmer',
                type: TypeBouton.primaire,
                icone: Icons.check,
                onPressed: () => NavigationService.retour(),
              ),
            ],
          ),
          const SizedBox(height: TaillesApp.espaceNormal),
          Text(
            'Vous pourrez changer de pays à tout moment depuis les paramètres',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: CouleursApp.grisMoyen,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Future<void> _selectionnerPays(PaysModele pays, PaysProvider paysProvider) async {
    // Animation de sélection
    await paysProvider.selectionnerPays(pays.code);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text(pays.emojeDrapeau),
              const SizedBox(width: TaillesApp.espaceMin),
              Expanded(
                child: Text('Pays sélectionné: ${pays.nom}'),
              ),
            ],
          ),
          backgroundColor: CouleursApp.successVert,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
  
  Future<void> _detecterPaysAutomatiquement(PaysProvider paysProvider) async {
    await paysProvider.detecterPaysAutomatiquement();
    
    if (mounted && paysProvider.paysCourant != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text(paysProvider.paysCourant!.emojeDrapeau),
              const SizedBox(width: TaillesApp.espaceMin),
              Expanded(
                child: Text('Pays détecté: ${paysProvider.paysCourant!.nom}'),
              ),
            ],
          ),
          backgroundColor: CouleursApp.successVert,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}