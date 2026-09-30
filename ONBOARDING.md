# Second Life — Guide de prise en main

> Ce document est destiné à tous ceux qui rejoignent le projet. Lisez-le **intégralement** avant d'écrire la moindre ligne de code.

---

## Table des matières

1. [Architecture du projet](#1-architecture-du-projet)
2. [Installation & lancement](#2-installation--lancement)
3. [Système de design — règles d'or](#3-système-de-design--règles-dor)
4. [Widgets préconfigurés](#4-widgets-préconfigurés)
5. [Navigation & routing](#5-navigation--routing)
6. [State management — Riverpod](#6-state-management--riverpod)
7. [Thème & mode sombre](#7-thème--mode-sombre)
8. [Localisation (i18n)](#8-localisation-i18n)
9. [Services partagés](#9-services-partagés)
10. [Extensions disponibles](#10-extensions-disponibles)
11. [Logger](#11-logger)
12. [Code generation](#12-code-generation)
13. [Conventions & règles à respecter](#13-conventions--règles-à-respecter)

---

## 1. Architecture du projet

```
lib/
├── core/
│   ├── configs/        → Logger, AppConfig, variables d'environnement (Env)
│   ├── constants/      → Chemins d'assets, canaux de notification, clés prefs
│   ├── extensions/     → Extensions BuildContext, String, DateTime, navigation
│   ├── routing/        → GoRouter, AppRoutes, AppTransitions, AppNavigatorKey
│   └── theme/          → AppColors, AppSpacing, AppTextStyles, AppTheme
├── l10n/               → Fichiers ARB (fr/en) + code généré de localisation
└── shared/
    ├── data/
    │   ├── domain/     → Interfaces (StorageRepository)
    │   ├── repositories/ → Implémentations (LocalStorageRepositoryImpl)
    │   ├── services/   → NotificationService
    │   └── sources/    → PrefsStorage (SharedPreferences)
    └── presentation/
        ├── providers/  → Providers Riverpod partagés (thème, locale, stockage, notifications)
        └── widgets/
            ├── buttons/    → AppElevatedButton, AppOutlinedButton
            ├── inputs/     → AppTextFormField
            └── others/     → Skeleton, AppAnimatedSwitcher, AppIconSwitcher…
```

**Chaque feature sera autonome.** Ne pas faire d'import croisé entre features — passer par `shared/` si quelque chose doit être partagé.

---

## 2. Installation & lancement

```bash
# 1. Récupérer les dépendances
flutter pub get

# 2. Générer le code (Riverpod)
dart run build_runner build --delete-conflicting-outputs

# 3. Lancer l'app
flutter run
```

> Après tout ajout ou modification d'une annotation `@riverpod`, relancer la génération de code.

---

## 3. Système de design — règles d'or

### 3.1 Couleurs — ne jamais utiliser directement `AppColors` dans les widgets

`AppColors` contient la palette brute. Elle **n'est pas utilisée directement** dans les widgets. Toujours passer par le `ColorScheme` Material ou le `BuildContext`.

```dart
// ✅ Correct
final color  = context.colorScheme.primary;
final bg     = context.colorScheme.surface;
final error  = context.colorScheme.error;

// ✅ Correct aussi (via Theme)
final color = Theme.of(context).colorScheme.secondary;

// ❌ Interdit — couplage direct à la palette brute
final color = AppColors.primary;
```

**Correspondances importantes du ColorScheme :**

| Besoin | ColorScheme key |
|---|---|
| Couleur principale (vert) | `primary` |
| Texte sur couleur principale | `onPrimary` |
| Fond de page | `surface` |
| Fond de carte | `surfaceContainerLow` |
| Texte principal | `onSurface` |
| Texte secondaire | `onSurfaceVariant` |
| Erreur | `error` |
| Contour/Divider | `outlineVariant` |

### 3.2 Typographie — passer par `TextTheme`

```dart
// ✅ Correct
Text('Titre',  style: context.textTheme.headlineMedium)
Text('Corps',  style: context.textTheme.bodyLarge)

// ❌ Interdit — style codé en dur
Text('Titre', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
```

**Hiérarchie typographique (Bricolage Grotesque / Figtree) :**

| Style | Taille | Usage |
|---|---|---|
| `displayLarge` | 48 | Chiffres hero, grandes accroches |
| `headlineLarge/Medium` | 36 / 26 | Titres de page |
| `headlineSmall` / `titleLarge` | 19 | Titres de section |
| `titleMedium` | 17 | Titres de carte |
| `bodyLarge/Medium` | 17 / 15 | Texte courant |
| `bodySmall` / `labelSmall` | 13 | Légendes, meta-info |
| `labelLarge` | 15 | Boutons, labels de formulaire |

### 3.3 Espacements — utiliser `AppSpacing`

Tous les espacements sont définis sur une grille de **4 px**. Ne jamais écrire de valeur magique.

```dart
// ✅ Correct
Padding(padding: AppSpacing.cardPadding)         // padding standard de carte
Padding(padding: AppSpacing.screenPadding)        // padding de page (h:16, v:12)
SizedBox(height: AppSpacing.lg)                   // 16 px
BorderRadius.circular(AppSpacing.radiusXl)        // 20 px

// ❌ Interdit
Padding(padding: EdgeInsets.all(14))
SizedBox(height: 20)
```

**Échelle d'espacement :**

| Token | Valeur | Usage typique |
|---|---|---|
| `AppSpacing.xs` | 4 px | Micro-espaces |
| `AppSpacing.sm` | 8 px | Espaces internes serrés |
| `AppSpacing.md` | 12 px | Espaces internes standard |
| `AppSpacing.lg` | 16 px | Marges entre éléments |
| `AppSpacing.xl` | 20 px | Espaces confortables |
| `AppSpacing.xxl` | 24 px | Sections |
| `AppSpacing.xxxl` | 32 px | Grandes sections |
| `AppSpacing.huge` | 40 px | Espaces très larges |

**Paddings prêts à l'emploi :**

```dart
AppSpacing.screenPadding        // EdgeInsets.symmetric(h: 16, v: 12) — page
AppSpacing.cardPadding          // EdgeInsets.all(16)                  — carte
AppSpacing.cardPaddingCompact   // EdgeInsets.symmetric(h: 16, v: 12)
AppSpacing.buttonPaddingMd      // EdgeInsets.symmetric(h: 20, v: 12)
AppSpacing.dialogPadding        // EdgeInsets.all(24)
AppSpacing.bottomSheetPadding   // EdgeInsets.fromLTRB(16, 24, 16, 16)
```

**Gaps prêts à l'emploi :**

```dart
AppSpacing.gapVXs   // SizedBox(height: 4)
AppSpacing.gapVSm   // SizedBox(height: 8)
AppSpacing.gapVMd   // SizedBox(height: 12)
AppSpacing.gapVLg   // SizedBox(height: 16)
AppSpacing.gapVXl   // SizedBox(height: 20)
AppSpacing.gapVXxl  // SizedBox(height: 24)
AppSpacing.gapVHuge // SizedBox(height: 40)

AppSpacing.gapHSm   // SizedBox(width: 8)
AppSpacing.gapHMd   // SizedBox(width: 12)
AppSpacing.gapHLg   // SizedBox(width: 16)
```

**Border radius prêts à l'emploi :**

```dart
AppSpacing.roundedSm    // BorderRadius.circular(8)
AppSpacing.roundedMd    // BorderRadius.circular(14)
AppSpacing.roundedXl    // BorderRadius.circular(20)
AppSpacing.roundedFull  // BorderRadius.circular(999) — pilules
AppSpacing.roundedTopLg // Arrondi uniquement en haut (bottom sheet)
```

**Durées d'animation :**

```dart
AppSpacing.durationFast   // 200ms — apparition d'élément, onglet
AppSpacing.durationBase   // 300ms — transition d'écran, bottom sheet
AppSpacing.durationSlow   // 450ms — transformation d'élément
```

### 3.4 Mode sombre — ne pas hardcoder les couleurs

Le thème gère automatiquement light/dark. Utilisez toujours le `ColorScheme` — les bonnes couleurs sont appliquées selon le mode.

```dart
// Vérifier le mode courant si besoin
final isDark = context.isDarkMode;
```

### 3.5 Icônes — utiliser LucideIcons

Toutes les icônes de l'app viennent de la bibliothèque **[Lucide](https://lucide.dev/icons)** via le package `lucide_icons`. Ne jamais utiliser `Icons.*` de Material.

```dart
import 'package:lucide_icons/lucide_icons.dart';

// ✅ Correct
Icon(LucideIcons.home)
Icon(LucideIcons.settings)
Icon(LucideIcons.mapPin)
Icon(LucideIcons.history)
Icon(LucideIcons.user)
Icon(LucideIcons.qrCode)
Icon(LucideIcons.bell)
Icon(LucideIcons.trash2)
Icon(LucideIcons.chevronRight)
Icon(LucideIcons.arrowLeft)

// ❌ Interdit
Icon(Icons.home)
Icon(Icons.settings)
```

> Pour trouver le nom d'une icône : [lucide.dev/icons](https://lucide.dev/icons) → chercher → le nom Flutter est en `camelCase` (`map-pin` → `LucideIcons.mapPin`).

---

## 4. Widgets préconfigurés

### 4.1 `AppScaffold` — écran de base

**Toujours utiliser `AppScaffold` à la place de `Scaffold` nu.**

```dart
import 'package:second_life/shared/presentation/widgets/layouts/app_scaffold.dart';

// Écran simple
AppScaffold(
  body: MyPageContent(),
)

// Écran scrollable
AppScaffold(
  scrollable: true,
  body: Column(children: [...]),
)

// Écran avec pull-to-refresh (implique scrollable)
AppScaffold(
  onRefresh: () async { /* rechargement */ },
  body: MyList(),
)

// Sans padding latéral (liste plein-écran)
AppScaffold(
  padding: EdgeInsets.zero,
  body: MyListView(),
)

// Écran avec bottom nav (contenu passe derrière)
AppScaffold(
  extendBody: true,
  bottomSafeArea: false,
  body: MyContent(),
)

// Avec fond décoratif
AppScaffold(
  backgroundBuilder: (child) => Stack(children: [MyBackground(), child]),
  body: MyContent(),
)

// Bloquer le retour arrière
AppScaffold(
  canPop: false,
  onPopInvokedWithResult: (didPop, result) { /* gérer */ },
  body: MyContent(),
)
```

**Paramètres importants :**

| Paramètre | Défaut | Description |
|---|---|---|
| `padding` | `AppSpacing.screenPadding` | Padding interne du body |
| `scrollable` | `false` | Rend le body scrollable |
| `onRefresh` | `null` | Active pull-to-refresh (implique scrollable) |
| `bottomSafeArea` | `true` | Ajoute la SafeArea en bas |
| `extendBody` | `false` | Le body passe derrière la bottom nav |
| `resizeToAvoidBottomInset` | `false` | Rétrécit quand le clavier apparaît |
| `statusBarColor` | scaffold bg | Couleur derrière la status bar |

---

### 4.2 `AppElevatedButton` — bouton principal

```dart
import 'package:second_life/shared/presentation/widgets/buttons/index.dart';

// Bouton simple
AppElevatedButton(
  text: 'Continuer',
  onPressed: _onContinue,
)

// Avec état chargement
AppElevatedButton(
  text: 'Envoyer',
  isLoading: _isSubmitting,
  onPressed: _onSubmit,
)

// Avec icône
AppElevatedButton(
  text: 'Scanner',
  icon: Icon(Icons.qr_code_scanner),
  onPressed: _onScan,
)

// Taille custom
AppElevatedButton(
  text: 'OK',
  buttonSize: Size(160, AppSpacing.buttonHeightMd),
  onPressed: _onConfirm,
)

// Désactivé
AppElevatedButton(
  text: 'Valider',
  enabled: false,
  onPressed: _onValidate,
)
```

---

### 4.3 `AppTextFormField` — champ de formulaire

```dart
import 'package:second_life/shared/presentation/widgets/inputs/index.dart';

// Champ basique
AppTextFormField(
  label: 'Email',
  hint: 'nom@exemple.com',
  keyboardType: TextInputType.emailAddress,
)

// Champ mot de passe
AppTextFormField(
  label: 'Mot de passe',
  obscureText: true,
)

// Avec validation
AppTextFormField(
  label: 'Prénom',
  validator: (v) => v!.isBlank ? 'Requis' : null,
)
```

---

## 5. Navigation & routing

### 5.1 Extensions de navigation — toujours les utiliser

Ne jamais construire les routes manuellement. Les extensions de `BuildContext` exposent des méthodes prêtes à l'emploi.

```dart
// Onglets principaux (remplace l'historique)
context.goHome()
context.goPlaces()
context.goHistory()
context.goProfile()

// Authentification
context.goAuthLogin()
context.goAuthSignup()
context.goAuthForgot()
context.goAuthResetPassword()

// Écrans de détail
context.goPlaceDetail('abc123')
context.pushPlaceDetail('abc123')

// Autres
context.goScan()
context.goOnboarding()

// Retour
context.popScreen()          // pop simple
context.popScreen('résultat') // pop avec résultat typé
```

### 5.2 Ajouter une route

**Étape 1** — Ajouter le chemin dans `lib/core/routing/app_routes.dart` :

```dart
static const String myNewScreen = '/my-new-screen';
```

**Étape 2** — Ajouter la route dans `lib/core/routing/app_router.dart` :

```dart
GoRoute(
  path: AppRoutes.myNewScreen,
  pageBuilder: (context, state) => AppTransitions.pushedScreen(
    context: context,
    state: state,
    child: const MyNewScreen(),
  ),
),
```

**Étape 3** — Ajouter la méthode dans `lib/core/extensions/navigation_extension.dart` :

```dart
void goMyNewScreen() => go(AppRoutes.myNewScreen);
```

### 5.3 Transitions disponibles

```dart
AppTransitions.fade(context: context, state: state, child: widget)         // ← onglets
AppTransitions.slide(context: context, state: state, child: widget)        // ← latéral
AppTransitions.fadeSlide(context: context, state: state, child: widget)    // ← contenu
AppTransitions.fadeScale(context: context, state: state, child: widget)    // ← modals
AppTransitions.pushedScreen(context: context, state: state, child: widget) // ← détails
AppTransitions.none(context: context, state: state, child: widget)         // ← instantané
```

**Convention :**
- Tabs du shell → `fade`
- Écrans de détail (push) → `pushedScreen`
- Dialogs custom / modals → `fadeScale`

### 5.4 Navigation depuis l'extérieur du widget tree

Pour naviguer depuis un handler de notification ou un callback background :

```dart
import 'package:second_life/core/routing/app_navigator_key.dart';

AppNavigatorKey.instance.currentState?.context.go(AppRoutes.home);
```

---

## 6. State management — Riverpod

### 6.1 Règles de base

- Toujours utiliser l'annotation `@riverpod` et laisser `build_runner` générer le code.
- Ne jamais créer de provider manuellement (`Provider(...)` en dur).
- Les providers `keepAlive: true` sont pour les services qui vivent toute la session (locale, storage).
- Les providers de feature sont éphémères par défaut.

### 6.2 Providers partagés disponibles

```dart
// Stockage local
final prefs   = ref.watch(sharedPreferencesProvider);    // SharedPreferences brut
final storage = ref.watch(localStorageServiceProvider);  // abstraction

// Notifications
final notif   = ref.watch(notificationServiceProvider);

// Thème
final themeMode  = ref.watch(appThemeModeProvider);
final lightTheme = ref.watch(lightThemeProvider);
final darkTheme  = ref.watch(darkThemeProvider);

// Locale
final locale = ref.watch(appLocaleProvider);
```

### 6.3 Créer un provider dans une feature

```dart
// features/scan/presentation/providers/scan_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_provider.g.dart';

@riverpod
class ScanResult extends _$ScanResult {
  @override
  AsyncValue<ScannedItem?> build() => const AsyncData(null);

  Future<void> scan(String qrCode) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _parseQrCode(qrCode));
  }
}
```

Puis lancer `dart run build_runner build --delete-conflicting-outputs`.

---

## 7. Thème & mode sombre

### 7.1 Changer le thème

```dart
// Basculer entre light/dark
ref.read(appThemeModeProvider.notifier).toggleTheme();

// Forcer un mode
ref.read(appThemeModeProvider.notifier).theme = ThemeMode.dark;
ref.read(appThemeModeProvider.notifier).theme = ThemeMode.light;
ref.read(appThemeModeProvider.notifier).theme = ThemeMode.system;
```

### 7.2 Mode dyslexie (OpenDyslexic)

Le projet inclut la police `OpenDyslexic` et `AppTextStyles.toDyslexicTheme()` pour transformer n'importe quel `TextTheme`. Pour l'activer, il suffit de créer un provider qui observe une préférence utilisateur et appliquer `toDyslexicTheme()` sur le `TextTheme` courant.

```dart
// Exemple : transformer un style isolé
final dyslexicStyle = AppTextStyles.toDyslexic(context.textTheme.bodyLarge!);
```

---

## 8. Localisation (i18n)

L'app supporte le **français** (langue par défaut) et l'**anglais**.

### 8.1 Accéder aux chaînes traduites

```dart
// Via extension BuildContext
context.l10n.commonOk
context.l10n.errorGeneric

// Exemple dans un widget
Text(context.l10n.welcomeTitle)
```

### 8.2 Ajouter une traduction

1. Ajouter la clé dans `lib/l10n/app_fr.arb` :

```json
{
  "myNewKey": "Texte en français",
  "@myNewKey": { "description": "Description de la clé" }
}
```

2. Ajouter la clé dans `lib/l10n/app_en.arb` :

```json
{
  "myNewKey": "Text in English"
}
```

3. Relancer `flutter pub get` — le code est généré automatiquement (grâce à `generate: true` dans `pubspec.yaml`).

### 8.3 Changer la langue dynamiquement

```dart
// Passer en anglais
await ref.read(appLocaleProvider.notifier).setLocale(const Locale('en'));

// Revenir en français
await ref.read(appLocaleProvider.notifier).setLocale(const Locale('fr'));
```

La langue est persistée dans `SharedPreferences` (clé `AppKeys.locale`) et restaurée au prochain lancement.

---

## 9. Services partagés

### 9.1 `NotificationService` — notifications locales

```dart
final notif = ref.watch(notificationServiceProvider);

// Demander la permission (à faire au bon moment UX, pas au démarrage)
final granted = await notif.requestPermission();

// Notification immédiate
await notif.show(
  id: NotificationId.welcome,
  title: 'Bienvenue !',
  body: 'Votre compte est prêt.',
  channelId: NotificationChannel.generalId,
);

// Notification planifiée (respecte le fuseau horaire local et DST)
await notif.schedule(
  id: NotificationId.forReminder(entityId),
  title: 'Rappel',
  body: 'Il est temps de déposer vos objets.',
  scheduledDate: DateTime.now().add(Duration(hours: 2)),
  channelId: NotificationChannel.remindersId,
);

// Annuler
await notif.cancel(NotificationId.welcome);
await notif.cancelAll();
```

**Canaux disponibles :**

| Constante | Importance | Usage |
|---|---|---|
| `NotificationChannel.generalId` | Default | Informations générales |
| `NotificationChannel.remindersId` | High | Rappels planifiés |
| `NotificationChannel.alertsId` | Max | Alertes critiques |
| `NotificationChannel.processingId` | Low | Fin de traitement différé |

**Payload de navigation :** Pour naviguer vers un écran au tap d'une notification, encoder la route dans le payload :

```dart
final payload = NotificationPayload(route: AppRoutes.home);

await notif.show(
  id: 1,
  title: 'Traitement terminé',
  body: 'Vos objets ont été analysés.',
  payload: payload,
);
```

L'app décode automatiquement le payload et navigue vers la route encodée, que l'app soit en avant-plan, en arrière-plan, ou terminée.

### 9.2 Stockage local (`SharedPreferences`)

```dart
// Via SharedPreferences brut (pour les cas simples)
final prefs = ref.watch(sharedPreferencesProvider);
prefs.setString(AppKeys.locale, 'fr');
prefs.getString(AppKeys.locale);

// Via l'abstraction StorageRepository
final storage = ref.watch(localStorageServiceProvider);
await storage.write(AppKeys.locale, 'fr');
final lang = await storage.read(AppKeys.locale);
await storage.delete(AppKeys.locale);
await storage.clear();
```

**Clés disponibles (`lib/core/constants/app_keys.dart`) :**

```dart
AppKeys.locale       // préférence de langue
// (ajouter les clés au fur et à mesure des features)
```

---

## 10. Extensions disponibles

### 10.1 `BuildContext` extensions

```dart
// Thème
context.theme                  // ThemeData
context.colorScheme            // ColorScheme
context.textTheme              // TextTheme
context.isDarkMode             // bool
context.scaffoldBackgroundColor

// Localisation
context.l10n                   // AppLocalizations

// Dimensions
context.screenSize             // Size
context.screenWidth            // double
context.screenHeight           // double
context.isMobile               // bool (< 600 px)
context.isTablet               // bool (600–1200 px)
context.isDesktop              // bool (> 1200 px)
context.isPortrait
context.isLandscape

// SafeArea
context.padding                // EdgeInsets (insets système)
context.viewInsets             // (clavier, etc.)

// Navigation
context.pop()
context.canPop                 // bool

// Retour utilisateur
context.showSnackBar('Message')
await context.showConfirmDialog(title: 'Supprimer ?', content: 'Irréversible.')
await context.showInfoDialog(title: 'Info', content: '...')
```

### 10.2 `String` extensions

```dart
// Validation
'test@mail.com'.isEmail        // true
'http://...'.isUrl             // true
'0612'.isPhone                 // true
'123'.isNumeric                // true
''.isBlank                     // true
'hello'.isNotBlank             // true

// Transformation
'hello world'.capitalize       // 'Hello world'
'hello world'.capitalizeWords  // 'Hello World'
'hello world'.camelCase        // 'helloWorld'
'helloWorld'.snakeCase         // 'hello_world'

// Troncature
'Texte long'.truncate(5)       // 'Te...'
'Un deux trois'.truncateWords(2) // 'Un deux...'

// Masquage
'test@mail.com'.maskEmail()    // 't**t@mail.com'
'0612345678'.maskPhone()       // '******5678'

// Parsing
'42'.toInt()                   // 42
'3.14'.toDouble()              // 3.14
'2024-01-01'.toDateTime()      // DateTime

// Encodage
'hello'.toBase64()
'aGVsbG8='.fromBase64()
'#007A3D'.toColor()            // Color
```

### 10.3 Extensions nullable String

```dart
String? val;
val.isNullOrEmpty              // true si null ou ''
val.isNullOrBlank              // true si null ou espaces seulement
val.orEmpty                    // '' si null
val.orDefault('—')             // '—' si null
```

---

## 11. Logger

Toujours utiliser `Log` — ne jamais utiliser `print()`.

```dart
import 'package:second_life/core/configs/logger.dart';

// Niveaux de base
Log.d('Debug message')                          // 🔍
Log.i('Info message')                           // ℹ️
Log.w('Warning message')                        // ⚠️
Log.e('Error message', error: e, stackTrace: st) // ❌
Log.s('Success message')                        // ✅

// Avec tag (contexte)
Log.i('Provider initialisé', tag: 'AppConfig')

// Logs avancés (AppLogger)
AppLogger.json(myMap)
AppLogger.list(['item1', 'item2'], title: 'Résultats')
AppLogger.method('fetchItems', params: {'page': 1})
AppLogger.route('/home')
AppLogger.apiRequest(method: 'GET', url: 'https://...')
AppLogger.apiResponse(statusCode: 200, url: 'https://...', body: response)

// Performance
final timer = AppLogger.startTimer('Chargement données');
// ... code ...
AppLogger.stopTimer('Chargement données', timer);

// Section visuelle
AppLogger.section('INITIALISATION', () {
  Log.i('Étape 1');
  Log.i('Étape 2');
});
```

**Configuration (faite dans `main()`) :**
- En mode développement : tous les niveaux sont affichés (`LogLevel.debug`).
- En production : seulement `warning` et au-dessus.

---

## 12. Code generation

Le projet utilise la génération de code pour **Riverpod** (providers) et **Flutter** (localisation).

```bash
# Génération unique
dart run build_runner build --delete-conflicting-outputs

# Mode watch (génère à chaque sauvegarde — pratique en dev)
dart run build_runner watch --delete-conflicting-outputs
```

**Fichiers générés (ne jamais éditer manuellement) :**
- `*.g.dart` — providers Riverpod
- `lib/l10n/app_localizations*.dart` — classes de localisation

**Quand relancer :**
- Après avoir ajouté ou modifié une annotation `@riverpod`
- Après `flutter pub get` si une dépendance codegen a changé

---

## 13. Conventions & règles à respecter

### Structure des features

Chaque feature suit la même structure :

```
features/
└── <feature_name>/
    ├── data/
    │   ├── datasources/    → Appels API, requêtes DB
    │   ├── models/         → DTOs, entités
    │   └── repositories/   → Abstraction des datasources
    └── presentation/
        ├── pages/          → Écrans (un fichier par écran)
        ├── providers/      → Providers Riverpod de la feature
        └── widgets/        → Widgets propres à cette feature
```

### Tableau des règles

| Règle | Raison |
|---|---|
| `AppScaffold` au lieu de `Scaffold` | Gestion status bar, SafeArea, padding homogène |
| `context.colorScheme.*` au lieu de `AppColors.*` | Respect du thème light/dark |
| `AppSpacing.*` au lieu de valeurs en dur | Cohérence de la grille 4 px |
| `context.textTheme.*` au lieu de `TextStyle()` custom | Cohérence typographique |
| Extensions de navigation au lieu de `go(AppRoutes.xxx)` en dur | Centralisation, pas de strings en dur |
| `LucideIcons.*` au lieu de `Icons.*` | Cohérence visuelle, set d'icônes unique dans l'app |
| `Log.*` au lieu de `print()` | Logs filtrables par niveau, visibles dans DevTools |
| `@riverpod` + `build_runner` | Pas de providers manuels |
| Clés de stockage via `AppKeys.*` | Pas de strings magiques dans les prefs |
| Pas d'import croisé entre features | Isolation des modules |

### Checklist avant de soumettre une PR

- [ ] Aucun `print()` dans le code
- [ ] Aucun `Scaffold` nu (utiliser `AppScaffold`)
- [ ] Aucune couleur en dur (`Color(0xFF...)` ou `AppColors.*` dans les widgets)
- [ ] Aucune valeur d'espacement en dur (`SizedBox(height: 16)` → `AppSpacing.gapVLg`)
- [ ] Les fichiers `*.g.dart` sont à jour (`build_runner` lancé)
- [ ] Les routes passent par les extensions de navigation
- [ ] Les icônes utilisent `LucideIcons.*` (pas `Icons.*`)
- [ ] Les logs utilisent `Log.*`
- [ ] Les nouvelles clés de stockage sont ajoutées dans `AppKeys`
- [ ] Les nouvelles chaînes UI sont dans les fichiers ARB (`app_fr.arb`, `app_en.arb`)

---

*Dernière mise à jour : septembre 2026*
