// import 'package:flutter/material.dart';
// import '../config/couleurs_app.dart';
// import '../config/tailles_app.dart';
// import '../utilitaires/navigation_simple.dart';

// /// Header principal de l'application avec sélecteur pays et recherche
// class HeaderApp extends StatelessWidget {
//   const HeaderApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(TaillesApp.espaceMedium),
//       decoration: const BoxDecoration(
//         color: CouleursApp.blanc,
//         boxShadow: [
//           BoxShadow(
//             color: CouleursApp.ombreClaire,
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             // Logo MediPlus
//             Image.asset(
//               'assets/logos/logo_hostonew.png',
//               height: 40,
//             ),
//             const Spacer(),
            
//             // Sélecteur pays
//             _construireSelecteurPays(context),
            
//             const SizedBox(width: TaillesApp.espaceMedium),
            
//             // Bouton recherche
//             _construireBoutonRecherche(context),
            
//             const SizedBox(width: TaillesApp.espaceMedium),
            
//             // Bouton profil
//             _construireBoutonProfil(context),
//           ],
//         ),
//       ),
//     );
//   }
  
//   Widget _construireSelecteurPays(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: TaillesApp.espaceMedium,
//         vertical: TaillesApp.espaceSmall,
//       ),
//       decoration: BoxDecoration(
//         color: CouleursApp.fondGris,
//         borderRadius: BorderRadius.circular(TaillesApp.rayonLarge),
//         border: Border.all(color: CouleursApp.bordureDouce),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Drapeau pays (ici Côte d'Ivoire par défaut)
//           Container(
//             width: 24,
//             height: 16,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(2),
//               color: CouleursApp.orangeAttention, // Simuler drapeau CI
//             ),
//           ),
//           const SizedBox(width: TaillesApp.espaceSmall),
//           Text(
//             'CI',
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               fontWeight: FontWeight.w500,
//               color: CouleursApp.textePrincipal,
//             ),
//           ),
//           const SizedBox(width: TaillesApp.espaceSmall),
//           const Icon(
//             Icons.keyboard_arrow_down,
//             size: 16,
//             color: CouleursApp.texteSecondaire,
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _construireBoutonRecherche(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         NavigationSimple.versPage(RoutesApp.recherche);
//       },
//       icon: const Icon(
//         Icons.search,
//         color: CouleursApp.texteSecondaire,
//         size: 24,
//       ),
//     );
//   }
  
//   Widget _construireBoutonProfil(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         // Vérifier si utilisateur connecté
//         NavigationSimple.versPage(RoutesApp.connexion);
//       },
//       icon: const Icon(
//         Icons.person_outline,
//         color: CouleursApp.texteSecondaire,
//         size: 24,
//       ),
//     );
//   }
// }