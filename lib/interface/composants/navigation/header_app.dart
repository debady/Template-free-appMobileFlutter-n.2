// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../donnees/providers/authentification_provider.dart';
import '../../../donnees/providers/pays_provider.dart';
import '../../../config/couleurs_app.dart';
import '../../../config/tailles_app.dart';
import '../../../config/constantes_app.dart';
import '../../../utilitaires/navigation/routes_app.dart';
import '../communs/bouton_personnalise.dart';

/// Header principal de l'application MediPlus
/// Contient le logo, la sélection de pays, la recherche et les boutons utilisateur
class HeaderApp extends StatefulWidget implements PreferredSizeWidget {
  final bool afficherRetour;
  final String? titrePersonnalise;
  final List<Widget>? actionsPersonnalisees;
  final bool afficherSelectionPays;
  final bool afficherRecherche;
  final bool afficherMenuUtilisateur;
  final VoidCallback? onRetour;

  const HeaderApp({
    super.key,
    this.afficherRetour = false,
    this.titrePersonnalise,
    this.actionsPersonnalisees,
    this.afficherSelectionPays = true,
    this.afficherRecherche = true,
    this.afficherMenuUtilisateur = true,
    this.onRetour,
  });

  @override
  State<HeaderApp> createState() => _HeaderAppState();

  @override
  Size get preferredSize => const Size.fromHeight(TaillesApp.hauteurHeader);
}

class _HeaderAppState extends State<HeaderApp> {
  final TextEditingController _controllerRecherche = TextEditingController();
  bool _rechercheActive = false;

  @override
  void dispose() {
    _controllerRecherche.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CouleursApp.blanc,
      elevation: TaillesApp.elevationMin,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: _construireTitre(context),
      actions: _construireActions(context),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: CouleursApp.grisClair.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _construireTitre(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: TaillesApp.espacePetit),
      child: Row(
        children: [
          // Bouton retour ou logo (le logo est masqué pendant la recherche)
          if (widget.afficherRetour)
            _construireBoutonRetour(context)
          else if (!_rechercheActive && widget.titrePersonnalise == null)
            Expanded(child: _construireLogo(context)),

          if (_rechercheActive)
            // La barre de recherche prend toute la place disponible
            Expanded(child: _construireBarreRecherche(context))
          else if (widget.titrePersonnalise != null)
            Expanded(child: _construireTitrePersonnalise(context))
          else if (widget.afficherSelectionPays)
            _construireSelectionPays(context),
        ],
      ),
    );
  }

  Widget _construireLogo(BuildContext context) {
    return GestureDetector(
      onTap: () => NavigationService.allerAccueil(),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: CouleursApp.vertSantePrimaire,
              borderRadius: BorderRadius.circular(TaillesApp.rayonPetit),
            ),
            child: const Icon(
              Icons.health_and_safety,
              color: CouleursApp.blanc,
              size: 22,
            ),
          ),
          const SizedBox(width: TaillesApp.espaceMin),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ConstantesApp.nomApp,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CouleursApp.grisFonce,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Santé pour l\'Afrique',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CouleursApp.grisMoyen,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _construireBoutonRetour(BuildContext context) {
    return IconButton(
      onPressed: widget.onRetour ?? () => NavigationService.retour(),
      icon: const Icon(
        Icons.arrow_back,
        color: CouleursApp.grisFonce,
      ),
      tooltip: 'Retour',
    );
  }

  Widget _construireTitrePersonnalise(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TaillesApp.espaceNormal),
      child: Text(
        widget.titrePersonnalise!,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: CouleursApp.grisFonce,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _construireSelectionPays(BuildContext context) {
    return Consumer<PaysProvider>(
      builder: (context, paysProvider, child) {
        final paysCourant = paysProvider.paysCourant;

        if (paysCourant == null) {
          return const SizedBox();
        }

        return Tooltip(
          message: paysCourant.nom,
          child: InkWell(
            onTap: () => NavigationService.allerSelectionPays(),
            borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
            child: Container(
              margin: const EdgeInsets.only(left: TaillesApp.espaceMin),
              padding: const EdgeInsets.symmetric(
                horizontal: TaillesApp.espaceMin,
                vertical: TaillesApp.espaceTresMin,
              ),
              decoration: BoxDecoration(
                color: CouleursApp.grisClairFond,
                borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
                border: Border.all(
                  color: CouleursApp.grisClair,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    paysCourant.emojeDrapeau,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: TaillesApp.espaceTresMin),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: CouleursApp.grisMoyen,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _construireBarreRecherche(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: TaillesApp.espaceMin),
      decoration: BoxDecoration(
        color: CouleursApp.grisClairFond,
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
        border: Border.all(
          color: CouleursApp.vertSantePrimaire,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controllerRecherche,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Rechercher...',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: TaillesApp.espaceNormal,
            vertical: TaillesApp.espaceMin,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_controllerRecherche.text.isNotEmpty)
                IconButton(
                  onPressed: () {
                    _controllerRecherche.clear();
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.clear,
                    size: 20,
                    color: CouleursApp.grisMoyen,
                  ),
                ),
              IconButton(
                onPressed: () => _effectuerRecherche(),
                icon: const Icon(
                  Icons.search,
                  size: 20,
                  color: CouleursApp.vertSantePrimaire,
                ),
              ),
            ],
          ),
        ),
        onSubmitted: (_) => _effectuerRecherche(),
        onChanged: (valeur) => setState(() {}),
      ),
    );
  }

  List<Widget> _construireActions(BuildContext context) {
    final actions = <Widget>[];

    // Actions personnalisées
    if (widget.actionsPersonnalisees != null) {
      actions.addAll(widget.actionsPersonnalisees!);
    }

    // Bouton recherche
    if (widget.afficherRecherche && !_rechercheActive) {
      actions.add(_construireBoutonRecherche(context));
    }

    // Fermer recherche
    if (_rechercheActive) {
      actions.add(_construireBoutonFermerRecherche(context));
    }

    // Menu utilisateur
    if (widget.afficherMenuUtilisateur && !_rechercheActive) {
      actions.add(_construireMenuUtilisateur(context));
    }

    return actions;
  }

  Widget _construireBoutonRecherche(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          _rechercheActive = true;
        });
      },
      icon: const Icon(
        Icons.search,
        color: CouleursApp.grisFonce,
      ),
      tooltip: 'Rechercher',
    );
  }

  Widget _construireBoutonFermerRecherche(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          _rechercheActive = false;
          _controllerRecherche.clear();
        });
      },
      icon: const Icon(
        Icons.close,
        color: CouleursApp.grisFonce,
      ),
      tooltip: 'Fermer recherche',
    );
  }

  Widget _construireMenuUtilisateur(BuildContext context) {
    return Consumer<AuthentificationProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.estConnecte) {
          return _construireMenuUtilisateurConnecte(context, authProvider);
        } else {
          return _construireBoutonsConnexion(context);
        }
      },
    );
  }

  Widget _construireMenuUtilisateurConnecte(
    BuildContext context,
    AuthentificationProvider authProvider,
  ) {
    final utilisateur = authProvider.utilisateurCourant!;

    return PopupMenuButton<String>(
      onSelected: (valeur) => _gererActionMenuUtilisateur(valeur, context),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profil',
          child: Row(
            children: [
              Icon(Icons.person, color: CouleursApp.grisMoyen),
              const SizedBox(width: TaillesApp.espaceMin),
              const Text('Mon profil'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'favoris',
          child: Row(
            children: [
              Icon(Icons.bookmark, color: CouleursApp.grisMoyen),
              const SizedBox(width: TaillesApp.espaceMin),
              const Text('Mes favoris'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'historique',
          child: Row(
            children: [
              Icon(Icons.history, color: CouleursApp.grisMoyen),
              const SizedBox(width: TaillesApp.espaceMin),
              const Text('Historique'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'parametres',
          child: Row(
            children: [
              Icon(Icons.settings, color: CouleursApp.grisMoyen),
              const SizedBox(width: TaillesApp.espaceMin),
              const Text('Paramètres'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'deconnexion',
          child: Row(
            children: [
              Icon(Icons.logout, color: CouleursApp.erreurRouge),
              const SizedBox(width: TaillesApp.espaceMin),
              Text(
                'Se déconnecter',
                style: TextStyle(color: CouleursApp.erreurRouge),
              ),
            ],
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(right: TaillesApp.espaceMin),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: CouleursApp.vertSantePrimaire,
              backgroundImage: utilisateur.photoProfil != null
                  ? NetworkImage(utilisateur.photoProfil!)
                  : null,
              child: utilisateur.photoProfil == null
                  ? Text(
                      utilisateur.initiales,
                      style: const TextStyle(
                        color: CouleursApp.blanc,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: TaillesApp.espaceTresMin),
            Icon(
              Icons.keyboard_arrow_down,
              color: CouleursApp.grisMoyen,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _construireBoutonsConnexion(BuildContext context) {
    // Sur petit écran, un seul bouton icône pour éviter le débordement
    if (MediaQuery.of(context).size.width < 480) {
      return IconButton(
        onPressed: () => NavigationService.allerConnexion(),
        icon: const Icon(
          Icons.account_circle_outlined,
          color: CouleursApp.vertSantePrimaire,
        ),
        tooltip: 'Connexion / Inscription',
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () => NavigationService.allerConnexion(),
          child: const Text('Connexion'),
        ),
        const SizedBox(width: TaillesApp.espaceMin),
        BoutonPersonnalise(
          texte: 'Inscription',
          type: TypeBouton.primaire,
          onPressed: () => NavigationService.allerInscription(),
          largeur: 100,
          hauteur: 36,
        ),
      ],
    );
  }

  void _effectuerRecherche() {
    final requete = _controllerRecherche.text.trim();
    if (requete.isNotEmpty) {
      NavigationService.allerRecherche(requete: requete);
      setState(() {
        _rechercheActive = false;
        _controllerRecherche.clear();
      });
    }
  }

  void _gererActionMenuUtilisateur(String action, BuildContext context) {
    switch (action) {
      case 'profil':
        NavigationService.allerProfil();
        break;
      case 'favoris':
        NavigationService.allerFavoris();
        break;
      case 'historique':
        NavigationService.allerHistorique();
        break;
      case 'parametres':
        NavigationService.allerParametres();
        break;
      case 'deconnexion':
        _confirmerDeconnexion(context);
        break;
    }
  }

  void _confirmerDeconnexion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          BoutonPersonnalise(
            texte: 'Se déconnecter',
            type: TypeBouton.primaire,
            couleur: CouleursApp.erreurRouge,
            onPressed: () async {
              Navigator.of(context).pop();
              final authProvider = Provider.of<AuthentificationProvider>(
                context,
                listen: false,
              );
              await authProvider.deconnecter();
              NavigationService.allerAccueil();
            },
          ),
        ],
      ),
    );
  }
}

/// Header simplifié pour les pages secondaires
class HeaderSimple extends StatelessWidget implements PreferredSizeWidget {
  final String titre;
  final List<Widget>? actions;
  final VoidCallback? onRetour;

  const HeaderSimple({
    super.key,
    required this.titre,
    this.actions,
    this.onRetour,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CouleursApp.blanc,
      elevation: TaillesApp.elevationMin,
      leading: IconButton(
        onPressed: onRetour ?? () => NavigationService.retour(),
        icon: const Icon(
          Icons.arrow_back,
          color: CouleursApp.grisFonce,
        ),
      ),
      title: Text(
        titre,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: CouleursApp.grisFonce,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Header transparent pour les pages avec image de fond
class HeaderTransparent extends StatelessWidget implements PreferredSizeWidget {
  final String? titre;
  final List<Widget>? actions;
  final VoidCallback? onRetour;
  final Color couleurIcones;

  const HeaderTransparent({
    super.key,
    this.titre,
    this.actions,
    this.onRetour,
    this.couleurIcones = CouleursApp.blanc,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: onRetour ?? () => NavigationService.retour(),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: CouleursApp.overlay,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.arrow_back,
            color: couleurIcones,
            size: 20,
          ),
        ),
      ),
      title: titre != null
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TaillesApp.espaceNormal,
                vertical: TaillesApp.espaceMin,
              ),
              decoration: BoxDecoration(
                color: CouleursApp.overlay,
                borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
              ),
              child: Text(
                titre!,
                style: TextStyle(
                  color: couleurIcones,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      actions: actions?.map((action) {
        return Container(
          margin: const EdgeInsets.only(right: TaillesApp.espaceMin),
          decoration: BoxDecoration(
            color: CouleursApp.overlay,
            borderRadius: BorderRadius.circular(20),
          ),
          child: action,
        );
      }).toList(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}