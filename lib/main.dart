import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hostonewstv/interface/splash_page.dart';
import 'package:provider/provider.dart';
import 'donnees/providers/authentification_provider.dart';
import 'donnees/providers/contenu_provider.dart';
import 'donnees/providers/pays_provider.dart';
import 'config/theme_app.dart';
import 'config/constantes_app.dart';
import 'utilitaires/navigation/routes_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    ),
  );

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthentificationProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ContenuProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => PaysProvider(),
          lazy: false,
        ),
      ],
      // ✅ builder crée un BuildContext enfant du MultiProvider
   
      builder: (context, _) {
        return MaterialApp(
          title: ConstantesApp.nomApp,
          debugShowCheckedModeBanner: false,
          navigatorKey: NavigationService.navigatorKey,
          onGenerateRoute: RoutesApp.genererRoute,
          theme: ThemeApp.themeClair,

          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale('fr'),
          supportedLocales: const [
            Locale('fr'),
            Locale('en'),
          ],

          home: const SplashPage(),
        );
      },
    ),
  );
}