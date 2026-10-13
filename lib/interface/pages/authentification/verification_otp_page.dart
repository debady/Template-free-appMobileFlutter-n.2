// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../donnees/providers/authentification_provider.dart';
import '../../../config/couleurs_app.dart';
import '../../../config/tailles_app.dart';
import '../../../utilitaires/navigation/routes_app.dart';
import '../../composants/navigation/header_app.dart';
import '../../composants/communs/bouton_personnalise.dart';
import '../../composants/communs/chargement_widget.dart';

/// Page de vérification du code OTP
class VerificationOtpPage extends StatefulWidget {
  final String? email;
  final String? telephone;
  
  const VerificationOtpPage({
    super.key,
    this.email,
    this.telephone,
  });

  @override
  State<VerificationOtpPage> createState() => _VerificationOtpPageState();
}

class _VerificationOtpPageState extends State<VerificationOtpPage> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  Timer? _timerExpiration;
  int _secondesRestantes = 300; // 5 minutes
  bool _peutRenvoyer = false;
  String _codeOtp = '';
  
  @override
  void initState() {
    super.initState();
    _demarrerTimerExpiration();
  }
  
  @override
  void dispose() {
    _timerExpiration?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
  
  void _demarrerTimerExpiration() {
    _timerExpiration?.cancel();
    _secondesRestantes = 300; // 5 minutes
    _peutRenvoyer = false;
    
    _timerExpiration = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondesRestantes > 0) {
            _secondesRestantes--;
          } else {
            _peutRenvoyer = true;
            timer.cancel();
          }
        });
      }
    });
  }
  
  String get _tempsRestantFormate {
    final minutes = _secondesRestantes ~/ 60;
    final secondes = _secondesRestantes % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secondes.toString().padLeft(2, '0')}';
  }
  
  String get _destinataireFormate {
    if (widget.email != null) {
      final email = widget.email!;
      final atIndex = email.indexOf('@');
      if (atIndex > 2) {
        return '${email.substring(0, 2)}***${email.substring(atIndex)}';
      }
      return email;
    } else if (widget.telephone != null) {
      final tel = widget.telephone!;
      if (tel.length > 4) {
        return '${tel.substring(0, tel.length - 4).replaceAll(RegExp(r'\d'), '*')}${tel.substring(tel.length - 4)}';
      }
      return tel;
    }
    return 'votre appareil';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderSimple(titre: 'Vérification'),
      body: Consumer<AuthentificationProvider>(
        builder: (context, authProvider, child) {
          return OverlayChargement(
            visible: authProvider.chargementEnCours,
            message: 'Vérification en cours...',
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(TaillesApp.espaceGrand),
              child: Column(
                children: [
                  _construireHeader(context),
                  const SizedBox(height: TaillesApp.espaceEnorme),
                  _construireChampsSaisieOtp(context),
                  const SizedBox(height: TaillesApp.espaceGrand),
                  _construireTimerEtRenvoi(context, authProvider),
                  const SizedBox(height: TaillesApp.espaceGrand),
                  _construireBoutonVerifier(context, authProvider),
                  const SizedBox(height: TaillesApp.espaceGrand),
                  _construireAide(context),
                ],
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
            color: CouleursApp.orangeVitalite.withOpacity(0.1),
            borderRadius: BorderRadius.circular(TaillesApp.rayonTresGrand),
            border: Border.all(
              color: CouleursApp.orangeVitalite.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Icon(
            Icons.mark_email_read_outlined,
            color: CouleursApp.orangeVitalite,
            size: 50,
          ),
        ),
        const SizedBox(height: TaillesApp.espaceGrand),
        Text(
          'Vérifiez votre code',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: CouleursApp.grisFonce,
          ),
        ),
        const SizedBox(height: TaillesApp.espaceNormal),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: CouleursApp.grisMoyen,
            ),
            children: [
              const TextSpan(text: 'Nous avons envoyé un code de vérification à\n'),
              TextSpan(
                text: _destinataireFormate,
                style: const TextStyle(
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
  
  Widget _construireChampsSaisieOtp(BuildContext context) {
    return Column(
      children: [
        Text(
          'Saisissez le code à 6 chiffres',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: CouleursApp.grisFonce,
          ),
        ),
        const SizedBox(height: TaillesApp.espaceGrand),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) => _construireChampOtp(context, index)),
        ),
        if (_codeOtp.length == 6 && _codeOtp != '123456') ...[
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
                const Expanded(
                  child: Text(
                    'Code incorrect. Vérifiez votre saisie.',
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
  
  Widget _construireChampOtp(BuildContext context, int index) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
        border: Border.all(
          color: _controllers[index].text.isNotEmpty 
              ? CouleursApp.vertSantePrimaire 
              : CouleursApp.grisClair,
          width: 2,
        ),
        color: _controllers[index].text.isNotEmpty 
            ? CouleursApp.vertSantePrimaire.withOpacity(0.1)
            : CouleursApp.blanc,
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: CouleursApp.grisFonce,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (valeur) => _gererSaisieOtp(valeur, index),
      ),
    );
  }
  
  Widget _construireTimerEtRenvoi(BuildContext context, AuthentificationProvider authProvider) {
    return Container(
      padding: const EdgeInsets.all(TaillesApp.espaceGrand),
      decoration: BoxDecoration(
        color: CouleursApp.grisClairFond,
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
      ),
      child: Column(
        children: [
          if (!_peutRenvoyer) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  color: CouleursApp.grisMoyen,
                  size: 20,
                ),
                const SizedBox(width: TaillesApp.espaceMin),
                Text(
                  'Code expire dans $_tempsRestantFormate',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CouleursApp.grisMoyen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              'Le code a expiré',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: CouleursApp.erreurRouge,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: TaillesApp.espaceNormal),
            BoutonPersonnalise(
              texte: 'Renvoyer le code',
              type: TypeBouton.primaire,
              icone: Icons.refresh,
              onPressed: () => _renvoyerCode(authProvider),
              chargementEnCours: authProvider.chargementEnCours,
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _construireBoutonVerifier(BuildContext context, AuthentificationProvider authProvider) {
    final codeComplet = _codeOtp.length == 6;
    
    return Column(
      children: [
        BoutonPersonnalise(
          texte: 'Vérifier le code',
          type: TypeBouton.primaire,
          pleineLargeur: true,
          hauteur: TaillesApp.hauteurBoutonGrand,
          chargementEnCours: authProvider.chargementEnCours,
          actif: codeComplet && !_peutRenvoyer,
          onPressed: codeComplet && !_peutRenvoyer ? () => _verifierCode(authProvider) : null,
        ),
        const SizedBox(height: TaillesApp.espaceNormal),
        BoutonPersonnalise(
          texte: 'Code test : 123456',
          type: TypeBouton.secondaire,
          pleineLargeur: true,
          hauteur: TaillesApp.hauteurBoutonNormal,
          onPressed: () => _utiliserCodeTest(),
        ),
      ],
    );
  }
  
  Widget _construireAide(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TaillesApp.espaceGrand),
      decoration: BoxDecoration(
        color: CouleursApp.bleuClair,
        borderRadius: BorderRadius.circular(TaillesApp.rayonNormal),
      ),
      child: Column(
        children: [
          Icon(
            Icons.help_outline,
            color: CouleursApp.bleuCalme,
            size: 32,
          ),
          const SizedBox(height: TaillesApp.espaceNormal),
          Text(
            'Vous ne recevez pas le code ?',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: CouleursApp.grisFonce,
            ),
          ),
          const SizedBox(height: TaillesApp.espaceMin),
          Text(
            'Vérifiez votre dossier spam ou attendez quelques minutes. Le code peut prendre jusqu\'à 5 minutes pour arriver.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CouleursApp.grisMoyen,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TaillesApp.espaceNormal),
          TextButton(
            onPressed: () => NavigationService.allerInscription(),
            child: const Text('Modifier mes informations'),
          ),
        ],
      ),
    );
  }
  
  void _gererSaisieOtp(String valeur, int index) {
    if (valeur.isNotEmpty) {
      // Passer au champ suivant
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      // Revenir au champ précédent si on efface
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
    
    // Construire le code complet
    _codeOtp = _controllers.map((c) => c.text).join();
    setState(() {});
  }
  
  void _utiliserCodeTest() {
    for (int i = 0; i < 6; i++) {
      _controllers[i].text = '123456'[i];
    }
    _codeOtp = '123456';
    setState(() {});
    
    // Vérifier automatiquement
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final authProvider = Provider.of<AuthentificationProvider>(context, listen: false);
        _verifierCode(authProvider);
      }
    });
  }
  
  Future<void> _verifierCode(AuthentificationProvider authProvider) async {
    if (_codeOtp.length != 6) return;
    
    final success = await authProvider.verifierOtp(
      _codeOtp,
      email: widget.email,
      telephone: widget.telephone,
    );
    
    if (success && mounted) {
      // Vérification réussie - retourner à l'accueil
      NavigationService.retourAccueil();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compte vérifié avec succès !'),
          backgroundColor: CouleursApp.successVert,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      // Effacer le code en cas d'erreur
      for (var controller in _controllers) {
        controller.clear();
      }
      _codeOtp = '';
      _focusNodes[0].requestFocus();
      setState(() {});
    }
  }
  
  Future<void> _renvoyerCode(AuthentificationProvider authProvider) async {
    // Simulation d'envoi de code
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      _demarrerTimerExpiration();
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nouveau code envoyé !'),
          backgroundColor: CouleursApp.successVert,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}