// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:async';
import '../../../donnees/modeles/contenu_modele.dart';
import '../../../config/couleurs_app.dart';
import '../../../config/tailles_app.dart';
import '../../../utilitaires/navigation/routes_app.dart';
import 'carte_contenu.dart';

/// Carrousel automatique pour afficher les actualités principales
class CarrouselActualites extends StatefulWidget {
  final List<ContenuModele> actualites;
  final Duration dureeAffichage;
  final Duration dureeTransition;
  final bool defilementAutomatique;
  final bool afficherIndicateurs;
  final bool permettreGestesUtilisateur;
  final double hauteur;
  final Function(ContenuModele)? onTapActualite;
  
  const CarrouselActualites({
    super.key,
    required this.actualites,
    this.dureeAffichage = const Duration(seconds: 5),
    this.dureeTransition = const Duration(milliseconds: 800),
    this.defilementAutomatique = true,
    this.afficherIndicateurs = true,
    this.permettreGestesUtilisateur = true,
    this.hauteur = 300.0,
    this.onTapActualite,
  });
  
  @override
  State<CarrouselActualites> createState() => _CarrouselActualitesState();
}

class _CarrouselActualitesState extends State<CarrouselActualites>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _controllerTransition;
  late Animation<double> _animationOpacite;
  Timer? _timerDefilement;
  
  int _indexActuel = 0;
  bool _pauseDefilement = false;
  
  @override
  void initState() {
    super.initState();
    
    _pageController = PageController();
    _controllerTransition = AnimationController(
      duration: widget.dureeTransition,
      vsync: this,
    );
    
    _animationOpacite = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controllerTransition,
      curve: Curves.easeInOut,
    ));
    
    _controllerTransition.forward();
    
    if (widget.defilementAutomatique && widget.actualites.isNotEmpty) {
      _demarrerDefilementAutomatique();
    }
  }
  
  @override
  void dispose() {
    _timerDefilement?.cancel();
    _pageController.dispose();
    _controllerTransition.dispose();
    super.dispose();
  }
  
  void _demarrerDefilementAutomatique() {
    _timerDefilement?.cancel();
    _timerDefilement = Timer.periodic(widget.dureeAffichage, (timer) {
      if (!_pauseDefilement && widget.actualites.isNotEmpty && mounted) {
        _allerSuivant();
      }
    });
  }
  
  void _pauserDefilement() {
    setState(() {
      _pauseDefilement = true;
    });
    
    // Reprendre automatiquement après 10 secondes
    Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _pauseDefilement = false;
        });
      }
    });
  }
  
  void _allerSuivant() {
    if (widget.actualites.isEmpty) return;
    
    final prochainIndex = (_indexActuel + 1) % widget.actualites.length;
    _allerIndex(prochainIndex);
  }
  
  void _allerPrecedent() {
    if (widget.actualites.isEmpty) return;
    
    final precedentIndex = _indexActuel == 0 
        ? widget.actualites.length - 1 
        : _indexActuel - 1;
    _allerIndex(precedentIndex);
  }
  
  void _allerIndex(int index) {
    if (index == _indexActuel || widget.actualites.isEmpty) return;
    
    setState(() {
      _indexActuel = index;
    });
    
    _pageController.animateToPage(
      index,
      duration: widget.dureeTransition,
      curve: Curves.easeInOut,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.actualites.isEmpty) {
      return _construireCarrouselVide();
    }
    
    return Container(
      height: widget.hauteur,
      margin: const EdgeInsets.symmetric(horizontal: TaillesApp.espaceNormal),
      child: Stack(
        children: [
          _construirePageView(),
          if (widget.afficherIndicateurs) _construireIndicateurs(),
          if (widget.permettreGestesUtilisateur) _construireBoutonsNavigation(),
          _construireOverlayGradient(),
        ],
      ),
    );
  }
  
  Widget _construireCarrouselVide() {
    return Container(
      height: widget.hauteur,
      margin: const EdgeInsets.symmetric(horizontal: TaillesApp.espaceNormal),
      decoration: BoxDecoration(
        color: CouleursApp.grisClair,
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 48,
              color: CouleursApp.grisMoyen,
            ),
            SizedBox(height: TaillesApp.espaceNormal),
            Text(
              'Aucune actualité disponible',
              style: TextStyle(
                color: CouleursApp.grisMoyen,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _construirePageView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _indexActuel = index;
          });
        },
        itemCount: widget.actualites.length,
        itemBuilder: (context, index) {
          return _construireSlideActualite(widget.actualites[index]);
        },
      ),
    );
  }
  
  Widget _construireSlideActualite(ContenuModele actualite) {
    return GestureDetector(
      onTap: () {
        if (widget.onTapActualite != null) {
          widget.onTapActualite!(actualite);
        } else {
          NavigationService.allerDetailContenu(actualite.id);
        }
      },
      onTapDown: (_) => _pauserDefilement(),
      child: AnimatedBuilder(
        animation: _animationOpacite,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _construireImageFond(actualite),
                _construireContenuSuperpose(actualite),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _construireImageFond(ContenuModele actualite) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
        color: CouleursApp.grisClair,
      ),
      child: actualite.urlMiniature != null && actualite.urlMiniature!.isNotEmpty
          ? Image.network(
              actualite.urlMiniature!,
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CouleursApp.vertSanteClair,
            CouleursApp.bleuClair,
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 64,
          color: CouleursApp.grisMoyen,
        ),
      ),
    );
  }
  
  Widget _construireContenuSuperpose(ContenuModele actualite) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            CouleursApp.overlay,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TaillesApp.espaceGrand),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _construireBadgeType(actualite),
                const Spacer(),
                if (actualite.estEnDirecte) _construireBadgeLive(),
              ],
            ),
            const Spacer(),
            _construireInfosContenu(actualite),
          ],
        ),
      ),
    );
  }
  
  Widget _construireBadgeType(ContenuModele actualite) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TaillesApp.espaceMin,
        vertical: TaillesApp.espaceTresMin,
      ),
      decoration: BoxDecoration(
        color: CouleursApp.blanc.withOpacity(0.9),
        borderRadius: BorderRadius.circular(TaillesApp.rayonMin),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            actualite.typeContenu.icone,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: TaillesApp.espaceTresMin),
          Text(
            actualite.typeContenu.libelle,
            style: const TextStyle(
              fontSize: 12,
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
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: CouleursApp.blanc,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _construireInfosContenu(ContenuModele actualite) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          actualite.titre,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: CouleursApp.blanc,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: TaillesApp.espaceMin),
        Text(
          actualite.descriptionCourte,
          style: TextStyle(
            fontSize: 14,
            color: CouleursApp.blanc.withOpacity(0.9),
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: TaillesApp.espaceMin),
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 16,
              color: CouleursApp.blanc.withOpacity(0.8),
            ),
            const SizedBox(width: TaillesApp.espaceTresMin),
            Text(
              actualite.tempsEcoule,
              style: TextStyle(
                fontSize: 12,
                color: CouleursApp.blanc.withOpacity(0.8),
              ),
            ),
            const SizedBox(width: TaillesApp.espaceNormal),
            Icon(
              Icons.visibility,
              size: 16,
              color: CouleursApp.blanc.withOpacity(0.8),
            ),
            const SizedBox(width: TaillesApp.espaceTresMin),
            Text(
              '${_formaterNombre(actualite.nombreVues)} vues',
              style: TextStyle(
                fontSize: 12,
                color: CouleursApp.blanc.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _construireIndicateurs() {
    return Positioned(
      bottom: TaillesApp.espaceNormal,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.actualites.length,
          (index) => _construireIndicateur(index),
        ),
      ),
    );
  }
  
  Widget _construireIndicateur(int index) {
    final estActif = index == _indexActuel;
    
    return GestureDetector(
      onTap: () => _allerIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: estActif ? 24 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: estActif 
              ? CouleursApp.blanc 
              : CouleursApp.blanc.withOpacity(0.4),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
  
  Widget _construireBoutonsNavigation() {
    return Row(
      children: [
        // Bouton précédent
        Positioned(
          left: TaillesApp.espaceNormal,
          top: 0,
          bottom: 0,
          child: Center(
            child: _boutonNavigation(
              icone: Icons.chevron_left,
              onPressed: _allerPrecedent,
            ),
          ),
        ),
        const Spacer(),
        // Bouton suivant
        Positioned(
          right: TaillesApp.espaceNormal,
          top: 0,
          bottom: 0,
          child: Center(
            child: _boutonNavigation(
              icone: Icons.chevron_right,
              onPressed: _allerSuivant,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _boutonNavigation({
    required IconData icone,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: CouleursApp.overlay,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            _pauserDefilement();
            onPressed();
          },
          child: Icon(
            icone,
            color: CouleursApp.blanc,
            size: 24,
          ),
        ),
      ),
    );
  }
  
  Widget _construireOverlayGradient() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(TaillesApp.rayonNormal),
            topRight: Radius.circular(TaillesApp.rayonNormal),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              CouleursApp.overlay.withOpacity(0.3),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
  
  String _formaterNombre(int nombre) {
    if (nombre < 1000) return nombre.toString();
    if (nombre < 1000000) return '${(nombre / 1000).toStringAsFixed(1)}k';
    return '${(nombre / 1000000).toStringAsFixed(1)}M';
  }
}

/// Version simplifiée du carrousel pour les petits écrans
class CarrouselCompact extends StatelessWidget {
  final List<ContenuModele> actualites;
  final double hauteur;
  final Function(ContenuModele)? onTapActualite;
  
  const CarrouselCompact({
    super.key,
    required this.actualites,
    this.hauteur = 200.0,
    this.onTapActualite,
  });
  
  @override
  Widget build(BuildContext context) {
    if (actualites.isEmpty) {
      return SizedBox(
        height: hauteur,
        child: const Center(
          child: Text(
            'Aucune actualité disponible',
            style: TextStyle(
              color: CouleursApp.grisMoyen,
            ),
          ),
        ),
      );
    }
    
    return SizedBox(
      height: hauteur,
      child: PageView.builder(
        itemCount: actualites.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: TaillesApp.espaceMin),
            child: CarteContenu(
              contenu: actualites[index],
              typeAffichage: TypeAffichageCarte.hero,
              onTap: onTapActualite != null 
                  ? () => onTapActualite!(actualites[index])
                  : null,
            ),
          );
        },
      ),
    );
  }
}