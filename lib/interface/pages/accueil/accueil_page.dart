// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hostonewstv/interface/composants/contenu/carte_contenu.dart';
import 'package:provider/provider.dart';
import '../../../donnees/providers/contenu_provider.dart';
import '../../../donnees/providers/pays_provider.dart';
import '../../../donnees/providers/authentification_provider.dart';
import '../../../donnees/modeles/contenu_modele.dart';
import '../../../config/couleurs_app.dart';
import '../../../config/tailles_app.dart';
import '../../../config/constantes_app.dart';
import '../../../utilitaires/navigation/routes_app.dart';
import '../../composants/navigation/header_app.dart';
import '../../composants/contenu/carrousel_actualites.dart';
import '../../composants/communs/chargement_widget.dart';
import '../../composants/communs/bouton_personnalise.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late AnimationController _controllerAnimation;
  late Animation<double> _animationFadeIn;
  late Animation<Offset> _animationSlide;

  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializerAnimations();

    // ✅ Accès aux providers uniquement après le premier build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _chargerDonnees();
    });
  }

  void _initializerAnimations() {
    _controllerAnimation = AnimationController(
      duration: ConstantesApp.dureeAnimationNormale,
      vsync: this,
    );

    _animationFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controllerAnimation, curve: Curves.easeOut),
    );

    _animationSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controllerAnimation, curve: Curves.easeOut),
    );

    _controllerAnimation.forward();
  }

  Future<void> _chargerDonnees() async {
    final contenuProvider =
        Provider.of<ContenuProvider>(context, listen: false);
    final paysProvider = Provider.of<PaysProvider>(context, listen: false);

    if (!paysProvider.chargementEnCours) {
      await paysProvider.initialiser();
    }
    if (!contenuProvider.chargementEnCours) {
      await contenuProvider.initialiser();
    }
  }

  Future<void> _actualiser() async {
    final contenuProvider =
        Provider.of<ContenuProvider>(context, listen: false);
    await contenuProvider.rafraichir();
  }

  void _gererTapContenu(ContenuModele contenu) {
    NavigationService.allerDetailContenu(contenu.id);
  }

  @override
  void dispose() {
    _controllerAnimation.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: CouleursApp.grisClairFond,
      appBar: const HeaderApp(),
      body: FadeTransition(
        opacity: _animationFadeIn,
        child: SlideTransition(
          position: _animationSlide,
          child: _construireCorps(context),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Corps principal
  // ---------------------------------------------------------------------------

  Widget _construireCorps(BuildContext context) {
    return Consumer3<ContenuProvider, PaysProvider, AuthentificationProvider>(
      builder: (context, contenuProvider, paysProvider, authProvider, _) {
        if (contenuProvider.chargementEnCours &&
            contenuProvider.contenus.isEmpty) {
          return const ChargementWidget(
            message: 'Chargement des contenus...',
            afficherMessage: true,
          );
        }

        if (contenuProvider.messageDErreur != null) {
          return _construireErreur(contenuProvider.messageDErreur!);
        }

        return RefreshIndicator(
          onRefresh: _actualiser,
          color: CouleursApp.vertSantePrimaire,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _construireBanniereAccueil(context, authProvider),
              _construireCarrouselActualites(context, contenuProvider),
              _construireMenuCategories(context),
              _construireContenusPrincipaux(context, contenuProvider),
              _construirePiedPage(context),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Bannière d'accueil
  // ---------------------------------------------------------------------------

  Widget _construireBanniereAccueil(
      BuildContext context, AuthentificationProvider authProvider) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(TaillesApp.espaceNormal),
        child: AnimatedContainer(
          duration: ConstantesApp.dureeAnimationNormale,
          padding: const EdgeInsets.all(TaillesApp.espaceGrand),
          decoration: BoxDecoration(
            gradient: CouleursApp.gradientVertSante,
            borderRadius: BorderRadius.circular(TaillesApp.rayonGrand),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authProvider.estConnecte
                          ? 'Bonjour ${authProvider.utilisateurCourant?.prenom ?? 'Utilisateur'} !'
                          : 'Bienvenue sur ${ConstantesApp.nomApp}',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: CouleursApp.blanc,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: TaillesApp.espaceMin),
                    Text(
                      'Votre source d\'information santé de confiance pour l\'Afrique francophone',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: CouleursApp.blanc.withOpacity(0.9),
                          ),
                    ),
                    const SizedBox(height: TaillesApp.espaceGrand),
                    if (!authProvider.estConnecte)
                      Wrap(
                        spacing: TaillesApp.espaceNormal,
                        runSpacing: TaillesApp.espaceMin,
                        children: [
                          BoutonPersonnalise(
                            texte: 'S\'inscrire',
                            type: TypeBouton.primaire,
                            couleur: CouleursApp.blanc,
                            couleurTexte: CouleursApp.vertSantePrimaire,
                            onPressed: () =>
                                NavigationService.allerInscription(),
                          ),
                          BoutonPersonnalise(
                            texte: 'Se connecter',
                            type: TypeBouton.secondaire,
                            couleur: CouleursApp.blanc,
                            onPressed: () =>
                                NavigationService.allerConnexion(),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(width: TaillesApp.espaceMin),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: CouleursApp.blanc.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(TaillesApp.rayonGrand),
                ),
                child: const Icon(
                  Icons.health_and_safety_outlined,
                  size: 32,
                  color: CouleursApp.blanc,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Carrousel actualités
  // ---------------------------------------------------------------------------

  Widget _construireCarrouselActualites(
      BuildContext context, ContenuProvider contenuProvider) {
    if (contenuProvider.contenusALaUne.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: TaillesApp.espaceNormal),
            child: Row(
              children: [
                Text(
                  'À la une',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CouleursApp.grisFonce,
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => NavigationService.allerListeContenus(),
                  child: const Text('Voir tout'),
                ),
              ],
            ),
          ),
          const SizedBox(height: TaillesApp.espaceNormal),
          CarrouselActualites(
            actualites: contenuProvider.contenusALaUne,
            hauteur: 300,
            onTapActualite: _gererTapContenu,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Menu catégories
  // ---------------------------------------------------------------------------

  Widget _construireMenuCategories(BuildContext context) {
    final categories = ConstantesApp.categoriesSante;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(TaillesApp.espaceNormal),
            child: Text(
              'Catégories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CouleursApp.grisFonce,
                  ),
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                  horizontal: TaillesApp.espaceNormal),
              itemCount: categories.length,
              itemBuilder: (context, index) =>
                  _construireTuileCategorie(context, categories[index], index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construireTuileCategorie(
      BuildContext context, String categorie, int index) {
    final couleurs = [
      CouleursApp.vertSantePrimaire,
      CouleursApp.bleuCalme,
      CouleursApp.orangeVitalite,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];

    final icones = [
      Icons.local_hospital,
      Icons.restaurant,
      Icons.security,
      Icons.bug_report,
      Icons.pregnant_woman,
      Icons.child_care,
      Icons.spa,
      Icons.public,
      Icons.vaccines,
      Icons.clean_hands,
      Icons.favorite,
      Icons.fitness_center,
      Icons.psychology,
    ];

    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: TaillesApp.espaceNormal),
      child: GestureDetector(
        onTap: () =>
            NavigationService.allerListeContenus(categorie: categorie),
        child: Card(
          elevation: TaillesApp.elevationNormale,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  couleurs[index % couleurs.length],
                  couleurs[index % couleurs.length].withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icones[index % icones.length],
                    size: 32, color: CouleursApp.blanc),
                const SizedBox(height: TaillesApp.espaceMin),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: TaillesApp.espaceMin),
                  child: Text(
                    categorie,
                    style: const TextStyle(
                      color: CouleursApp.blanc,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Contenus principaux
  // ---------------------------------------------------------------------------

  Widget _construireContenusPrincipaux(
      BuildContext context, ContenuProvider contenuProvider) {
    return SliverList(
      delegate: SliverChildListDelegate([
        if (contenuProvider.contenusPopulaires.isNotEmpty)
          _construireSectionContenus(
            context,
            'Populaires cette semaine',
            contenuProvider.contenusPopulaires,
            TypeAffichageCarte.normale,
          ),
        const SizedBox(height: TaillesApp.espaceGrand),
        if (contenuProvider.contenusRecents.isNotEmpty)
          _construireSectionContenus(
            context,
            'Derniers ajouts',
            contenuProvider.contenusRecents,
            TypeAffichageCarte.compacte,
          ),
        const SizedBox(height: TaillesApp.espaceGrand),
        if (contenuProvider.livesAProgrammer.isNotEmpty)
          _construireSectionContenus(
            context,
            'Lives à venir',
            contenuProvider.livesAProgrammer,
            TypeAffichageCarte.normale,
          ),
        const SizedBox(height: TaillesApp.espaceGrand),
        if (contenuProvider.livesEnCours.isNotEmpty)
          _construireSectionLivesEnCours(
              context, contenuProvider.livesEnCours),
      ]),
    );
  }

  Widget _construireSectionContenus(
    BuildContext context,
    String titre,
    List<ContenuModele> contenus,
    TypeAffichageCarte typeAffichage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: TaillesApp.espaceNormal),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  titre,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CouleursApp.grisFonce,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () => NavigationService.allerListeContenus(),
                child: const Text('Voir tout'),
              ),
            ],
          ),
        ),
        const SizedBox(height: TaillesApp.espaceNormal),
        SizedBox(
          height: typeAffichage == TypeAffichageCarte.compacte ? 120 : 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: TaillesApp.espaceNormal),
            itemCount: contenus.take(10).length,
            itemBuilder: (context, index) => SizedBox(
              width:
                  typeAffichage == TypeAffichageCarte.compacte ? 300 : 250,
              child: Container(
                margin:
                    const EdgeInsets.only(right: TaillesApp.espaceNormal),
                child: _construireCarteContenu(
                    contenus[index], typeAffichage),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _construireSectionLivesEnCours(
      BuildContext context, List<ContenuModele> lives) {
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: TaillesApp.espaceNormal),
      padding: const EdgeInsets.all(TaillesApp.espaceGrand),
      decoration: BoxDecoration(
        color: CouleursApp.erreurRouge.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
        border: Border.all(
          color: CouleursApp.erreurRouge.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TaillesApp.espaceMin,
                  vertical: TaillesApp.espaceTresMin,
                ),
                decoration: BoxDecoration(
                  color: CouleursApp.erreurRouge,
                  borderRadius:
                      BorderRadius.circular(TaillesApp.rayonPetit),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: CouleursApp.blanc,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: TaillesApp.espaceTresMin),
                    const Text(
                      'LIVE EN COURS',
                      style: TextStyle(
                        color: CouleursApp.blanc,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                '${lives.length} émission${lives.length > 1 ? 's' : ''}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CouleursApp.erreurRouge,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: TaillesApp.espaceNormal),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lives.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: TaillesApp.espaceMin),
            itemBuilder: (_, index) =>
                _construireCarteLiveEnCours(lives[index]),
          ),
        ],
      ),
    );
  }

  Widget _construireCarteLiveEnCours(ContenuModele live) {
    return GestureDetector(
      onTap: () => _gererTapContenu(live),
      child: Container(
        padding: const EdgeInsets.all(TaillesApp.espaceNormal),
        decoration: BoxDecoration(
          color: CouleursApp.blanc,
          borderRadius: BorderRadius.circular(TaillesApp.rayonPetit),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: CouleursApp.erreurRouge,
                borderRadius: BorderRadius.circular(TaillesApp.rayonPetit),
              ),
              child: const Icon(Icons.play_circle_fill,
                  color: CouleursApp.blanc, size: 30),
            ),
            const SizedBox(width: TaillesApp.espaceNormal),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    live.titre,
                    style:
                        Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: TaillesApp.espaceTresMin),
                  Row(
                    children: [
                      Icon(Icons.people,
                          size: 16, color: CouleursApp.grisMoyen),
                      const SizedBox(width: TaillesApp.espaceTresMin),
                      Text(
                        '${live.nombreSpectateurs ?? 0} spectateurs',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: CouleursApp.grisMoyen,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            BoutonPersonnalise(
              texte: 'Rejoindre',
              type: TypeBouton.primaire,
              couleur: CouleursApp.erreurRouge,
              hauteur: 36,
              padding: const EdgeInsets.symmetric(
                  horizontal: TaillesApp.espacePetit),
              onPressed: () => _gererTapContenu(live),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construireCarteContenu(
      ContenuModele contenu, TypeAffichageCarte typeAffichage) {
    final estCompacte = typeAffichage == TypeAffichageCarte.compacte;

    final miniature = Container(
      width: estCompacte ? 110 : double.infinity,
      height: estCompacte ? double.infinity : 140,
      decoration: BoxDecoration(
        color: CouleursApp.grisClair,
        image: contenu.urlMiniature != null
            ? DecorationImage(
                image: NetworkImage(contenu.urlMiniature!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: contenu.urlMiniature == null
          ? Icon(Icons.image, size: 40, color: CouleursApp.grisMoyen)
          : null,
    );

    final texte = Padding(
      padding: const EdgeInsets.all(TaillesApp.espacePetit),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contenu.titre,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (!estCompacte) ...[
            const SizedBox(height: TaillesApp.espaceTresMin),
            Flexible(
              child: Text(
                contenu.descriptionCourte,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const Spacer(),
          Row(
            children: [
              Icon(Icons.schedule, size: 14, color: CouleursApp.grisMoyen),
              const SizedBox(width: TaillesApp.espaceTresMin),
              Flexible(
                child: Text(
                  contenu.tempsEcoule,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CouleursApp.grisMoyen,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: TaillesApp.espaceMin),
              Icon(Icons.visibility_outlined,
                  size: 14, color: CouleursApp.grisMoyen),
              const SizedBox(width: TaillesApp.espaceTresMin),
              Flexible(
                child: Text(
                  '${contenu.nombreVues} vues',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CouleursApp.grisMoyen,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: TaillesApp.espaceTresMin),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _gererTapContenu(contenu),
        child: estCompacte
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [miniature, Expanded(child: texte)],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [miniature, Expanded(child: texte)],
              ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Pied de page
  // ---------------------------------------------------------------------------

  Widget _construirePiedPage(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(TaillesApp.espaceGrand),
        padding: const EdgeInsets.all(TaillesApp.espaceGrand),
        decoration: BoxDecoration(
          color: CouleursApp.grisFonce,
          borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CouleursApp.vertSantePrimaire,
                    borderRadius:
                        BorderRadius.circular(TaillesApp.rayonPetit),
                  ),
                  child: const Icon(Icons.health_and_safety,
                      color: CouleursApp.blanc, size: 24),
                ),
                const SizedBox(width: TaillesApp.espaceNormal),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ConstantesApp.nomApp,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: CouleursApp.blanc,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        ConstantesApp.descriptionApp,
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: CouleursApp.grisClair,
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: TaillesApp.espaceGrand),
            Divider(color: CouleursApp.grisClair.withOpacity(0.3)),
            const SizedBox(height: TaillesApp.espaceNormal),
            Text(
              '© 2024 ${ConstantesApp.nomApp}. Information santé de qualité pour l\'Afrique.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CouleursApp.grisClair,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Écran d'erreur
  // ---------------------------------------------------------------------------

  Widget _construireErreur(String messageErreur) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TaillesApp.espaceGrand),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: CouleursApp.erreurRouge.withOpacity(0.7),
            ),
            const SizedBox(height: TaillesApp.espaceGrand),
            Text(
              'Oups ! Une erreur est survenue',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: CouleursApp.grisFonce,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TaillesApp.espaceNormal),
            Text(
              messageErreur,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CouleursApp.grisMoyen,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TaillesApp.espaceGrand),
            BoutonPersonnalise(
              texte: 'Réessayer',
              icone: Icons.refresh,
              type: TypeBouton.primaire,
              onPressed: _actualiser,
            ),
          ],
        ),
      ),
    );
  }
}