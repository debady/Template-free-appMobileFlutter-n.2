// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../donnees/providers/authentification_provider.dart';
import '../../../donnees/providers/pays_provider.dart';
import '../../../donnees/modeles/utilisateur_modele.dart';
import '../../../config/couleurs_app.dart';
import '../../../config/tailles_app.dart';
import '../../../config/constantes_app.dart';
import '../../../utilitaires/navigation/routes_app.dart';
import '../../composants/navigation/header_app.dart';
import '../../composants/communs/bouton_personnalise.dart';
import '../../composants/communs/chargement_widget.dart';

/// Page d'inscription utilisateur
class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _controllerNom = TextEditingController();
  final _controllerPrenom = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerTelephone = TextEditingController();
  final _controllerMotDePasse = TextEditingController();
  final _controllerConfirmationMotDePasse = TextEditingController();
  
  bool _motDePasseVisible = false;
  bool _confirmationMotDePasseVisible = false;
  bool _accepterConditions = false;
  String _paysSelectionne = 'CI';
  bool _utiliserTelephone = false;
  
  @override
  void dispose() {
    _controllerNom.dispose();
    _controllerPrenom.dispose();
    _controllerEmail.dispose();
    _controllerTelephone.dispose();
    _controllerMotDePasse.dispose();
    _controllerConfirmationMotDePasse.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderSimple(titre: 'Inscription'),
      body: Consumer2<AuthentificationProvider, PaysProvider>(
        builder: (context, authProvider, paysProvider, child) {
          return OverlayChargement(
            visible: authProvider.chargementEnCours,
            message: 'Création du compte...',
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(TaillesApp.espaceGrand),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _construireHeader(context),
                    const SizedBox(height: TaillesApp.espaceGrand),
                    _construireFormulaireInscription(context, authProvider, paysProvider),
                    const SizedBox(height: TaillesApp.espaceGrand),
                    _construireConditionsUtilisation(context),
                    const SizedBox(height: TaillesApp.espaceGrand),
                    _construireActions(context, authProvider),
                    const SizedBox(height: TaillesApp.espaceGrand),
                    _construireLienConnexion(context),
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
            gradient: CouleursApp.gradientBleuCalme,
            borderRadius: BorderRadius.circular(TaillesApp.rayonTresGrand),
          ),
          child: const Icon(
            Icons.person_add,
            color: CouleursApp.blanc,
            size: 50,
          ),
        ),
        const SizedBox(height: TaillesApp.espaceGrand),
        Text(
          'Rejoignez MediPlus',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: CouleursApp.grisFonce,
          ),
        ),
        const SizedBox(height: TaillesApp.espaceMin),
        Text(
          'Créez votre compte pour accéder à tous nos contenus santé',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: CouleursApp.grisMoyen,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  Widget _construireFormulaireInscription(
    BuildContext context,
    AuthentificationProvider authProvider,
    PaysProvider paysProvider,
  ) {
    return Column(
      children: [
        // Nom et prénom
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controllerPrenom,
                decoration: const InputDecoration(
                  labelText: 'Prénom',
                  hintText: 'Votre prénom',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (valeur) {
                  if (valeur == null || valeur.trim().isEmpty) {
                    return 'Prénom requis';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: TaillesApp.espaceNormal),
            Expanded(
              child: TextFormField(
                controller: _controllerNom,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  hintText: 'Votre nom',
                ),
                validator: (valeur) {
                  if (valeur == null || valeur.trim().isEmpty) {
                    return 'Nom requis';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: TaillesApp.espaceGrand),
        
        // Choix du mode de contact
        Container(
          padding: const EdgeInsets.all(TaillesApp.espaceNormal),
          decoration: BoxDecoration(
            color: CouleursApp.grisClairFond,
            borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
            border: Border.all(color: CouleursApp.grisClair),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comment souhaitez-vous être contacté ?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: TaillesApp.espaceNormal),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Email'),
                      value: false,
                      groupValue: _utiliserTelephone,
                      onChanged: (valeur) {
                        setState(() {
                          _utiliserTelephone = valeur!;
                        });
                      },
                      dense: true,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Téléphone'),
                      value: true,
                      groupValue: _utiliserTelephone,
                      onChanged: (valeur) {
                        setState(() {
                          _utiliserTelephone = valeur!;
                        });
                      },
                      dense: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: TaillesApp.espaceGrand),
        
        // Email ou téléphone selon le choix
        if (!_utiliserTelephone)
          TextFormField(
            controller: _controllerEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'votre@email.com',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (valeur) {
              if (valeur == null || valeur.trim().isEmpty) {
                return 'Email requis';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(valeur)) {
                return 'Email invalide';
              }
              return null;
            },
          )
        else
          Row(
            children: [
              SizedBox(
                width: 100,
                child: DropdownButtonFormField<String>(
                  value: _paysSelectionne,
                  decoration: const InputDecoration(
                    labelText: 'Pays',
                    prefixIcon: Icon(Icons.flag),
                  ),
                  items: paysProvider.paysDisponibles.map((pays) {
                    return DropdownMenuItem(
                      value: pays.code,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(pays.emojeDrapeau),
                          const SizedBox(width: 4),
                          Text(pays.indicatifTelephonique),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (valeur) {
                    setState(() {
                      _paysSelectionne = valeur!;
                    });
                  },
                ),
              ),
              const SizedBox(width: TaillesApp.espaceNormal),
              Expanded(
                child: TextFormField(
                  controller: _controllerTelephone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Téléphone',
                    hintText: '07 00 00 00 00',
                  ),
                  validator: (valeur) {
                    if (valeur == null || valeur.trim().isEmpty) {
                      return 'Téléphone requis';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        
        const SizedBox(height: TaillesApp.espaceGrand),
        
        // Mot de passe
        TextFormField(
          controller: _controllerMotDePasse,
          obscureText: !_motDePasseVisible,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            hintText: 'Choisissez un mot de passe sécurisé',
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
              return 'Mot de passe requis';
            }
            if (valeur.length < 8) {
              return 'Au moins 8 caractères';
            }
            return null;
          },
        ),
        
        const SizedBox(height: TaillesApp.espaceGrand),
        
        // Confirmation mot de passe
        TextFormField(
          controller: _controllerConfirmationMotDePasse,
          obscureText: !_confirmationMotDePasseVisible,
          decoration: InputDecoration(
            labelText: 'Confirmer le mot de passe',
            hintText: 'Retapez votre mot de passe',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _confirmationMotDePasseVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _confirmationMotDePasseVisible = !_confirmationMotDePasseVisible;
                });
              },
            ),
          ),
          validator: (valeur) {
            if (valeur != _controllerMotDePasse.text) {
              return 'Les mots de passe ne correspondent pas';
            }
            return null;
          },
        ),
        
        if (authProvider.messageDErreur != null) ...[
          const SizedBox(height: TaillesApp.espaceNormal),
          Container(
            padding: const EdgeInsets.all(TaillesApp.espaceNormal),
            decoration: BoxDecoration(
              color: CouleursApp.erreurRouge.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TaillesApp.rayonPetit),
              border: Border.all(color: CouleursApp.erreurRouge.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: CouleursApp.erreurRouge,
                  size: 20,
                ),
                const SizedBox(width: TaillesApp.espaceMin),
                Expanded(
                  child: Text(
                    authProvider.messageDErreur!,
                    style: TextStyle(
                      color: CouleursApp.erreurRouge,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _construireConditionsUtilisation(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _accepterConditions,
          onChanged: (valeur) {
            setState(() {
              _accepterConditions = valeur!;
            });
          },
          activeColor: CouleursApp.vertSantePrimaire,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _accepterConditions = !_accepterConditions;
              });
            },
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  const TextSpan(text: 'J\'accepte les '),
                  TextSpan(
                    text: 'conditions d\'utilisation',
                    style: TextStyle(
                      color: CouleursApp.vertSantePrimaire,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' et la '),
                  TextSpan(
                    text: 'politique de confidentialité',
                    style: TextStyle(
                      color: CouleursApp.vertSantePrimaire,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _construireActions(BuildContext context, AuthentificationProvider authProvider) {
    return Column(
      children: [
        BoutonPersonnalise(
          texte: 'Créer mon compte',
          type: TypeBouton.primaire,
          pleineLargeur: true,
          hauteur: TaillesApp.hauteurBoutonGrand,
          chargementEnCours: authProvider.chargementEnCours,
          actif: _accepterConditions,
          onPressed: _accepterConditions ? () => _inscrire(authProvider) : null,
        ),
        
        const SizedBox(height: TaillesApp.espaceGrand),
        
        BoutonPersonnalise(
          texte: 'Inscription rapide (test)',
          type: TypeBouton.secondaire,
          pleineLargeur: true,
          hauteur: TaillesApp.hauteurBoutonGrand,
          onPressed: () => _inscriptionTest(authProvider),
        ),
      ],
    );
  }
  
  Widget _construireLienConnexion(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Déjà un compte ? ',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () => NavigationService.allerConnexion(),
          child: const Text(
            'Se connecter',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
  
  Future<void> _inscrire(AuthentificationProvider authProvider) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (!_accepterConditions) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez accepter les conditions d\'utilisation'),
          backgroundColor: CouleursApp.erreurRouge,
        ),
      );
      return;
    }
    
    final donnees = DonneesAuthentification(
      email: !_utiliserTelephone ? _controllerEmail.text.trim() : null,
      telephone: _utiliserTelephone ? _controllerTelephone.text.trim() : null,
      motDePasse: _controllerMotDePasse.text,
      nom: _controllerNom.text.trim(),
      prenom: _controllerPrenom.text.trim(),
      pays: _paysSelectionne,
    );
    
    final success = await authProvider.inscrire(donnees);
    
    if (success && mounted) {
      // Inscription réussie - aller à la vérification OTP
      NavigationService.allerVerificationOtp(
        email: donnees.email,
        telephone: donnees.telephone,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(ConstantesApp.successInscription),
          backgroundColor: CouleursApp.successVert,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  
  void _inscriptionTest(AuthentificationProvider authProvider) {
    // Remplir automatiquement avec les données test
    _controllerPrenom.text = 'Konan Alla';
    _controllerNom.text = 'Aime';
    _controllerEmail.text = UtilisateurTest.email;
    _controllerTelephone.text = '07 00 31 17 77';
    _controllerMotDePasse.text = UtilisateurTest.motDePasse;
    _controllerConfirmationMotDePasse.text = UtilisateurTest.motDePasse;
    
    setState(() {
      _accepterConditions = true;
      _paysSelectionne = 'CI';
    });
    
    // Inscrire
    _inscrire(authProvider);
  }
}