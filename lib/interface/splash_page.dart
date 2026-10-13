// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hostonewstv/interface/onboarding_page.dart';
import 'package:hostonewstv/interface/pages/accueil/accueil_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );

    // Logo : fade + scale
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    // Barre de progression : démarre à 0.3 pour paraître vivant
    _progressAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    // Attendre la fin de l'animation puis naviguer
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _naviguerSuivant();
      }
    });
  }

  Future<void> _naviguerSuivant() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingVu = prefs.getBool('onboarding_vu') ?? false;

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            onboardingVu ? const AccueilPage() : const OnboardingPage(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A5C3E), // vert foncé
              Color(0xFF128A5F), // vert santé
              Color(0xFF1DB87F), // vert vif
            ],
          ),
        ),
        child: Stack(
          children: [
            // Cercles décoratifs en arrière-plan
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: 200,
              right: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),

            // Contenu centré
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Logo + Nom
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return FadeTransition(
                        opacity: _fadeAnim,
                        child: ScaleTransition(
                          scale: _scaleAnim,
                          child: Column(
                            children: [
                              // Icône dans un cercle blanc
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 30,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.health_and_safety_rounded,
                                  size: 56,
                                  color: Color(0xFF128A5F),
                                ),
                              ),

                              const SizedBox(height: 28),

                              // Nom de l'app
                              const Text(
                                'MediPlus',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // Slogan
                              Text(
                                'L\'information santé de l\'Afrique',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.80),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 2),

                  // Barre de progression en bas
                  AnimatedBuilder(
                    animation: _progressAnim,
                    builder: (context, _) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                        child: Column(
                          children: [
                            // Track de la barre
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: LinearProgressIndicator(
                                value: _progressAnim.value,
                                minHeight: 3,
                                backgroundColor:
                                    Colors.white.withOpacity(0.20),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
