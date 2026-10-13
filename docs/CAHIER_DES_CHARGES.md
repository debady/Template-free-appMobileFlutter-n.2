## REFORMULATION DU BESOIN - PROJET HOSTONEW TV

### **Vision Globale**
HostoNew TV est une plateforme web TV multimédia dédiée à l'information sanitaire, conçue comme un écosystème complet d'information santé accessible via web et applications mobiles. Le projet vise à créer un canal de communication moderne et interactif pour diffuser des contenus de santé de qualité à un public francophone international.

### **Architecture du Système**

**1. Plateforme Multi-supports**
- Interface web responsive
- Applications mobiles natives (iOS/Android)
- Synchronisation des contenus entre plateformes

**2. Réseau International de Correspondants**
- Correspondants dans 13 pays (Côte d'Ivoire, Burkina Faso, Mali, Bénin, Togo, Gabon, France, Sénégal, Ghana, Tchad, Guinée, Libéria, Nigeria)
- Interface dédiée pour la publication de contenus
- Système de géolocalisation des contenus par pays

**3. Types de Contenus Multimédias**
- Articles textuels purs
- Articles enrichis (texte + images)
- Contenus vidéo (émissions, reportages, interviews)
- Contenus audiovisuels mixtes
- Journaux télévisés
- Émissions thématiques
- Podcasts santé
- Lives interactifs

### **Fonctionnalités Principales**

**Interface Correspondants**
- Publication de contenus multimédias
- Géolocalisation automatique des publications
- Prévisualisation avant soumission
- Suivi des statistiques de publication

**Interface Administration/Modération**
- Validation des contenus avant publication
- Gestion des correspondants par pays
- Planification des programmes
- Modération des commentaires et interactions
- Tableau de bord analytique

**Interface Utilisateur Grand Public**
- Accès libre aux contenus (sans inscription obligatoire)
- Section "À la une" avec contenus prioritaires
- Replay intégral des émissions diffusées
- Programme TV des 72 heures à venir
- Diffusion en direct (live streaming)
- Chat en temps réel pendant les lives

### **Système d'Authentification Simplifié**

**Inscription Utilisateur (optionnelle pour l'interaction)**
- **Option 1** : Nom complet + numéro téléphone → OTP via SMS ou WhatsApp
- **Option 2** : Nom complet + email → OTP par email
- Validation par code OTP à 6 chiffres
- Création automatique de session après validation

**Fonctionnalités Utilisateur Connecté**
- Commentaires en temps réel
- Réactions (likes, favoris)
- Système de dons intégré
- Candidature pour participation à des émissions
- Partage de contenus
- Personnalisation par pays/région

### **Spécificités Techniques**

**Diffusion Live**
- Intégration YouTube Live
- Chat interactif synchronisé
- Système de modération en temps réel
- Enregistrement automatique pour replay

**Monétisation**
- Publicités YouTube intégrées
- Google AdSense
- Pop-ups publicitaires ciblés
- Système de dons volontaires

---

# WORKFLOW COMPLET - SYSTÈME HOSTONEW TV

## 1. ARCHITECTURE GÉNÉRALE DU SYSTÈME

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   UTILISATEURS  │    │    PLATEFORME    │    │  ADMINISTRATION │
│                 │    │                  │    │                 │
│ • Anonymes      │◄──►│  • Web App       │◄──►│ • Modérateurs   │
│ • Connectés     │    │  • Mobile App    │    │ • Admins        │
│ • Correspondants│    │  • API Backend   │    │ • Super Admin   │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

---

## 2. WORKFLOW UTILISATEUR ANONYME

### 2.1 Parcours Navigation Libre
```
ARRIVÉE SUR LA PLATEFORME
           ↓
┌─────────────────────────┐
│  SÉLECTION PAYS         │ → [Côte d'Ivoire, Mali, Burkina...]
│  (Géolocalisation auto  │
│   ou choix manuel)      │
└─────────────────────────┘
           ↓
┌─────────────────────────┐
│  PAGE ACCUEIL           │
│  • Vidéo hero           │ → Lecture automatique
│  • Carrousel actualités │ → Défilement 5s
│  • Grilles contenus     │ → À la une, À venir, Populaires
│  • Menu navigation      │ → 13 sections santé
└─────────────────────────┘
           ↓
┌─────────────────────────┐
│  CONSULTATION CONTENU   │
│  • Articles texte       │ → Lecture libre complète
│  • Vidéos               │ → Player intégré
│  • Émissions passées    │ → Replay disponible
│  • Lives en cours       │ → Visionnage sans interaction
└─────────────────────────┘
           ↓
┌─────────────────────────┐
│  LIMITATION INTERACTION │
│  • Pas de commentaires  │ → Invitation inscription
│  • Pas de likes/favoris │ → Modal "Connectez-vous"
│  • Pas de notifications │
│  • Pas de chat live     │
└─────────────────────────┘
```

### 2.2 Trigger Inscription
```
UTILISATEUR VEUT INTERAGIR
           ↓
┌─────────────────────────┐
│  MODAL INSCRIPTION      │
│  "Pour commenter,       │
│   likez ou ajouter      │ → Boutons : [S'INSCRIRE] [SE CONNECTER]
│   aux favoris"          │
└─────────────────────────┘
           ↓
    [REDIRECTION INSCRIPTION]
```

---

## 3. WORKFLOW INSCRIPTION UTILISATEUR

### 3.1 Processus Inscription Complète
```
DÉBUT INSCRIPTION
        ↓
┌─────────────────────────┐
│  CHOIX MODE INSCRIPTION │
│  ○ Email + Mot de passe │
│  ○ Téléphone + SMS      │ → Validation différente selon choix
│  ○ Google (OAuth)       │
│  ○ Facebook (OAuth)     │
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  SAISIE INFORMATIONS    │
│  • Nom, Prénom          │
│  • Email OU Téléphone   │ → Validation format temps réel
│  • Mot de passe x2      │ → Force mot de passe
│  • Pays origine         │ → Liste déroulante
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  VALIDATION BACKEND     │
│  • Unicité email/tel    │ → Si existe : "Compte déjà existant"
│  • Format données       │ → Erreurs spécifiques retournées
│  • Mot de passe sécurisé│ → Min 8 char, majusc, chiffre
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  GÉNÉRATION OTP         │
│  • Code 6 chiffres      │
│  • Expiration 5min      │ → Si email : envoi SMTP
│  • Stockage temporaire  │ → Si tel : simulation SMS
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  PAGE VÉRIFICATION      │
│  • Champ saisie OTP     │
│  • Timer décompte       │ → [04:32] Renvoyer code
│  • Bouton validation    │ → Max 3 tentatives
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  VÉRIFICATION OTP       │
│  • Comparaison code     │
│  • Vérif expiration     │ → Si OK : Activation compte
│  • Compteur tentatives  │ → Si KO : Message erreur
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  ACTIVATION COMPTE      │
│  • Statut = 'actif'     │
│  • Génération JWT       │ → Token 24h + Refresh 30j
│  • Création session     │ → Stockage sécurisé local
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  REDIRECTION ACCUEIL    │
│  • Message bienvenue    │
│  • Tour guidé optionnel │ → Overlay explicatif
│  • Profil à compléter   │ → Badge notification
└─────────────────────────┘
```

---

## 4. WORKFLOW UTILISATEUR CONNECTÉ

### 4.1 Session et Navigation
```
UTILISATEUR CONNECTÉ
        ↓
┌─────────────────────────┐
│  VÉRIFICATION SESSION   │
│  • Validation JWT       │ → Si expiré : Refresh automatique
│  • Mise à jour last_seen│ → Tracking activité
│  • Chargement profil    │ → Cache local 15min
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  INTERFACE ENRICHIE     │
│  • Avatar profil        │ → Menu déroulant utilisateur
│  • Badge notifications  │ → Compteur non lues
│  • Boutons interaction  │ → Like, Favori, Commentaire
└─────────────────────────┘
```

### 4.2 Interactions sur Contenus
```
CONSULTATION CONTENU
        ↓
┌─────────────────────────┐
│  COMPTAGE VUES          │
│  • Increment vues+1     │ → Seulement si > 30s visionnage
│  • Historique utilisateur│ → Ajout à "Récemment vus"
│  • Analytics            │ → Tracking comportement
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  ACTIONS DISPONIBLES    │
│  • [❤️ J'aime] (toggle) │ → Update likes_count
│  • [⭐ Favori] (toggle) │ → Ajout liste personnelle
│  • [💬 Commenter]       │ → Modal/section commentaires
│  • [📤 Partager]        │ → Liens partage (futur)
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  SYSTÈME COMMENTAIRES   │
│  • Édition commentaire  │ → Validation contenu
│  • Publication directe  │ → Si utilisateur régulier
│  • Modération si suspect│ → IA + mots-clés interdits
│  • Notifications auteur │ → Push + email
└─────────────────────────┘
```

### 4.3 Gestion Profil Personnel
```
ACCÈS PROFIL UTILISATEUR
        ↓
┌─────────────────────────┐
│  INFORMATIONS PERSO     │
│  • Modification nom/pré │ → Validation instantanée
│  • Changement email/tel │ → Re-vérification OTP
│  • Upload photo profil  │ → Compression auto + CDN
│  • Changement pays      │ → Impact contenus affichés
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  CONTENUS PERSONNALISÉS │
│  • Mes favoris (grid)   │ → Tri par date/catégorie
│  • Historique vues      │ → 100 derniers contenus
│  • Mes commentaires     │ → Avec liens contenus
│  • Notifications        │ → Gestion préférences
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  PARAMÈTRES COMPTE      │
│  • Notifications push   │ → On/Off par type
│  • Visibilité profil    │ → Public/Privé commentaires
│  • Langue interface     │ → FR/EN (futur)
│  • Suppression compte   │ → Confirmation + délai 7j
└─────────────────────────┘
```

---

## 5. WORKFLOW CORRESPONDANT INTERNATIONAL

### 5.1 Demande Statut Correspondant
```
UTILISATEUR VEUT DEVENIR CORRESPONDANT
        ↓
┌─────────────────────────┐
│  FORMULAIRE CANDIDATURE │
│  • Justification projet │ → Texte libre 500 char
│  • Expérience santé     │ → CV ou description
│  • Pays de couverture   │ → Un seul pays par correspondant
│  • Exemples contenus    │ → Liens ou fichiers
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  VALIDATION ADMIN       │
│  • Examen dossier       │ → Délai 48-72h
│  • Vérification antécéd.│ → Pas de sanctions
│  • Approbation/Refus    │ → Email notification
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  ACTIVATION RÔLE        │
│  • type_compte = corresp│ → Changement base données
│  • Accès interface pub  │ → Nouvelles permissions
│  • Formation guidée     │ → Tutorial publication
└─────────────────────────┘
```

### 5.2 Workflow Publication Correspondant
```
CORRESPONDANT CRÉE CONTENU
        ↓
┌─────────────────────────┐
│  INTERFACE PUBLICATION  │
│  • Sélection type       │ → Article, Vidéo, Live, Émission
│  • Pays auto-assigné    │ → Selon profil correspondant
│  • Catégorie obligatoire│ → Santé, Nutrition, etc.
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  SAISIE CONTENU         │
│  • Titre (5-255 char)   │ → Validation temps réel
│  • Description courte   │ → 160 char pour SEO
│  • Contenu complet      │ → Éditeur riche HTML
│  • Upload miniature     │ → Format 640x427 auto-crop
│  • Upload média         │ → Vidéo ou images
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  PRÉVISUALISATION       │
│  • Aperçu rendu final   │ → Page comme utilisateurs
│  • Vérifications auto   │ → Liens, format, taille
│  • Estimation lecture   │ → Temps basé sur mots
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  SOUMISSION MODÉRATION  │
│  • Statut = 'brouillon' │ → En attente validation
│  • Notification admins  │ → Email + dashboard badge
│  • Confirmation corresp │ → "Envoyé en modération"
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  SUIVI PUBLICATION      │
│  • Dashboard personnel  │ → Liste publications + statuts
│  • Notifications retour │ → Approuvé/Rejeté avec motifs
│  • Statistiques         │ → Vues, likes post-publication
└─────────────────────────┘
```

---

## 6. WORKFLOW MODÉRATION ADMINISTRATIVE

### 6.1 File d'Attente Modération
```
CONTENU SOUMIS PAR CORRESPONDANT
        ↓
┌─────────────────────────┐
│  AJOUT FILE MODÉRATION  │
│  • Tri par ancienneté   │ → FIFO par défaut
│  • Priorité par type    │ → Live > Actualité > Article
│  • Badge notification   │ → Compteur dashboard admin
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  PRISE EN CHARGE ADMIN  │
│  • Sélection contenu    │ → Lock temporaire (30min)
│  • Interface modération │ → Aperçu + outils validation
│  • Historique auteur    │ → Précédentes publications
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  VÉRIFICATIONS QUALITÉ  │
│  • Contenu approprié    │ → Pas de fake news/danger
│  • Orthographe/gramm.   │ → Suggestions correction
│  • Médias fonctionnels  │ → Test lecture vidéos/images
│  • Catégorie correcte   │ → Ajustement si nécessaire
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  DÉCISION MODÉRATION    │
│  [APPROUVER]            │ → Publication immédiate
│  [REJETER]              │ → Avec motif obligatoire
│  [DEMANDER CORRECTION]  │ → Retour correspondant
└─────────────────────────┘
```

### 6.2 Workflow Approbation
```
ADMIN CLIQUE [APPROUVER]
        ↓
┌─────────────────────────┐
│  PUBLICATION AUTOMATIQUE│
│  • Statut = 'publié'    │ → Visible tous utilisateurs
│  • Date_publication NOW │ → Timestamp publication
│  • Index recherche      │ → Ajout moteur recherche
│  • Génération miniature │ → Si pas fournie
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  NOTIFICATIONS POST-PUB │
│  • Email correspondant  │ → "Contenu publié avec succès"
│  • Push utilisateurs    │ → Si suivent catégorie/pays
│  • Réseaux sociaux      │ → Auto-post futur
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  MISE À JOUR STATISTIQUES│
│  • Compteurs globaux    │ → +1 contenu publié
│  • Stats correspondant  │ → Historique performance
│  • Analytics dashboard  │ → Graphiques temps réel
└─────────────────────────┘
```

### 6.3 Workflow Rejet
```
ADMIN CLIQUE [REJETER]
        ↓
┌─────────────────────────┐
│  SAISIE MOTIF REJET     │
│  • Catégories prédéf.   │ → Contenu inapproprié, Erreurs...
│  • Commentaire libre    │ → Explications détaillées
│  • Suggestions amélior. │ → Comment corriger
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  ARCHIVAGE CONTENU      │
│  • Statut = 'rejeté'    │ → Pas visible public
│  • Conservation données │ → Historique + apprentissage
│  • Log action admin     │ → Audit trail
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  NOTIFICATION REFUS     │
│  • Email correspondant  │ → Avec motifs détaillés
│  • Dashboard personnel  │ → Section "En révision"
│  • Possibilité re-soumission│ → Après corrections
└─────────────────────────┘
```

---

## 7. WORKFLOW STREAMING LIVE

### 7.1 Programmation Live
```
ADMIN PROGRAMME LIVE
        ↓
┌─────────────────────────┐
│  CRÉATION ÉVÉNEMENT     │
│  • Titre émission       │ → Ex: "Dr. Kouassi - Nutrition"
│  • Date/heure diffusion │ → Picker avec timezone
│  • Durée estimée        │ → En minutes
│  • Animateur/Invités    │ → Tags participants
│  • Description détaillée│ → Résumé programme
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  GÉNÉRATION URLs        │
│  • URL streaming RTMP   │ → Pour OBS/logiciel diffusion
│  • Clé de diffusion     │ → Token sécurisé unique
│  • URL publique        │ → Pour spectateurs
│  • Backup YouTube      │ → URL intégration secours
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  NOTIFICATIONS PROGRAMME│
│  • Email abonnés        │ → 24h + 1h avant
│  • Push notifications   │ → Rappels programmables
│  • Publication programme│ → Section "À venir"
│  • Calendriers externes │ → Export iCal/Google
└─────────────────────────┘
```

### 7.2 Démarrage Live
```
HEURE PRÉVUE ÉMISSION
        ↓
┌─────────────────────────┐
│  PRÉPARATION TECHNIQUE  │
│  • Test connexion RTMP  │ → Vérif serveur streaming
│  • Initialisation chat  │ → WebSocket room création
│  • Page live accessible │ → URL publique active
│  • Compteurs à zéro     │ → Spectateurs, messages
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  ADMIN LANCE DIFFUSION  │
│  • Clic bouton "START"  │ → Dashboard admin
│  • Statut = 'en_cours'  │ → BDD mise à jour
│  • Timer décompte       │ → Durée émission
│  • Notifications immé.  │ → "LIVE maintenant!"
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  STREAMING ACTIF        │
│  • Réception flux RTMP  │ → Depuis logiciel animateur
│  • Distribution spectateurs│ → Via CDN/serveur media
│  • Chat temps réel      │ → WebSocket bidirectionnel
│  • Statistiques live    │ → Compteurs temps réel
└─────────────────────────┘
```

### 7.3 Interaction Chat Live
```
UTILISATEUR CONNECTÉ REJOINT LIVE
        ↓
┌─────────────────────────┐
│  CONNEXION WEBSOCKET    │
│  • Authentif JWT        │ → Validation token
│  • Join room live_123   │ → Socket room ID = live ID
│  • Chargement historique│ → 20 derniers messages
│  • État "en ligne"      │ → Badge utilisateur actif
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  INTERFACE CHAT         │
│  • Messages défilants   │ → Auto-scroll nouveau message
│  • Zone saisie active   │ → Placeholder "Tapez..."
│  • Émojis/réactions     │ → Panel émojis intégré
│  • Modération temps réel│ → Filtres mots interdits
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  ENVOI MESSAGE          │
│  • Validation contenu   │ → Anti-spam + filtres
│  • Broadcast à tous     │ → WebSocket emit room
│  • Stockage historique  │ → BDD pour replay
│  • Notifications admins │ → Si contenu suspect
└─────────────────────────┘
```

### 7.4 Fin de Live
```
ADMIN ARRÊTE DIFFUSION
        ↓
┌─────────────────────────┐
│  CLÔTURE TECHNIQUE      │
│  • Arrêt flux RTMP      │ → Serveur stop reception
│  • Fermeture chat       │ → WebSocket disconnect
│  • Statut = 'terminé'   │ → BDD + UI update
│  • Enregistrement stats │ → Spectateurs max, durée réelle
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  GÉNÉRATION REPLAY      │
│  • Sauvegarde vidéo     │ → Fichier MP4 généré
│  • Upload vers CDN      │ → Cloudinary/AWS
│  • Création contenu     │ → Type = 'replay'
│  • Indexation recherche │ → Ajout moteur recherche
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  POST-LIVE ACTIONS      │
│  • Email récap animateur│ → Statistiques détaillées
│  • Notification replay  │ → "Replay disponible"
│  • Analytics update     │ → Dashboard métriques
│  • Archive chat         │ → Consultation possible
└─────────────────────────┘
```

---

## 8. WORKFLOW NOTIFICATIONS SYSTÈME

### 8.1 Types et Triggers
```
ÉVÉNEMENTS DÉCLENCHEURS
        ↓
┌─────────────────────────┐
│  NOUVEAU CONTENU PUBLIÉ │ → Notification abonnés catégorie/pays
│  LIVE COMMENCE          │ → Push immédiat + email
│  COMMENTAIRE REÇU       │ → Notification auteur contenu
│  RÉPONSE COMMENTAIRE    │ → Notification auteur commentaire
│  CONTENU APPROUVÉ/REJETÉ│ → Email correspondant
│  LIVE DANS 1H          │ → Rappel abonnés
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  GÉNÉRATION NOTIFICATION│
│  • Titre accrocheur     │ → Max 50 caractères
│  • Message personnalisé │ → Nom utilisateur inclus
│  • Lien action directe  │ → Deep link vers contenu
│  • Icône/image         │ → Miniature contenu
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  DISTRIBUTION MULTI-CANAL│
│  • Push mobile          │ → Firebase/OneSignal
│  • Notification web     │ → Browser API
│  • Email si important   │ → Live, validation correspondant
│  • Badge in-app        │ → Compteur non lues
└─────────────────────────┘
```

### 8.2 Gestion Préférences Utilisateur
```
UTILISATEUR GÈRE SES NOTIFICATIONS
        ↓
┌─────────────────────────┐
│  PAGE PARAMÈTRES        │
│  • Notifications push   │ → Toggle ON/OFF global
│  • Par catégorie        │ → Santé, Nutrition, etc.
│  • Par type contenu     │ → Article, Vidéo, Live
│  • Fréquence emails     │ → Immédiat, Quotidien, Hebdo
│  • Horaires acceptables │ → 8h-22h par exemple
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  SAUVEGARDE PRÉFÉRENCES │
│  • Update profil BDD    │ → Stockage permanent
│  • Mise à jour tokens   │ → Push notification services
│  • Test notification    │ → Validation fonctionnement
└─────────────────────────┘
```

---

## 9. WORKFLOW RECHERCHE ET DÉCOUVERTE

### 9.1 Recherche Utilisateur
```
UTILISATEUR TAPE RECHERCHE
        ↓
┌─────────────────────────┐
│  SAISIE AUTO-COMPLÉTÉE  │
│  • Suggestions temps réel│ → API recherche
│  • Historique personnel │ → Dernières recherches
│  • Tendances populaires │ → Mots-clés fréquents
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  EXÉCUTION RECHERCHE    │
│  • Multi-critères       │ → Titre, description, tags
│  • Filtrage pays        │ → Selon sélection utilisateur
│  • Tri par pertinence   │ → Score algorithme + date
│  • Pagination résultats │ → 20 éléments par page
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  AFFICHAGE RÉSULTATS    │
│  • Grille responsive    │ → Cards avec miniatures
│  • Filtres latéraux     │ → Type, catégorie, date
│  • Statistiques         │ → "145 résultats trouvés"
│  • Suggestions         │ → "Recherches similaires"
└─────────────────────────┘
```

### 9.2 Recommandations Personnalisées
```
UTILISATEUR CONSULTE CONTENU
        ↓
┌─────────────────────────┐
│  TRACKING COMPORTEMENT  │
│  • Contenu vu           │ → Ajout historique
│  • Temps visionnage     │ → Indicateur intérêt
│  • Interactions         │ → Likes, commentaires
│  • Catégories préférées │ → Calcul préférences
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  ALGORITHME RECOMMAND.  │
│  • Similarité contenus  │ → Même catégorie/auteur
│  • Comportement similaire│ → Autres utilisateurs proches
│  • Tendances pays       │ → Populaire dans sa région
│  • Fraîcheur contenu    │ → Boost contenus récents
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  AFFICHAGE SUGGESTIONS  │
│  • Section "Pour vous"  │ → Accueil personnalisé
│  • "Contenus similaires"│ → Fin de lecture/vidéo
│  • "Tendances pays"     │ → Section dédiée
└─────────────────────────┘
```

---

## 10. WORKFLOW ANALYTICS ET REPORTING

### 10.1 Collecte Données Temps Réel
```
ACTIONS UTILISATEURS
        ↓
┌─────────────────────────┐
│  ÉVÉNEMENTS TRACKÉS     │
│  • Page vue             │ → URL + timestamp + user
│  • Clic bouton          │ → Type action + contexte
│  • Temps session        │ → Durée + pages visitées
│  • Interactions sociales│ → Like, comment, share
│  • Abandon              │ → Où l'utilisateur quitte
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  TRAITEMENT DONNÉES     │
│  • Anonymisation        │ → RGPD compliance
│  • Agrégation          │ → Par période/catégorie
│  • Calculs métriques    │ → Taux engagement, etc.
│  • Stockage warehouse   │ → Base données analytics
└─────────────────────────┘
```

### 10.2 Dashboard Analytics
```
ADMIN CONSULTE STATISTIQUES
        ↓
┌─────────────────────────┐
│  MÉTRIQUES GLOBALES     │
│  • Utilisateurs actifs  │ → Aujourd'hui/Semaine/Mois
│  • Contenus consultés   │ → Top 10 + évolution
│  • Engagement moyen     │ → Temps/session, pages/visite
│  • Répartition pays     │ → Graphique camembert
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  ANALYSES CONTENU       │
│  • Performance articles │ → Vues, likes, commentaires
│  • Succès correspondants│ → Classement productivité
│  • Catégories populaires│ → Tendances thématiques
│  • Heures pic audience  │ → Optimisation diffusion
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  EXPORTS ET RAPPORTS    │
│  • Rapport hebdomadaire │ → PDF automatique
│  • Export données CSV   │ → Pour analyses externes
│  • Tableaux de bord     │ → Widgets configurables
└─────────────────────────┘
```

---

## 11. WORKFLOW TECHNIQUE BACKEND

### 11.1 Architecture Microservices
```
REQUEST UTILISATEUR
        ↓
┌─────────────────────────┐
│  GATEWAY API            │
│  • Authentification     │ → Validation JWT
│  • Rate limiting        │ → Protection DDoS
│  • Routage services     │ → Load balancing
│  • Logging              │ → Audit trail
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  SERVICES MÉTIER        │
│  • Auth Service         │ → Login, register, tokens
│  • Content Service      │ → CRUD contenus
│  • User Service         │ → Profils, préférences
│  • Notification Service │ → Push, email, SMS
│  • Live Service         │ → Streaming, chat
│  • Analytics Service    │ → Métriques, reporting
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  COUCHE DONNÉES         │
│  • PostgreSQL           │ → Données relationnelles
│  • Redis Cache          │ → Sessions, cache API
│  • Cloudinary          │ → Stockage médias
│  • Elasticsearch       │ → Moteur recherche
└─────────────────────────┘
```

### 11.2 Pipeline CI/CD
```
COMMIT DÉVELOPPEUR
        ↓
┌─────────────────────────┐
│  TESTS AUTOMATISÉS      │
│  • Tests unitaires      │ → Jest + coverage
│  • Tests intégration    │ → API endpoints
│  • Tests E2E            │ → Cypress/Playwright
│  • Linting/Format       │ → ESLint + Prettier
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  BUILD ET PACKAGING     │
│  • Compilation TS       │ → JS optimisé
│  • Bundle optimisation  │ → Tree shaking
│  • Docker image        │ → Container prêt
│  • Versionning         │ → Tags sémantiques
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  DÉPLOIEMENT            │
│  • Staging environment  │ → Tests finaux
│  • Production deploy    │ → Rolling update
│  • Health checks       │ → Monitoring auto
│  • Rollback si erreur   │ → Version précédente
└─────────────────────────┘
```

---

## 12. SÉCURITÉ ET CONFORMITÉ

### 12.1 Workflow Sécurité
```
REQUÊTE UTILISATEUR
        ↓
┌─────────────────────────┐
│  VALIDATION ENTRÉE      │
│  • Sanitisation XSS     │ → HTML entities encode
│  • Validation SQL       │ → Prepared statements
│  • Limite taille        │ → Max upload/request
│  • Format vérification  │ → Types attendus
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  AUTHENTIFICATION       │
│  • JWT validation       │ → Token non expiré
│  • Permissions vérif.   │ → Rôles et ressources
│  • Rate limiting        │ → Max requêtes/minute
│  • IP whitelisting      │ → Si nécessaire
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  AUDIT ET LOGGING       │
│  • Actions sensibles    │ → Log avec timestamp
│  • Tentatives piratage  │ → Alerte sécurité
│  • Performance metrics  │ → Monitoring continu
└─────────────────────────┘
```

### 12.2 Conformité RGPD
```
DONNÉE PERSONNELLE COLLECTÉE
        ↓
┌─────────────────────────┐
│  CONSENTEMENT           │
│  • Opt-in explicite     │ → Checkbox non pré-cochée
│  • Finalités claires    │ → Usage données expliqué
│  • Droit retrait        │ → Désabonnement facile
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  TRAITEMENT SÉCURISÉ    │
│  • Chiffrement stockage │ → Mots de passe hashés
│  • Accès restreint      │ → Admin seuls
│  • Anonymisation       │ → Analytics sans ID
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  DROITS UTILISATEURS    │
│  • Accès données       │ → Export profil complet
│  • Rectification       │ → Modification infos
│  • Suppression         │ → Delete account + données
│  • Portabilité         │ → Export format standard
└─────────────────────────┘
```

# DEVELOPPEMENT

*Lancer tests unitaires*
        flutter test test/pages/accueil_page_test.dart

*Lancer app en mode debug*
        flutter run -d chrome --web-renderer html

*Tester sur device Android*
        flutter run -d <device-id>

*Hot reload pour développement rapide*
        Utiliser 'r' pour hot reload, 'R' pour hot restart



# ANALYSE COMPLÈTE MÉTHODIQUE HOSTONEW TV FLUTTER 

## 1. RAPPEL OBJECTIF ET CONSIGNES

**Objectif principal :** Application Flutter web/mobile pour plateforme d'information santé HostoNew TV

**Consignes techniques :**
- Même code source pour web et mobile
- Système professionnel mais simple
- Couleurs santé douces et fluides
- Éléments grands et bien espacés
- Animations fluides d'apparition
- Noms fichiers français explicites
- Navigation simple centralisée
- Gestionnaire permissions centralisé
- Commencer par page d'accueil fonctionnelle

## 2. FONCTIONNALITÉS À DÉVELOPPER (PAR PRIORITÉ)

### 2.1 Fonctionnalités Core (MVP)
1. **Accès libre consultation** - Navigation et lecture contenus sans compte
2. **Sélection pays** - Choix parmi 13 pays avec géolocalisation
3. **Affichage contenus** - Articles, vidéos, émissions par catégories
4. **Recherche et filtrage** - Par pays, catégorie, type de contenu
5. **Page détail contenu** - Lecture article ou visionnage vidéo

### 2.2 Fonctionnalités Authentification
1. **Inscription simple** - Email OU téléphone + OTP
2. **Connexion utilisateur** - Avec récupération mot de passe
3. **Gestion profil** - Modification informations personnelles

### 2.3 Fonctionnalités Interactives (Utilisateur connecté)
1. **Système commentaires** - Sur tous types de contenus
2. **Réactions** - Likes, favoris, partages
3. **Historique personnel** - Contenus vus récemment
4. **Favoris** - Sauvegarde contenus préférés
5. **Notifications** - Nouveaux contenus, réponses commentaires

### 2.4 Fonctionnalités Live (Avancées)
1. **Streaming direct** - Visionnage lives en cours
2. **Chat temps réel** - Interaction pendant lives
3. **Programme TV** - Planification 72h avec notifications
4. **Replay automatique** - Accès émissions passées

## 3. ARCHITECTURE FICHIERS COMPLÈTE

### 3.1 Structure Racine
```
lib/
├── main.dart                           # Point d'entrée application
├── application_hostonew.dart           # Configuration app principale
│
├── config/                             # Configuration globale
├── donnees/                            # Couche données et logique métier
├── interface/                          # Couche présentation
├── utilitaires/                        # Fonctions utilitaires
└── assets/                             # Ressources statiques
```

### 3.2 Dossier Config (Configuration)
```
config/
├── couleurs_app.dart                   # Palette couleurs santé
├── tailles_app.dart                    # Espacements et dimensions
├── theme_app.dart                      # Thème Flutter global
├── constantes_app.dart                 # URLs API et constantes
├── environnement.dart                  # Config dev/prod
└── permissions_config.dart             # Configuration permissions
```

### 3.3 Dossier Données (Data Layer)
```
donnees/
├── modeles/                            # Classes modèles
│   ├── utilisateur_modele.dart
│   ├── contenu_modele.dart
│   ├── pays_modele.dart
│   ├── categorie_modele.dart
│   ├── commentaire_modele.dart
│   ├── reaction_modele.dart
│   ├── live_modele.dart
│   └── programme_modele.dart
│
├── services/                           # Services API et métier
│   ├── api_client.dart                 # Client HTTP centralisé
│   ├── authentification_service.dart   # Service auth
│   ├── contenu_service.dart            # Service contenus
│   ├── pays_service.dart               # Service pays
│   ├── commentaire_service.dart        # Service commentaires
│   ├── live_service.dart               # Service streaming
│   └── notification_service.dart       # Service notifications
│
├── repositories/                       # Repositories (abstraction)
│   ├── utilisateur_repository.dart
│   ├── contenu_repository.dart
│   └── pays_repository.dart
│
├── providers/                          # Gestionnaires d'état
│   ├── authentification_provider.dart
│   ├── contenu_provider.dart
│   ├── pays_provider.dart
│   ├── recherche_provider.dart
│   └── live_provider.dart
│
└── stockage/                          # Stockage local
    ├── stockage_local.dart            # Préférences utilisateur
    ├── cache_manager.dart             # Gestion cache
    └── stockage_securise.dart         # Tokens et données sensibles
```

### 3.4 Dossier Interface (Presentation Layer)
```
interface/
├── pages/                             # Écrans principaux
│   ├── accueil/
│   │   ├── accueil_page.dart
│   │   └── composants_accueil/
│   ├── authentification/
│   │   ├── connexion_page.dart
│   │   ├── inscription_page.dart
│   │   └── verification_otp_page.dart
│   ├── contenu/
│   │   ├── detail_contenu_page.dart
│   │   ├── liste_contenus_page.dart
│   │   └── recherche_page.dart
│   ├── live/
│   │   ├── live_page.dart
│   │   ├── programme_tv_page.dart
│   │   └── replay_page.dart
│   ├── profil/
│   │   ├── profil_page.dart
│   │   ├── favoris_page.dart
│   │   ├── historique_page.dart
│   │   └── parametres_page.dart
│   └── systeme/
│       ├── selection_pays_page.dart
│       ├── erreur_page.dart
│       └── maintenance_page.dart
│
├── composants/                        # Widgets réutilisables
│   ├── communs/
│   │   ├── bouton_personnalise.dart
│   │   ├── champ_saisie_personnalise.dart
│   │   ├── carte_base.dart
│   │   ├── chargement_widget.dart
│   │   └── message_erreur_widget.dart
│   ├── navigation/
│   │   ├── header_app.dart
│   │   ├── menu_navigation.dart
│   │   └── fil_ariane.dart
│   ├── contenu/
│   │   ├── carte_contenu.dart
│   │   ├── grille_contenus.dart
│   │   ├── lecteur_video.dart
│   │   └── carrousel_actualites.dart
│   ├── authentification/
│   │   ├── formulaire_connexion.dart
│   │   └── formulaire_inscription.dart
│   └── live/
│       ├── lecteur_live.dart
│       ├── chat_live.dart
│       └── compteur_spectateurs.dart
│
└── animations/                        # Animations personnalisées
    ├── fade_in_animation.dart
    ├── slide_animation.dart
    └── loading_animation.dart
```

### 3.5 Dossier Utilitaires
```
utilitaires/
├── navigation/
│   ├── navigation_service.dart         # Service navigation centralisé
│   ├── routes_app.dart                # Définition routes
│   └── garde_authentification.dart    # Protection routes
├── permissions/
│   ├── permissions_manager.dart       # Gestionnaire permissions
│   └── permissions_helper.dart        # Helpers permissions
├── validateurs/
│   ├── validateur_email.dart
│   ├── validateur_telephone.dart
│   └── validateur_mot_de_passe.dart
├── helpers/
│   ├── formatage_helper.dart          # Format dates, textes
│   ├── image_helper.dart              # Manipulation images
│   └── url_helper.dart                # Gestion URLs
├── extensions/
│   ├── string_extension.dart
│   ├── datetime_extension.dart
│   └── widget_extension.dart
└── constantes/
    ├── types_contenu.dart
    ├── statuts_app.dart
    └── messages_erreur.dart
```

## 4. WORKFLOW DÉVELOPPEMENT STRUCTURÉ

### 4.1 Phase 1 : Fondations (3-4 jours)
**Objectif :** Créer base solide sans fonctionnalités

**Jour 1 : Configuration projet**
- Setup pubspec.yaml avec dépendances essentielles
- Création structure dossiers complète
- Configuration couleurs, tailles, thème
- Configuration navigation de base

**Jour 2 : Modèles et services base**
- Modèles de données essentiels (Contenu, Utilisateur, Pays)
- Client API avec gestion erreurs
- Service de stockage local
- Gestionnaire permissions

**Jour 3 : Composants de base**
- Boutons, champs saisie, cartes standard
- Widgets de chargement et erreur
- Header application
- Navigation simple

**Jour 4 : Tests fondations**
- Tests unitaires modèles
- Tests services de base
- Tests composants isolés
- Validation architecture

### 4.2 Phase 2 : Page Accueil (4-5 jours)
**Objectif :** Page accueil complète et fonctionnelle

**Jour 5-6 : Structure page accueil**
- Layout responsive de base
- Header avec sélection pays
- Sections vides mais structurées
- Navigation entre sections

**Jour 7-8 : Intégration contenu**
- Service contenus avec API
- Provider gestion état contenus
- Affichage listes contenus
- Gestion états chargement/erreur

**Jour 9 : Finitions accueil**
- Animations d'apparition
- Polish responsive
- Tests page complète
- Optimisations performances

### 4.3 Phase 3 : Navigation et Contenu (4-5 jours)
**Objectif :** Navigation fluide et affichage contenus

**Jour 10-11 : Pages système**
- Sélection pays avec animations
- Page détail contenu
- Pages erreur et maintenance
- Navigation entre pages

**Jour 12-13 : Recherche et filtrage**
- Page recherche avec filtres
- Autocomplétion
- Historique recherches
- Résultats paginés

**Jour 14 : Tests navigation**
- Tests navigation complète
- Tests responsive toutes pages
- Corrections bugs identifiés

### 4.4 Phase 4 : Authentification (4-5 jours)
**Objectif :** Système auth complet et sécurisé

**Jour 15-16 : Pages authentification**
- Formulaires connexion/inscription
- Validation temps réel
- Gestion erreurs API
- Transitions fluides

**Jour 17-18 : Logic authentification**
- Service auth avec JWT
- Stockage sécurisé tokens
- Gestion sessions
- Protection routes

**Jour 19 : Integration auth**
- States connecté/déconnecté
- Persistance session
- Tests complets auth
- Sécurisation

### 4.5 Phase 5 : Fonctionnalités Utilisateur (5-6 jours)
**Objectif :** Interactions utilisateur connecté

**Jour 20-21 : Profil utilisateur**
- Page profil avec modification
- Gestion avatar
- Historique et favoris
- Paramètres compte

**Jour 22-23 : Interactions**
- Système commentaires
- Likes et favoris
- Partage contenus
- Notifications

**Jour 24-25 : Polish interactions**
- Animations interactions
- Feedback utilisateur
- States optimistes
- Tests utilisateur

### 4.6 Phase 6 : Live et Avancé (6-7 jours)
**Objectif :** Fonctionnalités streaming

**Jour 26-27 : Base streaming**
- Lecteur vidéo personnalisé
- Integration streaming
- Interface live
- États live/replay

**Jour 28-29 : Chat temps réel**
- WebSocket integration
- Chat interface
- Modération base
- Notifications live

**Jour 30-32 : Programme TV**
- Calendrier émissions
- Notifications programmées
- Replay automatique
- Finalisation

## 5. CRITÈRES VALIDATION PAR PHASE

### 5.1 Phase 1 Validée Si :
- App se lance sans erreur
- Navigation base fonctionne
- Thème appliqué correctement
- Architecture claire et extensible

### 5.2 Phase 2 Validée Si :
- Page accueil responsive complète
- Chargement contenus depuis API
- Animations fluides
- Performance acceptable (< 3s)

### 5.3 Phases Suivantes Validées Si :
- Fonctionnalités complètes testées
- Interface responsive
- Pas de régression phases précédentes
- Code documenté et maintenable

## 6. OUTILS ET TESTS NÉCESSAIRES

### 6.1 Tests Automatisés
- Tests unitaires : modèles, services, utilitaires
- Tests widgets : composants isolés
- Tests intégration : flux utilisateur
- Tests golden : interface visuelle

### 6.2 Tests Manuels
- Tests multi-devices (iOS, Android, Web)
- Tests orientations
- Tests performances
- Tests accessibilité
