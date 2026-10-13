// ignore_for_file: unreachable_switch_default, deprecated_member_use

import 'package:flutter/material.dart';
import '../../../donnees/modeles/contenu_modele.dart';
import '../../../config/couleurs_app.dart';
import '../../../config/tailles_app.dart';
import '../../../config/theme_app.dart';
import '../../../utilitaires/navigation/routes_app.dart';

/// Types d'affichage pour les cartes de contenu
enum TypeAffichageCarte {
  normale,
  compacte,
  hero,
  liste,
}

/// Carte pour afficher un contenu (article, vidéo, live, etc.)
class CarteContenu extends StatelessWidget {
  final ContenuModele contenu;
  final TypeAffichageCarte typeAffichage;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onFavori;
  final VoidCallback? onPartage;
  final bool afficherAuteur;
  final bool afficherMetadonnees;
  final bool afficherActions;
  
  const CarteContenu({
    super.key,
    required this.contenu,
    this.typeAffichage = TypeAffichageCarte.normale,
    this.onTap,
    this.onLike,
    this.onFavori,
    this.onPartage,
    this.afficherAuteur = true,
    this.afficherMetadonnees = true,
    this.afficherActions = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _naviguerVersDetail(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: _construireCarte(context),
      ),
    );
  }
  
  Widget _construireCarte(BuildContext context) {
    switch (typeAffichage) {
      case TypeAffichageCarte.hero:
        return _carteHero(context);
      case TypeAffichageCarte.compacte:
        return _carteCompacte(context);
      case TypeAffichageCarte.liste:
        return _carteListe(context);
      case TypeAffichageCarte.normale:
      default:
        return _carteNormale(context);
    }
  }
  
  Widget _carteNormale(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(TaillesApp.espaceMin),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _construireMiniature(context, hauteur: 200),
          Padding(
            padding: const EdgeInsets.all(TaillesApp.espaceNormal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _construireBadgeType(),
                const SizedBox(height: TaillesApp.espaceMin),
                _construireTitre(context, maxLines: 2),
                const SizedBox(height: TaillesApp.espaceMin),
                _construireDescription(context),
                if (afficherAuteur) ...[
                  const SizedBox(height: TaillesApp.espaceNormal),
                  _construireInfoAuteur(context),
                ],
                if (afficherMetadonnees) ...[
                  const SizedBox(height: TaillesApp.espaceMin),
                  _construireMetadonnees(context),
                ],
                if (afficherActions) ...[
                  const SizedBox(height: TaillesApp.espaceNormal),
                  _construireActions(context),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _carteCompacte(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: TaillesApp.espaceTresMin),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 100),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _construireMiniature(context, largeur: 120),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(TaillesApp.espacePetit),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        spacing: TaillesApp.espaceMin,
                        runSpacing: TaillesApp.espaceTresMin,
                        children: [
                          _construireBadgeType(),
                          if (contenu.estEnDirecte) _construireBadgeLive(),
                        ],
                      ),
                      const SizedBox(height: TaillesApp.espaceMin),
                      _construireTitre(context, maxLines: 2, taille: 15),
                      const SizedBox(height: TaillesApp.espaceTresMin),
                      _construireMetadonnees(context, compact: true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _carteHero(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(TaillesApp.espaceMin),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            _construireMiniature(context, hauteur: 300),
            _construireOverlayGradient(),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(TaillesApp.espaceGrand),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _construireBadgeType(couleurFond: CouleursApp.blanc),
                        const Spacer(),
                        if (contenu.estEnDirecte)
                          _construireBadgeLive(),
                      ],
                    ),
                    const SizedBox(height: TaillesApp.espaceMin),
                    _construireTitre(context, couleur: CouleursApp.blanc, taille: 20),
                    const SizedBox(height: TaillesApp.espaceMin),
                    _construireDescription(context, couleur: CouleursApp.blanc.withOpacity(0.9)),
                    const SizedBox(height: TaillesApp.espaceMin),
                    _construireMetadonnees(context, couleur: CouleursApp.blanc.withOpacity(0.8)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _carteListe(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: TaillesApp.espaceNormal,
        vertical: TaillesApp.espaceTresMin,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(TaillesApp.espaceNormal),
        leading: _construireMiniature(context, largeur: 80, hauteur: 80),
        title: _construireTitre(context, maxLines: 2),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TaillesApp.espaceTresMin),
            _construireDescription(context, maxLines: 2),
            const SizedBox(height: TaillesApp.espaceMin),
            _construireMetadonnees(context, compact: true),
          ],
        ),
        trailing: _construireBadgeType(),
      ),
    );
  }
  
  Widget _construireMiniature(BuildContext context, {double? largeur, double? hauteur}) {
    return Container(
      width: largeur,
      height: hauteur,
      decoration: BoxDecoration(
        color: CouleursApp.grisClair,
        borderRadius: typeAffichage == TypeAffichageCarte.liste
            ? BorderRadius.circular(TaillesApp.rayonPetit)
            : null,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image de fond ou placeholder
          if (contenu.urlMiniature != null && contenu.urlMiniature!.isNotEmpty)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: typeAffichage == TypeAffichageCarte.liste
                    ? BorderRadius.circular(TaillesApp.rayonPetit)
                    : null,
              ),
              child: Image.network(
                contenu.urlMiniature!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _placeholderImage(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _placeholderImage();
                },
              ),
            )
          else
            _placeholderImage(),
          
          // Overlay pour vidéos et lives
          if (contenu.typeContenu == TypeContenu.video ||
              contenu.typeContenu == TypeContenu.live ||
              contenu.typeContenu == TypeContenu.replay)
            Center(
              child: Container(
                padding: const EdgeInsets.all(TaillesApp.espaceMin),
                decoration: const BoxDecoration(
                  color: CouleursApp.overlay,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  contenu.typeContenu == TypeContenu.live
                      ? Icons.play_circle_fill
                      : Icons.play_arrow,
                  color: CouleursApp.blanc,
                  size: 32,
                ),
              ),
            ),
          
          // Badge durée pour vidéos
          if (contenu.dureeMinutes > 0 && contenu.typeContenu != TypeContenu.article)
            Positioned(
              bottom: TaillesApp.espaceMin,
              right: TaillesApp.espaceMin,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TaillesApp.espaceMin,
                  vertical: TaillesApp.espaceTresMin,
                ),
                decoration: BoxDecoration(
                  color: CouleursApp.overlay,
                  borderRadius: BorderRadius.circular(TaillesApp.rayonMin),
                ),
                child: Text(
                  contenu.dureeFormatee,
                  style: const TextStyle(
                    color: CouleursApp.blanc,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _placeholderImage() {
    return Container(
      color: CouleursApp.grisClair,
      alignment: Alignment.center,
      child: Icon(
        _obtenirIconeType(),
        size: 48,
        color: CouleursApp.grisMoyen,
      ),
    );
  }
  
  Widget _construireTitre(BuildContext context, {Color? couleur, double? taille, int? maxLines}) {
    return Text(
      contenu.titre,
      style: StylesTextePersonnalises.titreCarte.copyWith(
        color: couleur,
        fontSize: taille,
      ),
      maxLines: maxLines ?? 3,
      overflow: TextOverflow.ellipsis,
    );
  }
  
  Widget _construireDescription(BuildContext context, {Color? couleur, int? maxLines}) {
    return Text(
      contenu.descriptionCourte,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: couleur),
      maxLines: maxLines ?? 2,
      overflow: TextOverflow.ellipsis,
    );
  }
  
  Widget _construireBadgeType({Color? couleurFond}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TaillesApp.espaceMin,
        vertical: TaillesApp.espaceTresMin,
      ),
      decoration: BoxDecoration(
        color: couleurFond ?? _obtenirCouleurType(),
        borderRadius: BorderRadius.circular(TaillesApp.rayonMin),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            contenu.typeContenu.icone,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: TaillesApp.espaceTresMin),
          Text(
            contenu.typeContenu.libelle,
            style: StylesTextePersonnalises.badge.copyWith(
              color: couleurFond != null ? CouleursApp.grisFonce : CouleursApp.blanc,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _construireBadgeLive() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TaillesApp.espaceMin,
        vertical: TaillesApp.espaceTresMin,
      ),
      decoration: BoxDecoration(
        color: CouleursApp.erreurRouge,
        borderRadius: BorderRadius.circular(TaillesApp.rayonMin),
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
            'LIVE',
            style: StylesTextePersonnalises.badge,
          ),
        ],
      ),
    );
  }
  
  Widget _construireInfoAuteur(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: CouleursApp.grisClair,
          backgroundImage: contenu.photoAuteur != null
              ? NetworkImage(contenu.photoAuteur!)
              : null,
          child: contenu.photoAuteur == null
              ? Text(
                  contenu.nomAuteur[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: CouleursApp.grisMoyen,
                  ),
                )
              : null,
        ),
        const SizedBox(width: TaillesApp.espaceMin),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contenu.nomAuteur,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                contenu.pays,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: CouleursApp.grisMoyen,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _construireMetadonnees(BuildContext context, {bool compact = false, Color? couleur}) {
    final List<Widget> metadonnees = [];
    
    // Date de publication
    metadonnees.add(
      Text(
        contenu.tempsEcoule,
        style: StylesTextePersonnalises.metadonnees.copyWith(color: couleur),
      ),
    );
    
    // Nombre de vues
    if (contenu.nombreVues > 0) {
      metadonnees.add(
        Text(
          '${_formaterNombre(contenu.nombreVues)} vues',
          style: StylesTextePersonnalises.metadonnees.copyWith(color: couleur),
        ),
      );
    }
    
    // Spectateurs pour les lives
    if (contenu.nombreSpectateurs != null && contenu.estEnDirecte) {
      metadonnees.add(
        Text(
          '${_formaterNombre(contenu.nombreSpectateurs!)} spectateurs',
          style: StylesTextePersonnalises.metadonnees.copyWith(color: couleur),
        ),
      );
    }
    
    if (compact && metadonnees.length > 2) {
      metadonnees.removeRange(2, metadonnees.length);
    }
    
    return Wrap(
      spacing: TaillesApp.espaceMin,
      children: metadonnees.map((widget) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget,
          if (metadonnees.indexOf(widget) < metadonnees.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TaillesApp.espaceTresMin),
              child: Text(
                '•',
                style: StylesTextePersonnalises.metadonnees.copyWith(color: couleur),
              ),
            ),
        ],
      )).toList(),
    );
  }
  
  Widget _construireActions(BuildContext context) {
    return Row(
      children: [
        _boutonAction(
          icone: contenu.aLike ? Icons.favorite : Icons.favorite_border,
          nombre: contenu.nombreLikes,
          actif: contenu.aLike,
          onPressed: onLike,
        ),
        const SizedBox(width: TaillesApp.espaceNormal),
        _boutonAction(
          icone: Icons.comment_outlined,
          nombre: contenu.nombreCommentaires,
          onPressed: () => _naviguerVersDetail(context),
        ),
        const SizedBox(width: TaillesApp.espaceNormal),
        _boutonAction(
          icone: contenu.estFavori ? Icons.bookmark : Icons.bookmark_border,
          actif: contenu.estFavori,
          onPressed: onFavori,
        ),
        const Spacer(),
        _boutonAction(
          icone: Icons.share_outlined,
          onPressed: onPartage,
        ),
      ],
    );
  }
  
  Widget _boutonAction({
    required IconData icone,
    int? nombre,
    bool actif = false,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(TaillesApp.rayonPetit),
      child: Padding(
        padding: const EdgeInsets.all(TaillesApp.espaceMin),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icone,
              size: 20,
              color: actif ? CouleursApp.vertSantePrimaire : CouleursApp.grisMoyen,
            ),
            if (nombre != null && nombre > 0) ...[
              const SizedBox(width: TaillesApp.espaceTresMin),
              Text(
                _formaterNombre(nombre),
                style: StylesTextePersonnalises.metadonnees.copyWith(
                  color: actif ? CouleursApp.vertSantePrimaire : null,
                ),
              ),
            ],
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
  
  // Méthodes utilitaires
  
  void _naviguerVersDetail(BuildContext context) {
    NavigationService.allerDetailContenu(contenu.id);
  }
  
  IconData _obtenirIconeType() {
    switch (contenu.typeContenu) {
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
  
  Color _obtenirCouleurType() {
    switch (contenu.typeContenu) {
      case TypeContenu.video:
      case TypeContenu.replay:
        return CouleursApp.bleuCalme;
      case TypeContenu.live:
        return CouleursApp.erreurRouge;
      case TypeContenu.podcast:
        return CouleursApp.orangeVitalite;
      case TypeContenu.emission:
        return Colors.purple;
      case TypeContenu.article:
      default:
        return CouleursApp.vertSantePrimaire;
    }
  }
  
  String _formaterNombre(int nombre) {
    if (nombre < 1000) return nombre.toString();
    if (nombre < 1000000) return '${(nombre / 1000).toStringAsFixed(1)}k';
    return '${(nombre / 1000000).toStringAsFixed(1)}M';
  }
}