import 'package:flutter/material.dart';
import '../../../config/couleurs_app.dart';
import '../../../config/tailles_app.dart';

/// Types de boutons disponibles
enum TypeBouton {
  primaire,
  secondaire,
  texte,
  icone,
  flottant,
}

/// Bouton personnalisé réutilisable avec styles cohérents
class BoutonPersonnalise extends StatelessWidget {
  final String? texte;
  final IconData? icone;
  final VoidCallback? onPressed;
  final TypeBouton type;
  final bool chargementEnCours;
  final bool pleineLargeur;
  final double? largeur;
  final double? hauteur;
  final Color? couleur;
  final Color? couleurTexte;
  final EdgeInsets? padding;
  final bool actif;
  
  const BoutonPersonnalise({
    super.key,
    this.texte,
    this.icone,
    this.onPressed,
    this.type = TypeBouton.primaire,
    this.chargementEnCours = false,
    this.pleineLargeur = false,
    this.largeur,
    this.hauteur,
    this.couleur,
    this.couleurTexte,
    this.padding,
    this.actif = true,
  }) : assert(texte != null || icone != null, 'Texte ou icône requis');
  
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: actif ? 1.0 : 0.6,
      child: SizedBox(
        width: pleineLargeur ? double.infinity : largeur,
        height: hauteur ?? _obtenirHauteur(),
        child: _construireBouton(context),
      ),
    );
  }
  
  Widget _construireBouton(BuildContext context) {
    switch (type) {
      case TypeBouton.primaire:
        return _boutonPrimaire(context);
      case TypeBouton.secondaire:
        return _boutonSecondaire(context);
      case TypeBouton.texte:
        return _boutonTexte(context);
      case TypeBouton.icone:
        return _boutonIcone(context);
      case TypeBouton.flottant:
        return _boutonFlottant(context);
    }
  }
  
  Widget _boutonPrimaire(BuildContext context) {
    return ElevatedButton(
      onPressed: _gererAppui(),
      style: ElevatedButton.styleFrom(
        backgroundColor: couleur ?? CouleursApp.vertSantePrimaire,
        foregroundColor: couleurTexte ?? CouleursApp.blanc,
        elevation: actif ? TaillesApp.elevationNormale : 0,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: TaillesApp.espaceGrand,
          vertical: TaillesApp.espaceNormal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
        ),
      ),
      child: _construireContenu(),
    );
  }
  
  Widget _boutonSecondaire(BuildContext context) {
    return OutlinedButton(
      onPressed: _gererAppui(),
      style: OutlinedButton.styleFrom(
        foregroundColor: couleur ?? CouleursApp.vertSantePrimaire,
        side: BorderSide(
          color: couleur ?? CouleursApp.vertSantePrimaire,
          width: 2.0,
        ),
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: TaillesApp.espaceGrand,
          vertical: TaillesApp.espaceNormal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
        ),
      ),
      child: _construireContenu(),
    );
  }
  
  Widget _boutonTexte(BuildContext context) {
    return TextButton(
      onPressed: _gererAppui(),
      style: TextButton.styleFrom(
        foregroundColor: couleur ?? CouleursApp.vertSantePrimaire,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: TaillesApp.espaceNormal,
          vertical: TaillesApp.espaceMin,
        ),
      ),
      child: _construireContenu(),
    );
  }
  
  Widget _boutonIcone(BuildContext context) {
    return Material(
      color: couleur ?? Colors.transparent,
      borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
      child: InkWell(
        onTap: _gererAppui(),
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
        child: Container(
          padding: padding ?? const EdgeInsets.all(TaillesApp.espaceNormal),
          child: Icon(
            icone,
            color: couleurTexte ?? CouleursApp.grisMoyen,
            size: TaillesApp.iconeNormale,
          ),
        ),
      ),
    );
  }
  
  Widget _boutonFlottant(BuildContext context) {
    return FloatingActionButton(
      onPressed: _gererAppui(),
      backgroundColor: couleur ?? CouleursApp.vertSantePrimaire,
      foregroundColor: couleurTexte ?? CouleursApp.blanc,
      elevation: actif ? TaillesApp.elevationNormale : 0,
      child: chargementEnCours
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: CouleursApp.blanc,
                strokeWidth: 2,
              ),
            )
          : Icon(icone),
    );
  }
  
  Widget _construireContenu() {
    if (chargementEnCours) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          color: CouleursApp.blanc,
          strokeWidth: 2,
        ),
      );
    }
    
    if (texte != null && icone != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: TaillesApp.iconeNormale),
          const SizedBox(width: TaillesApp.espaceMin),
          Text(texte!),
        ],
      );
    }
    
    if (icone != null) {
      return Icon(icone, size: TaillesApp.iconeNormale);
    }
    
    return Text(texte!);
  }
  
  VoidCallback? _gererAppui() {
    if (!actif || chargementEnCours || onPressed == null) {
      return null;
    }
    return onPressed;
  }
  
  double _obtenirHauteur() {
    switch (type) {
      case TypeBouton.primaire:
      case TypeBouton.secondaire:
        return TaillesApp.hauteurBoutonNormal;
      case TypeBouton.texte:
        return 36.0;
      case TypeBouton.icone:
        return 48.0;
      case TypeBouton.flottant:
        return 56.0;
    }
  }
}

/// Bouton avec animation de pulsation pour attirer l'attention
class BoutonAvecPulsation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool animationActive;
  
  const BoutonAvecPulsation({
    super.key,
    required this.child,
    this.onPressed,
    this.animationActive = true,
  });
  
  @override
  State<BoutonAvecPulsation> createState() => _BoutonAvecPulsationState();
}

class _BoutonAvecPulsationState extends State<BoutonAvecPulsation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controllerAnimation;
  late Animation<double> _animationEchelle;
  
  @override
  void initState() {
    super.initState();
    
    _controllerAnimation = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _animationEchelle = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controllerAnimation,
      curve: Curves.easeInOut,
    ));
    
    if (widget.animationActive) {
      _controllerAnimation.repeat(reverse: true);
    }
  }
  
  @override
  void didUpdateWidget(BoutonAvecPulsation oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.animationActive != oldWidget.animationActive) {
      if (widget.animationActive) {
        _controllerAnimation.repeat(reverse: true);
      } else {
        _controllerAnimation.stop();
        _controllerAnimation.reset();
      }
    }
  }
  
  @override
  void dispose() {
    _controllerAnimation.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationEchelle,
      builder: (context, child) {
        return Transform.scale(
          scale: _animationEchelle.value,
          child: GestureDetector(
            onTap: widget.onPressed,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Bouton avec feedback haptique personnalisé
class BoutonAvecFeedback extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool feedbackActif;
  
  const BoutonAvecFeedback({
    super.key,
    required this.child,
    this.onPressed,
    this.feedbackActif = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (feedbackActif) {
          // Feedback haptique léger
          // HapticFeedback.lightImpact();
        }
        onPressed?.call();
      },
      child: child,
    );
  }
}

/// Bouton avec état de sélection (toggle)
class BoutonSelection extends StatelessWidget {
  final String texte;
  final bool selectionne;
  final VoidCallback? onPressed;
  final IconData? icone;
  
  const BoutonSelection({
    super.key,
    required this.texte,
    required this.selectionne,
    this.onPressed,
    this.icone,
  });
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: BoutonPersonnalise(
        texte: texte,
        icone: icone,
        onPressed: onPressed,
        type: selectionne ? TypeBouton.primaire : TypeBouton.secondaire,
        couleur: selectionne 
            ? CouleursApp.vertSantePrimaire 
            : CouleursApp.grisClair,
        couleurTexte: selectionne 
            ? CouleursApp.blanc 
            : CouleursApp.grisMoyen,
      ),
    );
  }
}

/// Groupe de boutons avec sélection unique
class GroupeBoutonsSelection extends StatelessWidget {
  final List<String> options;
  final int indexSelectionne;
  final Function(int) onSelectionChange;
  final bool defilementHorizontal;
  
  const GroupeBoutonsSelection({
    super.key,
    required this.options,
    required this.indexSelectionne,
    required this.onSelectionChange,
    this.defilementHorizontal = true,
  });
  
  @override
  Widget build(BuildContext context) {
    final boutonsWidget = List.generate(options.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(right: TaillesApp.espaceMin),
        child: BoutonSelection(
          texte: options[index],
          selectionne: index == indexSelectionne,
          onPressed: () => onSelectionChange(index),
        ),
      );
    });
    
    if (defilementHorizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: TaillesApp.espaceNormal),
        child: Row(children: boutonsWidget),
      );
    }
    
    return Wrap(
      spacing: TaillesApp.espaceMin,
      runSpacing: TaillesApp.espaceMin,
      children: boutonsWidget,
    );
  }
}