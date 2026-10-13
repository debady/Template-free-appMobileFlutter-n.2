// ignore_for_file: deprecated_member_use, unreachable_switch_default

import 'package:flutter/material.dart';
import '../../../donnees/modeles/contenu_modele.dart';
import '../../../config/couleurs_app.dart';
import '../../../config/tailles_app.dart';
import 'carte_contenu.dart';
import '../communs/chargement_widget.dart';

/// Types d'organisation pour les grilles de contenu
enum TypeGrille {
  adaptative,
  fixe,
  liste,
  carrousel,
  staggered,
}

/// Grille adaptative pour afficher des contenus
class GrilleContenus extends StatelessWidget {
  final List<ContenuModele> contenus;
  final TypeGrille typeGrille;
  final TypeAffichageCarte typeAffichageCarte;
  final String? titre;
  final String? sousTitre;
  final bool chargementEnCours;
  final bool peutChargerPlus;
  final VoidCallback? onChargerPlus;
  final VoidCallback? onActualiser;
  final String? messageVide;
  final Widget? widgetVide;
  final Function(ContenuModele)? onLike;
  final Function(ContenuModele)? onFavori;
  final Function(ContenuModele)? onPartage;
  final EdgeInsets? padding;
  final bool afficherTitreBadge;
  final int? nombreMaxItems;
  final ScrollController? controllerScroll;
  
  const GrilleContenus({
    super.key,
    required this.contenus,
    this.typeGrille = TypeGrille.adaptative,
    this.typeAffichageCarte = TypeAffichageCarte.normale,
    this.titre,
    this.sousTitre,
    this.chargementEnCours = false,
    this.peutChargerPlus = false,
    this.onChargerPlus,
    this.onActualiser,
    this.messageVide,
    this.widgetVide,
    this.onLike,
    this.onFavori,
    this.onPartage,
    this.padding,
    this.afficherTitreBadge = false,
    this.nombreMaxItems,
    this.controllerScroll,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titre != null) _construireEnTete(context),
        Expanded(
          child: _construireContenu(context),
        ),
      ],
    );
  }
  
  Widget _construireEnTete(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(TaillesApp.espaceNormal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  titre!,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CouleursApp.grisFonce,
                  ),
                ),
              ),
              if (afficherTitreBadge && contenus.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TaillesApp.espaceMin,
                    vertical: TaillesApp.espaceTresMin,
                  ),
                  decoration: BoxDecoration(
                    color: CouleursApp.vertSantePrimaire.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TaillesApp.rayonPetit),
                  ),
                  child: Text(
                    '${contenus.length}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: CouleursApp.vertSantePrimaire,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (sousTitre != null) ...[
            const SizedBox(height: TaillesApp.espaceTresMin),
            Text(
              sousTitre!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: CouleursApp.grisMoyen,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _construireContenu(BuildContext context) {
    // Gestion des états vides et de chargement
    if (chargementEnCours && contenus.isEmpty) {
      return const Center(child: ChargementWidget());
    }
    
    if (contenus.isEmpty && !chargementEnCours) {
      return _construireEtatVide(context);
    }
    
    // Limitation du nombre d'items si spécifié
    final contenusFiltres = nombreMaxItems != null
        ? contenus.take(nombreMaxItems!).toList()
        : contenus;
    
    // Construction de la grille selon le type
    return _construireGrille(context, contenusFiltres);
  }
  
  Widget _construireEtatVide(BuildContext context) {
    return Center(
      child: widgetVide ?? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: CouleursApp.grisMoyen.withOpacity(0.5),
          ),
          const SizedBox(height: TaillesApp.espaceNormal),
          Text(
            messageVide ?? 'Aucun contenu disponible',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: CouleursApp.grisMoyen,
            ),
            textAlign: TextAlign.center,
          ),
          if (onActualiser != null) ...[
            const SizedBox(height: TaillesApp.espaceGrand),
            ElevatedButton.icon(
              onPressed: onActualiser,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualiser'),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _construireGrille(BuildContext context, List<ContenuModele> contenus) {
    switch (typeGrille) {
      case TypeGrille.liste:
        return _construireListeVerticale(context, contenus);
      case TypeGrille.carrousel:
        return _construireCarrousel(context, contenus);
      case TypeGrille.staggered:
        return _construireGrilleStaggered(context, contenus);
      case TypeGrille.fixe:
        return _construireGrilleFixe(context, contenus);
      case TypeGrille.adaptative:
      default:
        return _construireGrilleAdaptative(context, contenus);
    }
  }
  
  Widget _construireGrilleAdaptative(BuildContext context, List<ContenuModele> contenus) {
    final largeurEcran = MediaQuery.of(context).size.width;
    final nombreColonnes = _obtenirNombreColonnes(largeurEcran);
    
    return RefreshIndicator(
      onRefresh: () async {
        onActualiser?.call();
      },
      child: GridView.builder(
        controller: controllerScroll,
        padding: padding ?? const EdgeInsets.all(TaillesApp.espaceNormal),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: nombreColonnes,
          childAspectRatio: _obtenirRatioAspect(),
          crossAxisSpacing: TaillesApp.espaceNormal,
          mainAxisSpacing: TaillesApp.espaceNormal,
        ),
        itemCount: contenus.length + (peutChargerPlus ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= contenus.length) {
            return _construireChargementSuivant();
          }
          
          return _construireCarte(contenus[index]);
        },
      ),
    );
  }
  
  Widget _construireGrilleFixe(BuildContext context, List<ContenuModele> contenus) {
    return RefreshIndicator(
      onRefresh: () async {
        onActualiser?.call();
      },
      child: GridView.count(
        controller: controllerScroll,
        padding: padding ?? const EdgeInsets.all(TaillesApp.espaceNormal),
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: TaillesApp.espaceNormal,
        mainAxisSpacing: TaillesApp.espaceNormal,
        children: contenus.map((contenu) => _construireCarte(contenu)).toList(),
      ),
    );
  }
  
  Widget _construireListeVerticale(BuildContext context, List<ContenuModele> contenus) {
    return RefreshIndicator(
      onRefresh: () async {
        onActualiser?.call();
      },
      child: ListView.builder(
        controller: controllerScroll,
        padding: padding ?? const EdgeInsets.all(TaillesApp.espaceNormal),
        itemCount: contenus.length + (peutChargerPlus ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= contenus.length) {
            return _construireChargementSuivant();
          }
          
          return _construireCarte(contenus[index]);
        },
      ),
    );
  }
  
  Widget _construireCarrousel(BuildContext context, List<ContenuModele> contenus) {
    return SizedBox(
      height: _obtenirHauteurCarrousel(),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: TaillesApp.espaceNormal),
        itemCount: contenus.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: _obtenirLargeurCarteCarrousel(context),
            child: _construireCarte(contenus[index]),
          );
        },
      ),
    );
  }
  
  Widget _construireGrilleStaggered(BuildContext context, List<ContenuModele> contenus) {
    // Version simplifiée de grille staggered
    // En production, utiliser flutter_staggered_grid_view
    return RefreshIndicator(
      onRefresh: () async {
        onActualiser?.call();
      },
      child: CustomScrollView(
        controller: controllerScroll,
        slivers: [
          SliverPadding(
            padding: padding ?? const EdgeInsets.all(TaillesApp.espaceNormal),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= contenus.length) {
                    return _construireChargementSuivant();
                  }
                  
                  // Alternance de styles pour simuler le staggered
                  final typeAffichage = index.isEven 
                      ? TypeAffichageCarte.normale 
                      : TypeAffichageCarte.compacte;
                  
                  return _construireCarte(contenus[index], typePersonnalise: typeAffichage);
                },
                childCount: contenus.length + (peutChargerPlus ? 1 : 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _construireCarte(ContenuModele contenu, {TypeAffichageCarte? typePersonnalise}) {
    return CarteContenu(
      contenu: contenu,
      typeAffichage: typePersonnalise ?? typeAffichageCarte,
      onLike: onLike != null ? () => onLike!(contenu) : null,
      onFavori: onFavori != null ? () => onFavori!(contenu) : null,
      onPartage: onPartage != null ? () => onPartage!(contenu) : null,
    );
  }
  
  Widget _construireChargementSuivant() {
    return Container(
      margin: const EdgeInsets.all(TaillesApp.espaceNormal),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (chargementEnCours)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: onChargerPlus,
                child: const Text('Charger plus'),
              ),
          ],
        ),
      ),
    );
  }
  
  // Méthodes utilitaires
  
  int _obtenirNombreColonnes(double largeurEcran) {
    if (largeurEcran <= TaillesApp.mobileMax) {
      return typeAffichageCarte == TypeAffichageCarte.compacte ? 1 : 1;
    } else if (largeurEcran <= TaillesApp.tablettMax) {
      return typeAffichageCarte == TypeAffichageCarte.compacte ? 1 : 2;
    } else if (largeurEcran <= TaillesApp.desktopMin) {
      return typeAffichageCarte == TypeAffichageCarte.compacte ? 2 : 3;
    } else {
      return typeAffichageCarte == TypeAffichageCarte.compacte ? 2 : 4;
    }
  }
  
  double _obtenirRatioAspect() {
    switch (typeAffichageCarte) {
      case TypeAffichageCarte.hero:
        return 16 / 9;
      case TypeAffichageCarte.compacte:
        return 3 / 1;
      case TypeAffichageCarte.liste:
        return 4 / 1;
      case TypeAffichageCarte.normale:
      default:
        return 0.75;
    }
  }
  
  double _obtenirHauteurCarrousel() {
    switch (typeAffichageCarte) {
      case TypeAffichageCarte.hero:
        return 300;
      case TypeAffichageCarte.compacte:
        return 120;
      case TypeAffichageCarte.liste:
        return 100;
      case TypeAffichageCarte.normale:
      default:
        return 280;
    }
  }
  
  double _obtenirLargeurCarteCarrousel(BuildContext context) {
    final largeurEcran = MediaQuery.of(context).size.width;
    
    if (largeurEcran <= TaillesApp.mobileMax) {
      return largeurEcran * 0.85;
    } else if (largeurEcran <= TaillesApp.tablettMax) {
      return largeurEcran * 0.6;
    } else {
      return 320;
    }
  }
}

/// Widget pour afficher une section de contenus avec titre
class SectionContenus extends StatelessWidget {
  final String titre;
  final String? sousTitre;
  final List<ContenuModele> contenus;
  final TypeAffichageCarte typeAffichage;
  final VoidCallback? onVoirTout;
  final Function(ContenuModele)? onLike;
  final Function(ContenuModele)? onFavori;
  final bool afficherBadgeNombre;
  final int? nombreMaxAffiche;
  
  const SectionContenus({
    super.key,
    required this.titre,
    this.sousTitre,
    required this.contenus,
    this.typeAffichage = TypeAffichageCarte.normale,
    this.onVoirTout,
    this.onLike,
    this.onFavori,
    this.afficherBadgeNombre = false,
    this.nombreMaxAffiche,
  });
  
  @override
  Widget build(BuildContext context) {
    final contenusFiltres = nombreMaxAffiche != null
        ? contenus.take(nombreMaxAffiche!).toList()
        : contenus;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TaillesApp.espaceNormal),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          titre,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (afficherBadgeNombre && contenus.isNotEmpty) ...[
                          const SizedBox(width: TaillesApp.espaceMin),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TaillesApp.espaceMin,
                              vertical: TaillesApp.espaceTresMin,
                            ),
                            decoration: BoxDecoration(
                              color: CouleursApp.vertSantePrimaire.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(TaillesApp.rayonPetit),
                            ),
                            child: Text(
                              '${contenus.length}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: CouleursApp.vertSantePrimaire,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (sousTitre != null) ...[
                      const SizedBox(height: TaillesApp.espaceTresMin),
                      Text(
                        sousTitre!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CouleursApp.grisMoyen,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onVoirTout != null && contenus.length > (nombreMaxAffiche ?? 0))
                TextButton(
                  onPressed: onVoirTout,
                  child: const Text('Voir tout'),
                ),
            ],
          ),
        ),
        const SizedBox(height: TaillesApp.espaceNormal),
        SizedBox(
          height: typeAffichage == TypeAffichageCarte.compacte ? 120 : 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: TaillesApp.espaceNormal),
            itemCount: contenusFiltres.length,
            itemBuilder: (context, index) {
              final contenu = contenusFiltres[index];
              return SizedBox(
                width: typeAffichage == TypeAffichageCarte.compacte ? 300 : 250,
                child: CarteContenu(
                  contenu: contenu,
                  typeAffichage: typeAffichage,
                  onLike: onLike != null ? () => onLike!(contenu) : null,
                  onFavori: onFavori != null ? () => onFavori!(contenu) : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}