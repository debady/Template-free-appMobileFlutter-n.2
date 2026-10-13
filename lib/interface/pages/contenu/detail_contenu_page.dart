// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unreachable_switch_default

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../donnees/providers/contenu_provider.dart';
import '../../../donnees/providers/authentification_provider.dart';
import '../../../donnees/modeles/contenu_modele.dart';
import '../../../config/couleurs_app.dart';
import '../../../config/tailles_app.dart';
import '../../../utilitaires/navigation/routes_app.dart';
import '../../composants/navigation/header_app.dart';
import '../../composants/communs/bouton_personnalise.dart';
import '../../composants/communs/chargement_widget.dart';
import '../systeme/erreur_page.dart';

/// Page de détail d'un contenu (article, vidéo, live, etc.)
class DetailContenuPage extends StatefulWidget {
  final String contenuId;
  
  const DetailContenuPage({
    super.key,
    required this.contenuId,
  });

  @override
  State<DetailContenuPage> createState() => _DetailContenuPageState();
}

class _DetailContenuPageState extends State<DetailContenuPage>
    with TickerProviderStateMixin {
  
  late AnimationController _controllerAnimation;
  late Animation<double> _animationFade;
  late Animation<Offset> _animationSlide;
  
  final ScrollController _scrollController = ScrollController();
  ContenuModele? _contenu;
  bool _chargementEnCours = true;
  bool _estEnFavori = false;
  bool _aLike = false;
  
  @override
  void initState() {
    super.initState();
    
    _initializerAnimations();
    _chargerContenu();
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
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controllerAnimation,
      curve: Curves.easeOut,
    ));
  }
  
  void _chargerContenu() async {
    final contenuProvider = Provider.of<ContenuProvider>(context, listen: false);
    
    // Chercher le contenu par ID
    final contenu = contenuProvider.trouverContenuParId(widget.contenuId);
    
    if (contenu != null) {
      setState(() {
        _contenu = contenu;
        _estEnFavori = contenu.estFavori;
        _aLike = contenu.aLike;
        _chargementEnCours = false;
      });
      
      // Incrémenter les vues
      await contenuProvider.incrementerVues(widget.contenuId);
      
      // Démarrer l'animation
      _controllerAnimation.forward();
    } else {
      // Contenu non trouvé
      setState(() {
        _chargementEnCours = false;
      });
    }
  }
  
  @override
  void dispose() {
    _controllerAnimation.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (_chargementEnCours) {
      return Scaffold(
        appBar: const HeaderSimple(titre: 'Chargement...'),
        body: const Center(child: ChargementWidget()),
      );
    }
    
    if (_contenu == null) {
      return const Scaffold(
        body: Page404(messagePersonnalise: 'Ce contenu n\'existe pas ou n\'est plus disponible.'),
      );
    }
    
    return Scaffold(
      body: FadeTransition(
        opacity: _animationFade,
        child: SlideTransition(
          position: _animationSlide,
          child: _construireCorps(context),
        ),
      ),
    );
  }
  
  Widget _construireCorps(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _construireHeader(context),
        _construireContenuPrincipal(context),
        _construireContenusSimilaires(context),
      ],
    );
  }
  
  Widget _construireHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: CouleursApp.blanc,
      leading: IconButton(
        onPressed: () => NavigationService.retour(),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: CouleursApp.overlay,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.arrow_back,
            color: CouleursApp.blanc,
            size: 20,
          ),
        ),
      ),
      actions: [
        _construireBoutonPartage(context),
        _construireBoutonFavori(context),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _construireImagePrincipale(context),
            _construireOverlayGradient(),
            _construireBadgesHeader(context),
          ],
        ),
      ),
    );
  }
  
  Widget _construireImagePrincipale(BuildContext context) {
    return Container(
      color: CouleursApp.grisClair,
      child: _contenu!.urlMiniature != null && _contenu!.urlMiniature!.isNotEmpty
          ? Image.network(
              _contenu!.urlMiniature!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _imagePlaceholder();
              },
            )
          : _imagePlaceholder(),
    );
  }
  
  Widget _imagePlaceholder() {
    return Container(
      color: CouleursApp.grisClair,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _obtenirIconeType(),
              size: 64,
              color: CouleursApp.grisMoyen,
            ),
            const SizedBox(height: TaillesApp.espaceNormal),
            Text(
              _contenu!.typeContenu.libelle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: CouleursApp.grisMoyen,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _construireOverlayGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            CouleursApp.overlay,
          ],
        ),
      ),
    );
  }
  
  Widget _construireBadgesHeader(BuildContext context) {
    return Positioned(
      bottom: TaillesApp.espaceNormal,
      left: TaillesApp.espaceNormal,
      right: TaillesApp.espaceNormal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _construireBadgeType(),
              const Spacer(),
              if (_contenu!.estEnDirecte) _construireBadgeLive(),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _construireBadgeType() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TaillesApp.espaceNormal,
        vertical: TaillesApp.espaceMin,
      ),
      decoration: BoxDecoration(
        color: CouleursApp.blanc.withOpacity(0.9),
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _contenu!.typeContenu.icone,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: TaillesApp.espaceMin),
          Text(
            _contenu!.typeContenu.libelle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: CouleursApp.grisFonce,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _construireBadgeLive() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TaillesApp.espaceNormal,
        vertical: TaillesApp.espaceMin,
      ),
      decoration: BoxDecoration(
        color: CouleursApp.erreurRouge,
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
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
          const SizedBox(width: TaillesApp.espaceMin),
          const Text(
            'EN DIRECT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: CouleursApp.blanc,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _construireBoutonPartage(BuildContext context) {
    return IconButton(
      onPressed: () => _partagerContenu(),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: CouleursApp.overlay,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.share,
          color: CouleursApp.blanc,
          size: 20,
        ),
      ),
    );
  }
  
  Widget _construireBoutonFavori(BuildContext context) {
    return IconButton(
      onPressed: () => _basculerFavori(),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: CouleursApp.overlay,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          _estEnFavori ? Icons.bookmark : Icons.bookmark_border,
          color: _estEnFavori ? CouleursApp.orangeVitalite : CouleursApp.blanc,
          size: 20,
        ),
      ),
    );
  }
  
  Widget _construireContenuPrincipal(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: CouleursApp.blanc,
        padding: const EdgeInsets.all(TaillesApp.espaceMoyen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _construireTitre(context),
            const SizedBox(height: TaillesApp.espaceNormal),
            _construireMetadonnees(context),
            const SizedBox(height: TaillesApp.espaceGrand),
            _construireDescription(context),
            if (_contenu!.contenuComplet != null) ...[
              const SizedBox(height: TaillesApp.espaceGrand),
              _construireContenuComplet(context),
            ],
            const SizedBox(height: TaillesApp.espaceGrand),
            _construireActions(context),
            const SizedBox(height: TaillesApp.espaceGrand),
            _construireAuteur(context),
          ],
        ),
      ),
    );
  }
  
  Widget _construireTitre(BuildContext context) {
    return Text(
      _contenu!.titre,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: CouleursApp.grisFonce,
        height: 1.3,
      ),
    );
  }
  
  Widget _construireMetadonnees(BuildContext context) {
    return Wrap(
      spacing: TaillesApp.espaceNormal,
      runSpacing: TaillesApp.espaceMin,
      children: [
        _construireMetadonnee(
          Icons.schedule,
          _contenu!.tempsEcoule,
        ),
        _construireMetadonnee(
          Icons.visibility,
          '${_formaterNombre(_contenu!.nombreVues)} vues',
        ),
        if (_contenu!.dureeMinutes > 0)
          _construireMetadonnee(
            Icons.timer,
            _contenu!.dureeFormatee,
          ),
        if (_contenu!.nombreSpectateurs != null && _contenu!.estEnDirecte)
          _construireMetadonnee(
            Icons.people,
            '${_formaterNombre(_contenu!.nombreSpectateurs!)} spectateurs',
          ),
      ],
    );
  }
  
  Widget _construireMetadonnee(IconData icone, String texte) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icone,
          size: 16,
          color: CouleursApp.grisMoyen,
        ),
        const SizedBox(width: TaillesApp.espaceTresMin),
        Text(
          texte,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: CouleursApp.grisMoyen,
          ),
        ),
      ],
    );
  }
  
  Widget _construireDescription(BuildContext context) {
    return Text(
      _contenu!.descriptionCourte,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: CouleursApp.grisFonce,
        height: 1.6,
      ),
    );
  }
  
  Widget _construireContenuComplet(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TaillesApp.espaceNormal),
      decoration: BoxDecoration(
        color: CouleursApp.grisClairFond,
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contenu complet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: CouleursApp.grisFonce,
            ),
          ),
          const SizedBox(height: TaillesApp.espaceNormal),
          Text(
            _contenu!.contenuComplet!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CouleursApp.grisFonce,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _construireActions(BuildContext context) {
    return Consumer<AuthentificationProvider>(
      builder: (context, authProvider, child) {
        return Wrap(
          spacing: TaillesApp.espaceNormal,
          runSpacing: TaillesApp.espaceMin,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _construireActionLike(context),
            _construireActionCommentaires(context),
            if (authProvider.estConnecte)
              _construireActionFavori(context),
          ],
        );
      },
    );
  }
  
  Widget _construireActionLike(BuildContext context) {
    return InkWell(
      onTap: () => _basculerLike(),
      borderRadius: BorderRadius.circular(TaillesApp.rayonPetit),
      child: Padding(
        padding: const EdgeInsets.all(TaillesApp.espaceMin),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _aLike ? Icons.favorite : Icons.favorite_border,
              color: _aLike ? CouleursApp.erreurRouge : CouleursApp.grisMoyen,
              size: 24,
            ),
            const SizedBox(width: TaillesApp.espaceMin),
            Text(
              _formaterNombre(_contenu!.nombreLikes + (_aLike ? 1 : 0)),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _aLike ? CouleursApp.erreurRouge : CouleursApp.grisMoyen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _construireActionCommentaires(BuildContext context) {
    return InkWell(
      onTap: () => _afficherCommentaires(),
      borderRadius: BorderRadius.circular(TaillesApp.rayonPetit),
      child: Padding(
        padding: const EdgeInsets.all(TaillesApp.espaceMin),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.comment_outlined,
              color: CouleursApp.grisMoyen,
              size: 24,
            ),
            const SizedBox(width: TaillesApp.espaceMin),
            Text(
              _formaterNombre(_contenu!.nombreCommentaires),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: CouleursApp.grisMoyen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _construireActionFavori(BuildContext context) {
    return BoutonPersonnalise(
      texte: _estEnFavori ? 'Retirer des favoris' : 'Ajouter aux favoris',
      icone: _estEnFavori ? Icons.bookmark : Icons.bookmark_border,
      type: TypeBouton.secondaire,
      hauteur: 40,
      padding: const EdgeInsets.symmetric(horizontal: TaillesApp.espaceNormal),
      couleur: _estEnFavori ? CouleursApp.orangeVitalite : null,
      onPressed: () => _basculerFavori(),
    );
  }
  
  Widget _construireAuteur(BuildContext context) {
    final nomAuteur = _contenu!.nomAuteur;
    return Container(
      padding: const EdgeInsets.all(TaillesApp.espaceNormal),
      decoration: BoxDecoration(
        color: CouleursApp.grisClairFond,
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: CouleursApp.vertSantePrimaire,
                backgroundImage: _contenu!.photoAuteur != null
                    ? NetworkImage(_contenu!.photoAuteur!)
                    : null,
                child: _contenu!.photoAuteur == null
                    ? Text(
                        nomAuteur.isNotEmpty ? nomAuteur[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: CouleursApp.blanc,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: TaillesApp.espacePetit),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nomAuteur,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CouleursApp.grisFonce,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TaillesApp.espaceTresMin),
                    Text(
                      'Correspondant ${_contenu!.pays}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CouleursApp.grisMoyen,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: TaillesApp.espacePetit),
          BoutonPersonnalise(
            texte: 'Voir le profil',
            type: TypeBouton.secondaire,
            pleineLargeur: true,
            hauteur: 44,
            padding: const EdgeInsets.symmetric(horizontal: TaillesApp.espaceNormal),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fonction à venir')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _construireContenusSimilaires(BuildContext context) {
    return Consumer<ContenuProvider>(
      builder: (context, contenuProvider, child) {
        final contenusCategorie = contenuProvider.contenus
            .where((c) => c.categorie == _contenu!.categorie && c.id != _contenu!.id)
            .take(5)
            .toList();
        
        if (contenusCategorie.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox());
        }
        
        return SliverToBoxAdapter(
          child: Container(
            color: CouleursApp.grisClairFond,
            padding: const EdgeInsets.all(TaillesApp.espaceMoyen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contenus similaires',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CouleursApp.grisFonce,
                  ),
                ),
                const SizedBox(height: TaillesApp.espaceNormal),
                SizedBox(
                  height: 210,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: contenusCategorie.length,
                    itemBuilder: (context, index) {
                      final contenu = contenusCategorie[index];
                      return Container(
                        width: 220,
                        margin: const EdgeInsets.only(right: TaillesApp.espacePetit),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => NavigationService.allerDetailContenu(contenu.id),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: CouleursApp.grisClair,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(TaillesApp.rayonNormal),
                                        topRight: Radius.circular(TaillesApp.rayonNormal),
                                      ),
                                    ),
                                    child: contenu.urlMiniature != null
                                        ? ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(TaillesApp.rayonNormal),
                                              topRight: Radius.circular(TaillesApp.rayonNormal),
                                            ),
                                            child: Image.network(
                                              contenu.urlMiniature!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                          )
                                        : Center(
                                            child: Icon(
                                              Icons.article,
                                              color: CouleursApp.grisMoyen,
                                              size: 32,
                                            ),
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(TaillesApp.espacePetit),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        contenu.titre,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: TaillesApp.espaceTresMin),
                                      Text(
                                        contenu.tempsEcoule,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: CouleursApp.grisMoyen,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Méthodes d'action
  
  Future<void> _basculerFavori() async {
    final contenuProvider = Provider.of<ContenuProvider>(context, listen: false);
    final authProvider = Provider.of<AuthentificationProvider>(context, listen: false);
    
    if (!authProvider.estConnecte) {
      _afficherModalConnexion();
      return;
    }
    
    final success = await contenuProvider.basculerFavori(widget.contenuId);
    if (success) {
      setState(() {
        _estEnFavori = !_estEnFavori;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_estEnFavori 
              ? 'Ajouté aux favoris' 
              : 'Retiré des favoris'),
          backgroundColor: CouleursApp.successVert,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
  
  Future<void> _basculerLike() async {
    final contenuProvider = Provider.of<ContenuProvider>(context, listen: false);
    final authProvider = Provider.of<AuthentificationProvider>(context, listen: false);
    
    if (!authProvider.estConnecte) {
      _afficherModalConnexion();
      return;
    }
    
    final success = await contenuProvider.basculerLike(widget.contenuId);
    if (success) {
      setState(() {
        _aLike = !_aLike;
      });
    }
  }
  
  void _partagerContenu() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonction de partage à venir')),
    );
  }
  
  void _afficherCommentaires() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Section commentaires à venir')),
    );
  }
  
  void _afficherModalConnexion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connexion requise'),
        content: const Text('Vous devez être connecté pour effectuer cette action.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          BoutonPersonnalise(
            texte: 'Se connecter',
            type: TypeBouton.primaire,
            onPressed: () {
              Navigator.of(context).pop();
              NavigationService.allerConnexion();
            },
          ),
        ],
      ),
    );
  }
  
  // Méthodes utilitaires
  
  IconData _obtenirIconeType() {
    switch (_contenu!.typeContenu) {
      case TypeContenu.video:
      case TypeContenu.replay:
        return Icons.play_circle_outline;
      case TypeContenu.live:
        return Icons.live_tv;
      case TypeContenu.podcast:
        return Icons.headphones;
      case TypeContenu.emission:
        return Icons.tv;
      case TypeContenu.article:
      default:
        return Icons.article_outlined;
    }
  }
  
  String _formaterNombre(int nombre) {
    if (nombre < 1000) return nombre.toString();
    if (nombre < 1000000) return '${(nombre / 1000).toStringAsFixed(1)}k';
    return '${(nombre / 1000000).toStringAsFixed(1)}M';
  }
}