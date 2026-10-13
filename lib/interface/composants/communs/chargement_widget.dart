// ignore_for_file: deprecated_member_use, unreachable_switch_default

import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../config/couleurs_app.dart';
import '../../../config/tailles_app.dart';

/// Types d'animation de chargement
enum TypeChargement {
  circulaire,
  points,
  vague,
  pulsation,
  skeleton,
}

/// Widget de chargement personnalisé avec animations fluides
class ChargementWidget extends StatelessWidget {
  final TypeChargement type;
  final String? message;
  final Color? couleur;
  final double? taille;
  final bool afficherMessage;
  
  const ChargementWidget({
    super.key,
    this.type = TypeChargement.circulaire,
    this.message,
    this.couleur,
    this.taille,
    this.afficherMessage = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _construireIndicateur(context),
          if (afficherMessage && message != null) ...[
            const SizedBox(height: TaillesApp.espaceNormal),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: couleur ?? CouleursApp.grisMoyen,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _construireIndicateur(BuildContext context) {
    switch (type) {
      case TypeChargement.points:
        return ChargementPoints(
          couleur: couleur ?? CouleursApp.vertSantePrimaire,
          taille: taille ?? 8.0,
        );
      case TypeChargement.vague:
        return ChargementVague(
          couleur: couleur ?? CouleursApp.vertSantePrimaire,
          taille: taille ?? 40.0,
        );
      case TypeChargement.pulsation:
        return ChargementPulsation(
          couleur: couleur ?? CouleursApp.vertSantePrimaire,
          taille: taille ?? 40.0,
        );
      case TypeChargement.skeleton:
        return ChargementSkeleton(
          taille: taille ?? 200.0,
        );
      case TypeChargement.circulaire:
      default:
        return SizedBox(
          width: taille ?? 40.0,
          height: taille ?? 40.0,
          child: CircularProgressIndicator(
            color: couleur ?? CouleursApp.vertSantePrimaire,
            strokeWidth: 3.0,
          ),
        );
    }
  }
}

/// Animation de chargement avec points sautillants
class ChargementPoints extends StatefulWidget {
  final Color couleur;
  final double taille;
  
  const ChargementPoints({
    super.key,
    required this.couleur,
    required this.taille,
  });
  
  @override
  State<ChargementPoints> createState() => _ChargementPointsState();
}

class _ChargementPointsState extends State<ChargementPoints>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  
  @override
  void initState() {
    super.initState();
    
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });
    
    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
    
    _demarrerAnimations();
  }
  
  void _demarrerAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 200));
      _controllers[i].repeat(reverse: true);
    }
  }
  
  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.taille * 0.2),
              child: Transform.translate(
                offset: Offset(0, -widget.taille * 0.5 * _animations[index].value),
                child: Container(
                  width: widget.taille,
                  height: widget.taille,
                  decoration: BoxDecoration(
                    color: widget.couleur.withOpacity(
                      0.3 + 0.7 * _animations[index].value,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

/// Animation de chargement en vague
class ChargementVague extends StatefulWidget {
  final Color couleur;
  final double taille;
  
  const ChargementVague({
    super.key,
    required this.couleur,
    required this.taille,
  });
  
  @override
  State<ChargementVague> createState() => _ChargementVagueState();
}

class _ChargementVagueState extends State<ChargementVague>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    
    _controller.repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.taille * 2, widget.taille),
          painter: VaguePainter(
            couleur: widget.couleur,
            progression: _animation.value,
          ),
        );
      },
    );
  }
}

/// Painter pour dessiner l'animation de vague
class VaguePainter extends CustomPainter {
  final Color couleur;
  final double progression;
  
  VaguePainter({required this.couleur, required this.progression});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = couleur
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final path = Path();
    final amplitude = size.height * 0.2;
    final frequency = 2.0;
    final phase = progression * 2 * 3.14159;
    
    for (double x = 0; x <= size.width; x += 1) {
      final y = size.height / 2 + amplitude * 
          math.sin((frequency * x / size.width) * 2 * 3.14159 + phase);
      
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

/// Animation de pulsation
class ChargementPulsation extends StatefulWidget {
  final Color couleur;
  final double taille;
  
  const ChargementPulsation({
    super.key,
    required this.couleur,
    required this.taille,
  });
  
  @override
  State<ChargementPulsation> createState() => _ChargementPulsationState();
}

class _ChargementPulsationState extends State<ChargementPulsation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _controller.repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            width: widget.taille,
            height: widget.taille,
            decoration: BoxDecoration(
              color: widget.couleur.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

/// Chargement skeleton pour simuler le contenu
class ChargementSkeleton extends StatefulWidget {
  final double taille;
  
  const ChargementSkeleton({
    super.key,
    required this.taille,
  });
  
  @override
  State<ChargementSkeleton> createState() => _ChargementSkeletonState();
}

class _ChargementSkeletonState extends State<ChargementSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    
    _controller.repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.taille,
          height: widget.taille * 0.6,
          decoration: BoxDecoration(
            color: CouleursApp.grisClair,
            borderRadius: BorderRadius.circular(TaillesApp.rayonPetit),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(TaillesApp.rayonPetit),
            child: CustomPaint(
              painter: ShimmerPainter(progression: _animation.value),
            ),
          ),
        );
      },
    );
  }
}

/// Painter pour l'effet shimmer du skeleton
class ShimmerPainter extends CustomPainter {
  final double progression;
  
  ShimmerPainter({required this.progression});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          CouleursApp.grisClair,
          CouleursApp.blanc,
          CouleursApp.grisClair,
        ],
        stops: const [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromLTWH(
          progression * size.width,
          0,
          size.width,
          size.height,
        ),
      );
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

/// Widget de chargement pour les listes
class ChargementListe extends StatelessWidget {
  final int nombreItems;
  final double hauteurItem;
  
  const ChargementListe({
    super.key,
    this.nombreItems = 5,
    this.hauteurItem = 80.0,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(nombreItems, (index) {
        return Container(
          height: hauteurItem,
          margin: const EdgeInsets.symmetric(
            horizontal: TaillesApp.espaceNormal,
            vertical: TaillesApp.espaceMin,
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(TaillesApp.espaceNormal),
              child: Row(
                children: [
                  ChargementSkeleton(taille: hauteurItem - 32),
                  const SizedBox(width: TaillesApp.espaceNormal),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: CouleursApp.grisClair,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: TaillesApp.espaceMin),
                        Container(
                          height: 14,
                          width: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            color: CouleursApp.grisClair,
                            borderRadius: BorderRadius.circular(4),
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
      }),
    );
  }
}

/// Widget d'overlay de chargement plein écran
class OverlayChargement extends StatelessWidget {
  final bool visible;
  final String? message;
  final Widget child;
  final TypeChargement typeChargement;
  
  const OverlayChargement({
    super.key,
    required this.visible,
    required this.child,
    this.message,
    this.typeChargement = TypeChargement.circulaire,
  });
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (visible)
          Container(
            color: CouleursApp.overlay,
            child: ChargementWidget(
              type: typeChargement,
              message: message ?? 'Chargement en cours...',
              afficherMessage: true,
              couleur: CouleursApp.blanc,
            ),
          ),
      ],
    );
  }
}
