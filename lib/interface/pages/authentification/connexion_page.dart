// ignore_for_file: unused_field, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../donnees/providers/authentification_provider.dart';
import '../../../config/couleurs_app.dart';
import '../../../config/tailles_app.dart';
import '../../../config/constantes_app.dart';
import '../../../utilitaires/navigation/routes_app.dart';
import '../../composants/navigation/header_app.dart';
import '../../composants/communs/bouton_personnalise.dart';
import '../../composants/communs/chargement_widget.dart';

/// Page de connexion utilisateur
class ConnexionPage extends StatefulWidget {
  const ConnexionPage({super.key});

  @override
  State<ConnexionPage> createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final _formKey = GlobalKey<FormState>();
  final _controllerIdentifiant = TextEditingController();
  final _controllerMotDePasse = TextEditingController();
  
  bool _motDePasseVisible = false;
  bool _seConnecter = false;
  
  @override
  void dispose() {
    _controllerIdentifiant.dispose();
    _controllerMotDePasse.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderSimple(titre: 'Connexion'),
      body: Consumer<AuthentificationProvider>(
        builder: (context, authProvider, child) {
          return OverlayChargement(
            visible: authProvider.chargementEnCours,
            message: 'Connexion en cours...',
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(TaillesApp.espaceGrand),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _construireHeader(context),
                    const SizedBox(height: TaillesApp.espaceEnorme),
                    _construireFormulaireConnexion(context, authProvider),
                    const SizedBox(height: TaillesApp.espaceGrand),
                    _construireActions(context, authProvider),
                    const SizedBox(height: TaillesApp.espaceGrand),
                    _construireLienInscription(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _construireHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: CouleursApp.gradientVertSante,
            borderRadius: BorderRadius.circular(TaillesApp.rayonTresGrand),
          ),
          child: const Icon(
            Icons.health_and_safety,
            color: CouleursApp.blanc,
            size: 50,
          ),
        ),
        const SizedBox(height: TaillesApp.espaceGrand),
        Text(
          'Bon retour !',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: CouleursApp.grisFonce,
          ),
        ),
        const SizedBox(height: TaillesApp.espaceMin),
        Text(
          'Connectez-vous pour accéder à votre contenu personnalisé',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: CouleursApp.grisMoyen,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  Widget _construireFormulaireConnexion(BuildContext context, AuthentificationProvider authProvider) {
    return Column(
      children: [
        // Champ identifiant (email ou téléphone)
        TextFormField(
          controller: _controllerIdentifiant,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email ou téléphone',
            hintText: 'Entrez votre email ou numéro de téléphone',
            prefixIcon: const Icon(Icons.person_outline),
            errorText: authProvider.messageDErreur,
          ),
          validator: (valeur) {
            if (valeur == null || valeur.trim().isEmpty) {
              return 'Veuillez saisir votre email ou téléphone';
            }
            return null;
          },
          onChanged: (_) {
            if (authProvider.messageDErreur != null) {
              // Effacer l'erreur quand l'utilisateur tape
              setState(() {});
            }
          },
        ),
        
        const SizedBox(height: TaillesApp.espaceGrand),
        
        // Champ mot de passe
        TextFormField(
          controller: _controllerMotDePasse,
          obscureText: !_motDePasseVisible,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            hintText: 'Entrez votre mot de passe',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _motDePasseVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _motDePasseVisible = !_motDePasseVisible;
                });
              },
            ),
          ),
          validator: (valeur) {
            if (valeur == null || valeur.isEmpty) {
              return 'Veuillez saisir votre mot de passe';
            }
            return null;
          },
          onFieldSubmitted: (_) => _connecter(authProvider),
        ),
        
        const SizedBox(height: TaillesApp.espaceNormal),
        
        // Lien mot de passe oublié
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fonction à venir'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Mot de passe oublié ?'),
          ),
        ),
      ],
    );
  }
  
  Widget _construireActions(BuildContext context, AuthentificationProvider authProvider) {
    return Column(
      children: [
        // Bouton connexion
        BoutonPersonnalise(
          texte: 'Se connecter',
          type: TypeBouton.primaire,
          pleineLargeur: true,
          hauteur: TaillesApp.hauteurBoutonGrand,
          chargementEnCours: authProvider.chargementEnCours,
          onPressed: () => _connecter(authProvider),
        ),
        
        const SizedBox(height: TaillesApp.espaceGrand),
        
        // Divider avec "ou"
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TaillesApp.espaceNormal),
              child: Text(
                'ou',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: CouleursApp.grisMoyen,
                ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        
        const SizedBox(height: TaillesApp.espaceGrand),
        
        // Connexion rapide avec données test
        BoutonPersonnalise(
          texte: 'Connexion rapide (test)',
          type: TypeBouton.secondaire,
          pleineLargeur: true,
          hauteur: TaillesApp.hauteurBoutonGrand,
          onPressed: () => _connexionTest(authProvider),
        ),
      ],
    );
  }
  
  Widget _construireLienInscription(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Pas encore de compte ? ',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () => NavigationService.allerInscription(),
          child: const Text(
            'S\'inscrire',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
  
  Future<void> _connecter(AuthentificationProvider authProvider) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final identifiant = _controllerIdentifiant.text.trim();
    final motDePasse = _controllerMotDePasse.text;
    
    // Déterminer si c'est un email ou téléphone
    final bool estEmail = identifiant.contains('@');
    
    final success = await authProvider.connecter(
      email: estEmail ? identifiant : null,
      telephone: !estEmail ? identifiant : null,
      motDePasse: motDePasse,
    );
    
    if (success && mounted) {
      // Connexion réussie - retourner à l'accueil
      NavigationService.retourAccueil();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(ConstantesApp.successConnexion),
          backgroundColor: CouleursApp.successVert,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  
  Future<void> _connexionTest(AuthentificationProvider authProvider) async {
    // Remplir automatiquement les champs avec les données test
    _controllerIdentifiant.text = UtilisateurTest.email;
    _controllerMotDePasse.text = UtilisateurTest.motDePasse;
    
    // Se connecter
    await _connecter(authProvider);
  }
}