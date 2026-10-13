# MediPlus

**Santé pour l'Afrique** — application Flutter (mobile et web) d'information santé : articles, vidéos, émissions, podcasts et lives, pour un public francophone.

Un seul code source pour Android, iOS, Web, Windows, macOS et Linux.

---

## Fonctionnalités

- **Accès libre** : consultation des contenus sans compte obligatoire
- **Sélection du pays** : 13 pays couverts (Côte d'Ivoire, Burkina Faso, Mali, Bénin, Togo, Gabon, France, Sénégal, Ghana, Tchad, Guinée, Libéria, Nigeria)
- **Accueil** : carrousel « À la une », catégories santé, contenus populaires, derniers ajouts, lives
- **Liste des contenus** : filtres par type (article, vidéo, live, podcast…) et tri (récents, populaires, anciens)
- **Détail d'un contenu** : lecture, métadonnées, auteur, contenus similaires
- **Compte utilisateur** : inscription / connexion (email ou téléphone + OTP), profil, favoris, historique
- **Interactions** : j'aime, favoris, commentaires, partage
- **Live** : programme TV, replays, chat en direct

## Prérequis

- [Flutter](https://docs.flutter.dev/get-started/install) avec Dart SDK `^3.8.1`
- Android Studio / Xcode selon la plateforme cible

## Installation

```bash
git clone https://github.com/debady/<nom-du-depot>.git
cd hostonewstv-apk
flutter pub get
```

## Lancer l'application

```bash
# Lister les appareils disponibles
flutter devices

# Lancer sur un appareil Android / iOS
flutter run -d <device-id>

# Lancer sur le web
flutter run -d chrome
```

Pendant l'exécution : `r` pour le hot reload, `R` pour le hot restart.

## Tests et qualité

```bash
flutter analyze
flutter test
```

## Générer un APK

```bash
flutter build apk --release
```

L'APK est généré dans `build/app/outputs/flutter-apk/app-release.apk`.

## Structure du projet

```
lib/
├── main.dart              # Point d'entrée
├── config/                # Couleurs, tailles, thème, constantes (nom de l'app, URLs)
├── donnees/               # Modèles, services API, repositories, providers, stockage
├── interface/             # Pages, composants réutilisables, animations
└── utilitaires/           # Navigation, permissions, validateurs, helpers, extensions
```

Le nom affiché de l'application est défini dans `lib/config/constantes_app.dart` (`ConstantesApp.nomApp`).

## Technologies

- **Flutter** / Dart
- **Provider** pour la gestion d'état
- **Dio** / **http** pour les appels API
- **shared_preferences** et **flutter_secure_storage** pour le stockage local
- **video_player** / **chewie** pour la lecture vidéo

## Documentation

Le cahier des charges complet (vision, workflows utilisateur, correspondants, modération, live, notifications, sécurité, plan de développement) se trouve dans [docs/CAHIER_DES_CHARGES.md](docs/CAHIER_DES_CHARGES.md).

---

## Licence

Libre et gratuit : utilisez-le, modifiez-le et partagez-le comme vous le souhaitez.

## Auteur

**N'Guessan** — Développeur

- Site : [losgeek.com](https://losgeek.com)
- GitHub : [@debady](https://github.com/debady)

## Soutenir le projet

Ce template vous a été utile ? Vous pouvez laisser un pourboire :

**Faire un don via Wave**

Merci !
