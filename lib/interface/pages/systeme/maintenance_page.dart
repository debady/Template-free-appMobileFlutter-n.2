// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:async';
import '../../../config/couleurs_app.dart';
import '../../../config/tailles_app.dart';
import '../../../config/constantes_app.dart';
import '../../../utilitaires/navigation/routes_app.dart';
import '../../composants/communs/bouton_personnalise.dart';

/// Page de maintenance système
class MaintenancePage extends StatefulWidget {
  final DateTime? heureFinPrevue;
  final String? messagePersonnalise;
  final bool maintenanceProgrammee;
  
  const MaintenancePage({
    super.key,
    this.heureFinPrevue,
    this.messagePersonnalise,
    this.maintenanceProgrammee = false,
  });

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage>
    with TickerProviderStateMixin {
  
  late AnimationController _controllerRotation;
  late AnimationController _controllerPulsation;
  late Animation<double> _animationRotation;
  late Animation<double> _animationPulsation;
  
  Timer? _timerActualisation;
  Timer? _timerCompteRebours;
  Duration? _tempsRestant;
  
  @override
  void initState() {
    super.initState();
    
    _initializerAnimations();
    _initializerTimers();
  }
  
  void _initializerAnimations() {
    _controllerRotation = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _controllerPulsation = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _animationRotation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controllerRotation,
      curve: Curves.linear,
    ));
    
    _animationPulsation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controllerPulsation,
      curve: Curves.easeInOut,
    ));
    
    _controllerRotation.repeat();
    // _controleurPulsation.repeat(reverse: true);
  }
  
  void _initializerTimers() {
    // Timer pour actualiser la page toutes les 30 secondes
    _timerActualisation = Timer.periodic(
      const Duration(seconds: 30),
      (timer) => _verifierFinMaintenance(),
    );
    
    // Timer pour le compte à rebours si heure de fin prévue
    if (widget.heureFinPrevue != null) {
      _calculerTempsRestant();
      _timerCompteRebours = Timer.periodic(
        const Duration(seconds: 1),
        (timer) => _mettreAJourCompteRebours(),
      );
    }
  }
  
  void _calculerTempsRestant() {
    if (widget.heureFinPrevue != null) {
      final maintenant = DateTime.now();
      if (widget.heureFinPrevue!.isAfter(maintenant)) {
        _tempsRestant = widget.heureFinPrevue!.difference(maintenant);
      } else {
        _tempsRestant = Duration.zero;
      }
    }
  }
  
  void _mettreAJourCompteRebours() {
    if (mounted) {
      setState(() {
        _calculerTempsRestant();
        if (_tempsRestant != null && _tempsRestant!.inSeconds <= 0) {
          _verifierFinMaintenance();
        }
      });
    }
  }
  
  void _verifierFinMaintenance() {
    // Simulation de vérification de fin de maintenance
    // En réalité, on ferait un appel API pour vérifier le statut
    if (widget.heureFinPrevue != null && DateTime.now().isAfter(widget.heureFinPrevue!)) {
      NavigationService.retourAccueil();
    }
  }
  
  @override
  void dispose() {
    _controllerRotation.dispose();
    _controllerPulsation.dispose();
    _timerActualisation?.cancel();
    _timerCompteRebours?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CouleursApp.grisClairFond,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TaillesApp.espaceGrand),
          child: Column(
            children: [
              const SizedBox(height: TaillesApp.espaceEnorme),
              _construireIllustration(context),
              const SizedBox(height: TaillesApp.espaceGrand),
              _construireTitre(context),
              const SizedBox(height: TaillesApp.espaceNormal),
              _construireMessage(context),
              if (_tempsRestant != null) ...[
                const SizedBox(height: TaillesApp.espaceGrand),
                _construireCompteRebours(context),
              ],
              const SizedBox(height: TaillesApp.espaceGrand),
              _construireInformations(context),
              const SizedBox(height: TaillesApp.espaceEnorme),
              _construireActions(context),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _construireIllustration(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Cercle pulsant en arrière-plan
        AnimatedBuilder(
          animation: _animationPulsation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animationPulsation.value,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: CouleursApp.orangeVitalite.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
        
        // Icône rotative principale
        AnimatedBuilder(
          animation: _animationRotation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _animationRotation.value * 2 * 3.14159,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CouleursApp.orangeVitalite,
                      CouleursApp.orangeVitalite.withOpacity(0.7),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.settings,
                  size: 60,
                  color: CouleursApp.blanc,
                ),
              ),
            );
          },
        ),
        
        // Point central fixe
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: CouleursApp.blanc,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
  
  Widget _construireTitre(BuildContext context) {
    return Text(
      widget.maintenanceProgrammee 
          ? 'Maintenance programmée'
          : 'Maintenance en cours',
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: CouleursApp.grisFonce,
      ),
      textAlign: TextAlign.center,
    );
  }
  
  Widget _construireMessage(BuildContext context) {
    final message = widget.messagePersonnalise ??
        (widget.maintenanceProgrammee 
            ? 'Nous effectuons actuellement une maintenance programmée pour améliorer nos services. L\'application sera bientôt de nouveau disponible.'
            : 'Nous travaillons actuellement sur l\'amélioration de nos services. Merci de votre patience pendant cette courte interruption.');
    
    return Container(
      padding: const EdgeInsets.all(TaillesApp.espaceGrand),
      decoration: BoxDecoration(
        color: CouleursApp.blanc,
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
        boxShadow: [
          BoxShadow(
            color: CouleursApp.grisClair.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: CouleursApp.grisMoyen,
          height: 1.6,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
  
  Widget _construireCompteRebours(BuildContext context) {
    if (_tempsRestant == null || _tempsRestant!.inSeconds <= 0) {
      return const SizedBox();
    }
    
    final heures = _tempsRestant!.inHours;
    final minutes = _tempsRestant!.inMinutes % 60;
    final secondes = _tempsRestant!.inSeconds % 60;
    
    return Container(
      padding: const EdgeInsets.all(TaillesApp.espaceGrand),
      decoration: BoxDecoration(
        gradient: CouleursApp.gradientBleuCalme,
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
      ),
      child: Column(
        children: [
          Text(
            'Temps estimé restant',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CouleursApp.blanc.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: TaillesApp.espaceNormal),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _construireUniteTemps(context, heures, 'Heures'),
              _construireUniteTemps(context, minutes, 'Minutes'),
              _construireUniteTemps(context, secondes, 'Secondes'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _construireUniteTemps(BuildContext context, int valeur, String unite) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: CouleursApp.blanc.withOpacity(0.2),
            borderRadius: BorderRadius.circular(TaillesApp.rayonPetit),
          ),
          child: Center(
            child: Text(
              valeur.toString().padLeft(2, '0'),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: CouleursApp.blanc,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: TaillesApp.espaceMin),
        Text(
          unite,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: CouleursApp.blanc.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
  
  Widget _construireInformations(BuildContext context) {
    return Container(
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
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: CouleursApp.bleuCalme,
                size: 24,
              ),
              const SizedBox(width: TaillesApp.espaceMin),
              Text(
                'Que se passe-t-il ?',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: CouleursApp.grisFonce,
                ),
              ),
            ],
          ),
          const SizedBox(height: TaillesApp.espaceNormal),
          _construireElementInfo(context, 'Amélioration des performances'),
          _construireElementInfo(context, 'Mise à jour de sécurité'),
          _construireElementInfo(context, 'Ajout de nouvelles fonctionnalités'),
          _construireElementInfo(context, 'Optimisation de l\'expérience utilisateur'),
          
          const SizedBox(height: TaillesApp.espaceGrand),
          Container(
            padding: const EdgeInsets.all(TaillesApp.espaceNormal),
            decoration: BoxDecoration(
              color: CouleursApp.vertSanteClair,
              borderRadius: BorderRadius.circular(TaillesApp.rayonPetit),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: CouleursApp.vertSantePrimaire,
                  size: 20,
                ),
                const SizedBox(width: TaillesApp.espaceMin),
                Expanded(
                  child: Text(
                    'Cette page se met à jour automatiquement',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: CouleursApp.grisFonce,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _construireElementInfo(BuildContext context, String texte) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TaillesApp.espaceMin),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: CouleursApp.vertSantePrimaire,
            size: 16,
          ),
          const SizedBox(width: TaillesApp.espaceMin),
          Expanded(
            child: Text(
              texte,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: CouleursApp.grisMoyen,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _construireActions(BuildContext context) {
    return Column(
      children: [
        BoutonPersonnalise(
          texte: 'Actualiser',
          icone: Icons.refresh,
          type: TypeBouton.primaire,
          pleineLargeur: true,
          hauteur: TaillesApp.hauteurBoutonGrand,
          onPressed: () => _verifierFinMaintenance(),
        ),
        
        const SizedBox(height: TaillesApp.espaceNormal),
        
        Text(
          'Merci de votre compréhension',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: CouleursApp.grisMoyen,
            fontStyle: FontStyle.italic,
          ),
        ),
        
        const SizedBox(height: TaillesApp.espaceGrand),
        
        Container(
          padding: const EdgeInsets.all(TaillesApp.espaceNormal),
          decoration: BoxDecoration(
            color: CouleursApp.blanc,
            borderRadius: BorderRadius.circular(TaillesApp.rayonPetit),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.health_and_safety,
                color: CouleursApp.vertSantePrimaire,
                size: 20,
              ),
              const SizedBox(width: TaillesApp.espaceMin),
              Text(
                ConstantesApp.nomApp,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: CouleursApp.grisFonce,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Page de maintenance programmée avec heure de fin
class MaintenanceProgrammeePage extends StatelessWidget {
  final DateTime heureFinPrevue;
  final String? messagePersonnalise;
  
  const MaintenanceProgrammeePage({
    super.key,
    required this.heureFinPrevue,
    this.messagePersonnalise,
  });
  
  @override
  Widget build(BuildContext context) {
    return MaintenancePage(
      heureFinPrevue: heureFinPrevue,
      messagePersonnalise: messagePersonnalise,
      maintenanceProgrammee: true,
    );
  }
}

/// Page de maintenance d'urgence sans heure de fin
class MaintenanceUrgencePage extends StatelessWidget {
  final String? messagePersonnalise;
  
  const MaintenanceUrgencePage({super.key, this.messagePersonnalise});
  
  @override
  Widget build(BuildContext context) {
    return MaintenancePage(
      messagePersonnalise: messagePersonnalise ?? 
          'Nous rencontrons actuellement des problèmes techniques. '
          'Nos équipes travaillent pour résoudre la situation dans les plus brefs délais.',
      maintenanceProgrammee: false,
    );
  }
}