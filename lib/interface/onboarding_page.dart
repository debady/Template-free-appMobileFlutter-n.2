// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hostonewstv/interface/pages/accueil/accueil_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Modèle d'une page d'onboarding
class _DonneeOnboarding {
  final IconData icone;
  final String titre;
  final String description;
  final Color couleurPrimaire;
  final Color couleurSecondaire;

  const _DonneeOnboarding({
    required this.icone,
    required this.titre,
    required this.description,
    required this.couleurPrimaire,
    required this.couleurSecondaire,
  });
}

/// 4 écrans d'onboarding → AccueilPage
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  int _pageCourante = 0;

  static const List<_DonneeOnboarding> _pages = [
    _DonneeOnboarding(
      icone: Icons.health_and_safety_rounded,
      titre: 'Santé & Information',
      description:
          'Accédez à des contenus fiables sur la santé, rédigés par des professionnels médicaux africains.',
      couleurPrimaire: Color(0xFF0A5C3E),
      couleurSecondaire: Color(0xFF1DB87F),
    ),
    _DonneeOnboarding(
      icone: Icons.live_tv_rounded,
      titre: 'Lives & Émissions',
      description:
          'Suivez des émissions santé en direct. Posez vos questions à des médecins en temps réel.',
      couleurPrimaire: Color(0xFF1A237E),
      couleurSecondaire: Color(0xFF3949AB),
    ),
    _DonneeOnboarding(
      icone: Icons.public_rounded,
      titre: 'Toute l\'Afrique',
      description:
          'Un contenu adapté à chaque pays. Sélectionnez votre pays pour des informations locales et pertinentes.',
      couleurPrimaire: Color(0xFF7B3200),
      couleurSecondaire: Color(0xFFE65100),
    ),
    _DonneeOnboarding(
      icone: Icons.notifications_active_rounded,
      titre: 'Restez Informé',
      description:
          'Recevez des alertes santé importantes. Ne manquez plus jamais une émission ou une alerte médicale.',
      couleurPrimaire: Color(0xFF4A0072),
      couleurSecondaire: Color(0xFF7B1FA2),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _animController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _animController.forward();
  }

  void _allerPage(int index) {
    _animController.reset();
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() => _pageCourante = index);
    _animController.forward();
  }

  void _pageSuivante() {
    if (_pageCourante < _pages.length - 1) {
      _allerPage(_pageCourante + 1);
    } else {
      _terminerOnboarding();
    }
  }

  Future<void> _terminerOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_vu', true);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AccueilPage(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_pageCourante];
    final estDernierePage = _pageCourante == _pages.length - 1;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              page.couleurPrimaire,
              page.couleurSecondaire,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Décoration arrière-plan
            _construireFond(page),

            // Contenu principal
            SafeArea(
              child: Column(
                children: [
                  // Bouton "Passer" en haut à droite
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextButton(
                        onPressed: _terminerOnboarding,
                        child: Text(
                          'Passer',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // PageView (illusion de swipe, navigation par boutons)
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _pages.length,
                      onPageChanged: (i) {
                        setState(() => _pageCourante = i);
                      },
                      itemBuilder: (context, index) {
                        return _construireContenuPage(_pages[index]);
                      },
                    ),
                  ),

                  // Indicateurs + bouton
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                    child: Column(
                      children: [
                        // Points indicateurs
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                            (i) => _construireIndicateur(i),
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Bouton Suivant / Commencer
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _pageSuivante,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: page.couleurPrimaire,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Row(
                                key: ValueKey(estDernierePage),
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    estDernierePage
                                        ? 'Commencer'
                                        : 'Suivant',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: page.couleurPrimaire,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    estDernierePage
                                        ? Icons.check_rounded
                                        : Icons.arrow_forward_rounded,
                                    size: 20,
                                    color: page.couleurPrimaire,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Contenu d'une page
  // ---------------------------------------------------------------------------

  Widget _construireContenuPage(_DonneeOnboarding page) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cercle avec icône
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      page.icone,
                      size: 50,
                      color: page.couleurPrimaire,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Titre
              Text(
                page.titre,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Description
              Text(
                page.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.82),
                  fontSize: 16,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Indicateur de page (points)
  // ---------------------------------------------------------------------------

  Widget _construireIndicateur(int index) {
    final estActif = index == _pageCourante;

    return GestureDetector(
      onTap: () => _allerPage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: estActif ? 28 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: estActif
              ? Colors.white
              : Colors.white.withOpacity(0.35),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Fond décoratif
  // ---------------------------------------------------------------------------

  Widget _construireFond(_DonneeOnboarding page) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -80,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.06),
            ),
          ),
        ),
      ],
    );
  }
}
