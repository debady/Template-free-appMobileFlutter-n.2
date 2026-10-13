// ignore_for_file: deprecated_member_use, unreachable_switch_default

import 'package:flutter/material.dart';
import '../../../config/couleurs_app.dart';
import '../../../config/tailles_app.dart';
import '../../../utilitaires/navigation/routes_app.dart';
import '../../composants/navigation/header_app.dart';
import '../../composants/communs/bouton_personnalise.dart';

/// Types d'erreur pour personnaliser l'affichage
enum TypeErreur {
  reseau,
  serveur,
  nonTrouve,
  acces,
  generale,
}

/// Page d'erreur globale pour l'application
class ErreurPage extends StatelessWidget {
  final String? message;
  final TypeErreur typeErreur;
  final VoidCallback? onReessayer;
  final bool afficherBoutonAccueil;
  
  const ErreurPage({
    super.key,
    this.message,
    this.typeErreur = TypeErreur.generale,
    this.onReessayer,
    this.afficherBoutonAccueil = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderSimple(titre: 'Erreur'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TaillesApp.espaceGrand),
        child: Column(
          children: [
            const SizedBox(height: TaillesApp.espaceEnorme),
            _construireIllustration(context),
            const SizedBox(height: TaillesApp.espaceGrand),
            _construireTitre(context),
            const SizedBox(height: TaillesApp.espaceNormal),
            _construireDescription(context),
            const SizedBox(height: TaillesApp.espaceEnorme),
            _construireActions(context),
            const SizedBox(height: TaillesApp.espaceGrand),
            _construireInformationsTechniques(context),
          ],
        ),
      ),
    );
  }
  
  Widget _construireIllustration(BuildContext context) {
    final InfoErreur info = _obtenirInfoErreur();
    
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: info.couleur.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TaillesApp.rayonTresGrand),
        border: Border.all(
          color: info.couleur.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Icon(
        info.icone,
        size: 60,
        color: info.couleur,
      ),
    );
  }
  
  Widget _construireTitre(BuildContext context) {
    final InfoErreur info = _obtenirInfoErreur();
    
    return Text(
      info.titre,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: CouleursApp.grisFonce,
      ),
      textAlign: TextAlign.center,
    );
  }
  
  Widget _construireDescription(BuildContext context) {
    final String description = message ?? _obtenirInfoErreur().description;
    
    return Text(
      description,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: CouleursApp.grisMoyen,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }
  
  Widget _construireActions(BuildContext context) {
    final InfoErreur info = _obtenirInfoErreur();
    
    return Column(
      children: [
        if (onReessayer != null || info.peutReessayer)
          BoutonPersonnalise(
            texte: 'Réessayer',
            icone: Icons.refresh,
            type: TypeBouton.primaire,
            pleineLargeur: true,
            hauteur: TaillesApp.hauteurBoutonGrand,
            onPressed: onReessayer ?? () => _gererReessai(context),
          ),
        
        if ((onReessayer != null || info.peutReessayer) && afficherBoutonAccueil)
          const SizedBox(height: TaillesApp.espaceNormal),
        
        if (afficherBoutonAccueil)
          BoutonPersonnalise(
            texte: 'Retour à l\'accueil',
            icone: Icons.home,
            type: onReessayer != null || info.peutReessayer 
                ? TypeBouton.secondaire 
                : TypeBouton.primaire,
            pleineLargeur: true,
            hauteur: TaillesApp.hauteurBoutonGrand,
            onPressed: () => NavigationService.retourAccueil(),
          ),
      ],
    );
  }
  
  Widget _construireInformationsTechniques(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TaillesApp.espaceGrand),
      decoration: BoxDecoration(
        color: CouleursApp.grisClairFond,
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
        border: Border.all(
          color: CouleursApp.grisClair.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: CouleursApp.grisMoyen,
              ),
              const SizedBox(width: TaillesApp.espaceMin),
              Text(
                'Informations techniques',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: CouleursApp.grisFonce,
                ),
              ),
            ],
          ),
          const SizedBox(height: TaillesApp.espaceNormal),
          _construireInfoTechnique(context, 'Type d\'erreur', _obtenirCodeErreur()),
          _construireInfoTechnique(context, 'Heure', _obtenirHeureFormatee()),
          _construireInfoTechnique(context, 'Page', _obtenirPageActuelle(context)),
          
          const SizedBox(height: TaillesApp.espaceGrand),
          Text(
            'Si le problème persiste, contactez notre support avec ces informations.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: CouleursApp.grisMoyen,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _construireInfoTechnique(BuildContext context, String label, String valeur) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TaillesApp.espaceMin),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: CouleursApp.grisMoyen,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valeur,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: CouleursApp.grisFonce,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  InfoErreur _obtenirInfoErreur() {
    switch (typeErreur) {
      case TypeErreur.reseau:
        return InfoErreur(
          titre: 'Problème de connexion',
          description: 'Vérifiez votre connexion internet et réessayez.',
          icone: Icons.wifi_off,
          couleur: CouleursApp.orangeVitalite,
          peutReessayer: true,
        );
        
      case TypeErreur.serveur:
        return InfoErreur(
          titre: 'Serveur indisponible',
          description: 'Nos serveurs rencontrent un problème temporaire. Veuillez réessayer dans quelques minutes.',
          icone: Icons.dns,
          couleur: CouleursApp.erreurRouge,
          peutReessayer: true,
        );
        
      case TypeErreur.nonTrouve:
        return InfoErreur(
          titre: 'Page introuvable',
          description: 'La page que vous cherchez n\'existe pas ou a été déplacée.',
          icone: Icons.search_off,
          couleur: CouleursApp.grisMoyen,
          peutReessayer: false,
        );
        
      case TypeErreur.acces:
        return InfoErreur(
          titre: 'Accès non autorisé',
          description: 'Vous n\'avez pas les permissions nécessaires pour accéder à cette ressource.',
          icone: Icons.lock,
          couleur: CouleursApp.orangeVitalite,
          peutReessayer: false,
        );
        
      case TypeErreur.generale:
      default:
        return InfoErreur(
          titre: 'Une erreur est survenue',
          description: 'Nous nous excusons pour ce désagrément. Notre équipe a été notifiée du problème.',
          icone: Icons.error_outline,
          couleur: CouleursApp.erreurRouge,
          peutReessayer: true,
        );
    }
  }
  
  String _obtenirCodeErreur() {
    switch (typeErreur) {
      case TypeErreur.reseau:
        return 'NETWORK_ERROR';
      case TypeErreur.serveur:
        return 'SERVER_ERROR';
      case TypeErreur.nonTrouve:
        return 'NOT_FOUND_404';
      case TypeErreur.acces:
        return 'ACCESS_DENIED_403';
      case TypeErreur.generale:
      default:
        return 'GENERAL_ERROR';
    }
  }
  
  String _obtenirHeureFormatee() {
    final maintenant = DateTime.now();
    return '${maintenant.day.toString().padLeft(2, '0')}/${maintenant.month.toString().padLeft(2, '0')}/${maintenant.year} '
           '${maintenant.hour.toString().padLeft(2, '0')}:${maintenant.minute.toString().padLeft(2, '0')}';
  }
  
  String _obtenirPageActuelle(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route?.settings.name != null) {
      return route!.settings.name!;
    }
    return 'Page inconnue';
  }
  
  void _gererReessai(BuildContext context) {
    // Par défaut, on retourne à la page précédente
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      NavigationService.retourAccueil();
    }
  }
}

/// Classe pour stocker les informations d'une erreur
class InfoErreur {
  final String titre;
  final String description;
  final IconData icone;
  final Color couleur;
  final bool peutReessayer;
  
  const InfoErreur({
    required this.titre,
    required this.description,
    required this.icone,
    required this.couleur,
    required this.peutReessayer,
  });
}

/// Pages d'erreur spécialisées pour des cas d'usage fréquents

/// Page d'erreur réseau
class ErreurReseauPage extends StatelessWidget {
  final VoidCallback? onReessayer;
  
  const ErreurReseauPage({super.key, this.onReessayer});
  
  @override
  Widget build(BuildContext context) {
    return ErreurPage(
      typeErreur: TypeErreur.reseau,
      onReessayer: onReessayer,
    );
  }
}

/// Page d'erreur serveur
class ErreurServeurPage extends StatelessWidget {
  final String? messagePersonnalise;
  final VoidCallback? onReessayer;
  
  const ErreurServeurPage({super.key, this.messagePersonnalise, this.onReessayer});
  
  @override
  Widget build(BuildContext context) {
    return ErreurPage(
      typeErreur: TypeErreur.serveur,
      message: messagePersonnalise,
      onReessayer: onReessayer,
    );
  }
}

/// Page 404 - Page non trouvée
class Page404 extends StatelessWidget {
  final String? messagePersonnalise;
  
  const Page404({super.key, this.messagePersonnalise});
  
  @override
  Widget build(BuildContext context) {
    return ErreurPage(
      typeErreur: TypeErreur.nonTrouve,
      message: messagePersonnalise ?? 'La page demandée n\'a pas été trouvée.',
    );
  }
}

/// Page d'accès refusé
class ErreurAccesPage extends StatelessWidget {
  final String? messagePersonnalise;
  
  const ErreurAccesPage({super.key, this.messagePersonnalise});
  
  @override
  Widget build(BuildContext context) {
    return ErreurPage(
      typeErreur: TypeErreur.acces,
      message: messagePersonnalise,
      afficherBoutonAccueil: true,
    );
  }
}