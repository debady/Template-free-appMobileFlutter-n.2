// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'donnees/providers/authentification_provider.dart';
import 'donnees/providers/contenu_provider.dart';
import 'donnees/providers/pays_provider.dart';
import 'config/theme_app.dart';
import 'config/constantes_app.dart';
import 'utilitaires/navigation/routes_app.dart';
import 'interface/pages/accueil/accueil_page.dart';

/// Point d'entrée principal — appelé depuis main.dart
Future<void> configurerEtLancer() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configurerApplication();
  runApp(const ApplicationHostoNew());
}

Future<void> _configurerApplication() async {
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    debugPrint('Configuration de l\'application terminée');
  } catch (e) {
    debugPrint('Erreur lors de la configuration: $e');
  }
}

// ---------------------------------------------------------------------------
// Application racine
// ---------------------------------------------------------------------------

class ApplicationHostoNew extends StatelessWidget {
  const ApplicationHostoNew({super.key});

  List<ChangeNotifierProvider> _creerProviders() {
    return [
      ChangeNotifierProvider(
        create: (_) => AuthentificationProvider(),
        lazy: false,
      ),
      ChangeNotifierProvider(create: (_) => ContenuProvider(), lazy: false),
      ChangeNotifierProvider(create: (_) => PaysProvider(), lazy: false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    // ✅ FIX PROVIDER : on utilise `builder` sur MultiProvider (pas `child`)
    // Cela crée un nouveau BuildContext enfant qui "voit" bien les providers.
    return MultiProvider(
      providers: _creerProviders(),
      builder: (context, _) {
        return MaterialApp(
          title: ConstantesApp.nomApp,
          debugShowCheckedModeBanner: false,
          navigatorKey: NavigationService.navigatorKey,
          onGenerateRoute: RoutesApp.genererRoute,
          home: const _PageInitialisation(),
          theme: ThemeApp.themeClair,

          // ✅ FIX LOCALISATION : delegates obligatoires pour fr + en
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // ✅ FIX LOCALISATION : sans sous-tag _FR pour éviter le warning
          locale: const Locale('fr'),
          supportedLocales: const [
            Locale('fr'),
            Locale('en'),
          ],

          builder: (context, child) {
            return _ConstructeurGlobal(child: child);
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Constructeur global : échelle de texte + fermeture clavier au tap
// ---------------------------------------------------------------------------

class _ConstructeurGlobal extends StatelessWidget {
  final Widget? child;

  const _ConstructeurGlobal({this.child});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return MediaQuery(
      data: mediaQuery.copyWith(
        // ✅ textScaler remplace textScaleFactor (déprécié depuis Flutter 3.12)
        textScaler: TextScaler.linear(
          mediaQuery.textScaler.scale(1.0).clamp(0.8, 1.3),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          final focus = FocusScope.of(context);
          if (!focus.hasPrimaryFocus && focus.focusedChild != null) {
            focus.unfocus();
          }
        },
        child: child ?? const SizedBox(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page d'initialisation / splash
// ---------------------------------------------------------------------------

class _PageInitialisation extends StatefulWidget {
  const _PageInitialisation();

  @override
  State<_PageInitialisation> createState() => _PageInitialisationState();
}

class _PageInitialisationState extends State<_PageInitialisation>
    with TickerProviderStateMixin {
  late AnimationController _controllerChargement;
  late Animation<double> _animationRotation;

  bool _initialisationTerminee = false;
  String _messageChargement = 'Initialisation...';

  @override
  void initState() {
    super.initState();
    _initializerAnimations();
    // ✅ addPostFrameCallback : widget monté → context valide → providers accessibles
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialiserApplication();
    });
  }

  void _initializerAnimations() {
    _controllerChargement = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animationRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controllerChargement,
        curve: Curves.easeInOut,
      ),
    );

    _controllerChargement.repeat();
  }

  Future<void> _initialiserApplication() async {
    try {
      final authProvider =
          Provider.of<AuthentificationProvider>(context, listen: false);
      final contenuProvider =
          Provider.of<ContenuProvider>(context, listen: false);
      final paysProvider = Provider.of<PaysProvider>(context, listen: false);

      _setMessage('Vérification de la session...');
      await authProvider.initialiser();
      await Future.delayed(const Duration(milliseconds: 500));

      _setMessage('Chargement des pays...');
      await paysProvider.initialiser();
      await Future.delayed(const Duration(milliseconds: 500));

      _setMessage('Chargement des contenus...');
      await contenuProvider.initialiser();
      await Future.delayed(const Duration(milliseconds: 500));

      _setMessage('Finalisation...');
      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) setState(() => _initialisationTerminee = true);
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation: $e');
      if (mounted) {
        setState(() {
          _messageChargement = 'Erreur d\'initialisation, continuons...';
          _initialisationTerminee = true;
        });
      }
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  void _setMessage(String msg) {
    if (mounted) setState(() => _messageChargement = msg);
  }

  @override
  void dispose() {
    _controllerChargement.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initialisationTerminee) {
      return const AccueilPage();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône tournante
            AnimatedBuilder(
              animation: _animationRotation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animationRotation.value * 2 * 3.14159,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.health_and_safety,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            Text(
              ConstantesApp.nomApp,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 8),

            Text(
              ConstantesApp.descriptionApp,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 48),

            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 16),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _messageChargement,
                key: ValueKey(_messageChargement),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ),

            const SizedBox(height: 32),

            Text(
              'Version ${ConstantesApp.versionApp}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[400],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Extensions pratiques sur BuildContext
// ---------------------------------------------------------------------------

extension ProvidersExtension on BuildContext {
  AuthentificationProvider get auth =>
      Provider.of<AuthentificationProvider>(this, listen: false);

  ContenuProvider get contenu =>
      Provider.of<ContenuProvider>(this, listen: false);

  PaysProvider get pays => Provider.of<PaysProvider>(this, listen: false);

  bool get estConnecte =>
      Provider.of<AuthentificationProvider>(this).estConnecte;
}