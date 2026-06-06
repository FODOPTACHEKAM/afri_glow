# AfriGlow — Project Documentation

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Team](#2-team)
3. [Architecture](#3-architecture)
4. [Tech Stack & Dependencies](#4-tech-stack--dependencies)
5. [Project Structure](#5-project-structure)
6. [Features](#6-features)
7. [Screens & Navigation](#7-screens--navigation)
8. [State Management](#8-state-management)
9. [Backend & Firebase](#9-backend--firebase)
10. [Design System](#10-design-system)
11. [Data Layer](#11-data-layer)
12. [Services](#12-services)
13. [Responsive Design](#13-responsive-design)
14. [Dark Mode](#14-dark-mode)
15. [Setup & Running](#15-setup--running)

---

## 1. Project Overview

**AfriGlow** is an AI-powered skincare mobile application built with Flutter, designed specifically for people of African descent. It provides personalised skincare guidance rooted in 12 traditional African ingredients, backed by scientific evidence and adapted to local climate conditions.

The app combines a camera-based AI skin scanner, a daily routine tracker, an ingredient library, a chatbot, and a product marketplace into a single cohesive experience.

**App name:** AfriGlow  
**Package name:** `flutter_application_skin_wise`  
**Version:** 1.0.0+1  
**Platform targets:** Android, iOS, Web, Windows, macOS, Linux

---

## 2. Team

| Name | Role |
|------|------|
| Fodop Tachekam Ivan Jordan | Scrum Master · DevOps |
| Member 2 | TBD |
| Member 3 | TBD |
| Member 4 | TBD |
| Member 5 | TBD |

---

## 3. Architecture

AfriGlow follows a layered architecture with clear separation of concerns:

```
┌────────────────────────────────────────────────────┐
│                   UI Layer                         │
│           screens/  ·  widgets/                    │
├────────────────────────────────────────────────────┤
│              State Management Layer                │
│        providers/  (Provider package)              │
├────────────────────────────────────────────────────┤
│                 Service Layer                      │
│    auth_service  ·  firestore_service              │
│    notification_service  ·  location_service       │
├────────────────────────────────────────────────────┤
│              Data / Domain Layer                   │
│    models/  ·  data/  (static ingredient data)     │
├────────────────────────────────────────────────────┤
│                Backend (Firebase)                  │
│    Firebase Auth  ·  Cloud Firestore               │
└────────────────────────────────────────────────────┘
```

**Pattern:** Provider + Service Locator  
**State management:** `provider` package with `ChangeNotifier`  
**Routing:** Imperative (`Navigator.push` / `pushAndRemoveUntil`) with `PageRouteBuilder` fade transitions

---

## 4. Tech Stack & Dependencies

### Framework
| Item | Version |
|------|---------|
| Flutter SDK | ≥ 3.0 |
| Dart | ≥ 3.0 |

### Core UI
| Package | Purpose |
|---------|---------|
| `google_fonts ^6.2.1` | Poppins typography throughout the app |
| `flutter_svg ^2.0.10` | Google logo and SVG assets |
| `smooth_page_indicator ^1.1.0` | Onboarding step dots |
| `percent_indicator ^4.2.3` | Skin score gauges and progress rings |
| `fl_chart ^0.69.0` | Dashboard analytics charts |

### State & Data
| Package | Purpose |
|---------|---------|
| `provider ^6.1.2` | App-wide state management |
| `http ^1.2.0` | HTTP calls (Nominatim reverse geocoding) |

### Firebase
| Package | Purpose |
|---------|---------|
| `firebase_core ^3.6.0` | Firebase initialisation |
| `firebase_auth ^5.3.1` | Email + Google authentication |
| `cloud_firestore ^5.4.4` | User profiles, analyses, routine logs |
| `google_sign_in ^6.2.1` | Google OAuth flow |

### Device Features
| Package | Purpose |
|---------|---------|
| `image_picker ^1.1.2` | Camera & gallery for profile photo and skin scan |
| `geolocator ^13.0.0` | GPS coordinates for climate detection |
| `flutter_local_notifications ^18.0.0` | Birthday reminder notifications |
| `timezone ^0.9.4` | Timezone-aware notification scheduling |
| `url_launcher ^6.3.1` | Deep links and external URLs |

---

## 5. Project Structure

```
lib/
├── main.dart                    # Entry point — Firebase init, Provider setup
├── app.dart                     # MaterialApp, theme binding, AuthGate
├── firebase_options.dart        # Firebase platform configuration
│
├── theme/
│   ├── app_colors.dart          # Brand colour constants
│   └── app_theme.dart           # Light & dark Material 3 themes
│
├── models/
│   ├── user_profile.dart        # Demographics, skin type, climate, goals
│   ├── skin_analysis.dart       # AI scan result (score, concerns, recommendations)
│   ├── product.dart             # Skincare product
│   ├── ingredient.dart          # African ingredient with metadata
│   ├── routine.dart             # Routine + steps
│   ├── chat_message.dart        # AI chatbot message
│   └── community_post.dart      # Community feed post
│
├── providers/
│   ├── app_provider.dart        # Main app state (profile, analysis, routines, chat)
│   └── auth_provider.dart       # Firebase auth state
│
├── services/
│   ├── auth_service.dart        # Firebase Auth wrapper
│   ├── firestore_service.dart   # Firestore read/write operations
│   ├── notification_service.dart# Local birthday notifications
│   └── location_service.dart    # GPS + climate zone detection
│
├── data/
│   ├── ingredients_data.dart    # 12 African ingredient definitions
│   ├── products_data.dart       # Sample product catalogue
│   ├── routines_data.dart       # Pre-defined AM/PM routines
│   └── community_data.dart      # Sample community posts
│
├── screens/
│   ├── splash_screen.dart
│   ├── main_scaffold.dart       # Bottom nav shell (5 tabs)
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── forgot_password_screen.dart
│   │   └── auth_widgets.dart    # Shared form widgets
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── ingredients/
│   │   ├── ingredient_list_screen.dart
│   │   └── ingredient_detail_screen.dart
│   ├── scanner/
│   │   ├── skin_scanner_screen.dart
│   │   └── skin_result_screen.dart
│   ├── routine/
│   │   └── routine_screen.dart
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   └── about_screen.dart
│   ├── marketplace/
│   │   ├── marketplace_screen.dart
│   │   └── product_detail_screen.dart
│   ├── community/
│   │   └── community_screen.dart
│   ├── dashboard/
│   │   └── dashboard_screen.dart
│   ├── chat/
│   │   └── chat_screen.dart
│   └── quiz/
│       └── skin_quiz_screen.dart
│
└── utils/
    ├── app_images.dart          # Centralised image URL registry
    └── responsive.dart          # Screen size utilities & scaled sizing helpers
```

---

## 6. Features

### Authentication
- Email / password sign-up and sign-in
- Google OAuth sign-in
- Password reset via email link
- Persistent session (Firebase Auth state listener)
- User-friendly error messages mapped from Firebase error codes

### Onboarding Quiz (5 Steps)
1. Full name
2. Date of birth
3. Skin type (oily, dry, combination, sensitive)
4. Skin concerns (multi-select: dark spots, acne, hyperpigmentation, etc.)
5. Location & climate zone, plus daily hydration and sleep goals

### AI Skin Scanner
- Camera or gallery image input (`image_picker`)
- Skin score (0–100) with label (e.g. "Great", "Fair")
- Concern breakdown (percentages per concern)
- Skin tone detection
- Personalised ingredient and product recommendations

### Ingredient Library
- 12 curated African skincare ingredients:
  Shea Butter, Baobab Oil, Aloe Vera, Moringa, Black Seed, Coconut Oil,
  Hibiscus, Argan Oil, Marula, African Black Soap, Rooibos, Neem
- For each ingredient: benefits, scientific evidence links, traditional uses, common products, suitable skin types, target concerns
- Search and filter by skin type or concern
- Unique gradient colour per ingredient

### Daily Routine Tracker
- AM and PM skincare step checklists
- Water intake counter (glasses per day)
- Sleep hours tracking
- Routine streak counter (consecutive days completed)
- Logs synced to Firestore per calendar date

### AI Skincare Chatbot
- Context-aware responses about African skin concerns:
  dark spots, oily skin, dry Harmattan season, acne, sensitive skin, anti-aging, climate tips
- Quick-reply chips for common questions

### Product Marketplace
- Product catalogue with brand, price, rating, and key ingredients
- Favourites / wishlist toggle (synced to Firestore)
- Product detail view with reviews and ingredient breakdown

### Analytics Dashboard
- Rolling 14-session skin score history chart
- Routine completion streak
- Water intake logs

### Community Feed
- User posts and skincare tips (framework in place)

### Profile Management
- Profile photo (camera or gallery, stored locally)
- Edit all onboarding data in-app
- Light / dark theme toggle
- Logout

### About Us Page
- Meet the 5-person team with photos, roles, and bios
- Bilingual EN / FR toggle with animated content switch

### Notifications
- Annual birthday reminder (9 AM local time, Android)

### Location & Climate
- GPS detection with 15-second timeout
- Reverse geocoding via Nominatim (OpenStreetMap, no API key required)
- Climate zone classification: Harmattan · Tropical · Coastal · Savanna
- Recommendations adapt to detected climate zone

---

## 7. Screens & Navigation

### App Entry Flow

```
Launch
  └─ SplashScreen (1.2 s animation)
       ├─ No Firebase user   → LoginScreen
       ├─ User, not onboarded → OnboardingScreen
       └─ User, onboarded    → MainScaffold
```

### Authentication Screens

| Screen | Route trigger |
|--------|--------------|
| `LoginScreen` | Default unauthenticated route |
| `RegisterScreen` | "Create Account" link on Login |
| `ForgotPasswordScreen` | "Forgot Password?" link on Login |

### Main Navigation (Bottom Tab Bar)

| Tab | Icon | Screen |
|-----|------|--------|
| Home | `home_rounded` | `HomeScreen` |
| Ingredients | `eco_rounded` | `IngredientListScreen` |
| Scan | `document_scanner_rounded` | `SkinScannerScreen` |
| Routine | `calendar_today_rounded` | `RoutineScreen` |
| Profile | `person_rounded` | `ProfileScreen` |

### Secondary Screens (pushed from tabs)

| From | To | Trigger |
|------|----|---------|
| HomeScreen | ChatScreen | AI Chat shortcut |
| HomeScreen | DashboardScreen | "View All" on analytics |
| HomeScreen | MarketplaceScreen | Marketplace shortcut |
| IngredientListScreen | IngredientDetailScreen | Tap ingredient card |
| SkinScannerScreen | SkinResultScreen | Scan complete |
| ProfileScreen | AboutScreen | "About Us" tile |
| MarketplaceScreen | ProductDetailScreen | Tap product card |

---

## 8. State Management

Two `ChangeNotifier` providers are registered at the root in `main.dart`:

### `AuthProvider`

| Property | Type | Description |
|----------|------|-------------|
| `user` | `User?` | Current Firebase user |
| `isLoading` | `bool` | Async operation in progress |
| `error` | `String?` | User-friendly error message |

Methods: `signIn()`, `signUp()`, `signInWithGoogle()`, `signOut()`, `resetPassword()`, `clearError()`

### `AppProvider`

| Property | Type | Description |
|----------|------|-------------|
| `themeMode` | `ThemeMode` | Light / dark / system |
| `user` | `UserProfile?` | Onboarded user profile |
| `latestAnalysis` | `SkinAnalysis?` | Most recent skin scan |
| `skinScoreHistory` | `List<double>` | Rolling 14-session history |
| `messages` | `List<ChatMessage>` | Chatbot conversation |
| `favorites` | `Set<String>` | Favourite product IDs |
| `routineChecks` | `Map<String, bool>` | Today's step completion |
| `waterGlasses` | `int` | Today's water count |
| `streakDays` | `int` | Consecutive routine days |
| `imagePath` | `String?` | Local profile photo path |
| `navIndex` | `int` | Active bottom tab |

Key methods: `loadFromMap()`, `saveProfile()`, `recordAnalysis()`, `sendMessage()`, `toggleFavorite()`, `checkStep()`, `incrementWater()`, `toggleTheme()`

---

## 9. Backend & Firebase

### Firestore Schema

```
users/{uid}
  ├── name              String
  ├── email             String
  ├── dateOfBirth       String   (YYYY-MM-DD)
  ├── skinType          String   (oily | dry | combination | sensitive)
  ├── skinConcerns      Array<String>
  ├── location          String
  ├── climate           String
  ├── waterIntake       Number
  ├── sleepHours        Number
  ├── isOnboarded       Boolean
  ├── latestSkinScore   Number
  ├── favorites         Array<String>  (product IDs)
  └── updatedAt         Timestamp

  analyses/{id}
    ├── skinScore         Number   (0–100)
    ├── concerns          Map<String, double>
    ├── skinTone          String
    ├── recommendations   Array<String>
    ├── suggestedIngredients Array<String>
    └── analyzedAt        Timestamp

  routine_logs/{YYYY-MM-DD}
    ├── checks            Map<String, bool>
    ├── waterGlasses      Number
    └── updatedAt         Timestamp
```

### Firestore Security Rules

Rules are defined in `firestore.rules` at the project root and deployed via `firebase.json`.

### Authentication

Firebase Authentication handles:
- Email / password (with `createUserWithEmailAndPassword` + `signInWithEmailAndPassword`)
- Google OAuth (`google_sign_in` plugin → Firebase credential)
- Password reset (`sendPasswordResetEmail`)
- Display name update after registration

---

## 10. Design System

### Brand Palette (`app_colors.dart`)

| Name | Hex | Use |
|------|-----|-----|
| `gold` | `#D4A14A` | Primary action colour, highlights |
| `accentGold` | `#E8C07D` | Lighter gold for secondary text |
| `cocoa` | `#5A2D16` | Deep brown backgrounds |
| `bronze` | `#A8652A` | Warm accent, icon colours |
| `espresso` | `#2E1A0F` | Darkest text (light mode) |
| `cream` | `#F4EEE7` | Soft warm white |
| `background` | `#FAF6F1` | Light mode screen background |
| `olive` | `#6B6A32` | Botanical accents |

**Dark Mode Tokens:**

| Name | Use |
|------|-----|
| `darkBg` | Screen background |
| `darkSurface` | Card / modal surface |
| `darkCard` | Input fields, inner cards |
| `darkDivider` | Borders and separators |

**Status Colours:**

| Name | Use |
|------|-----|
| `errorRed` | Validation errors, banners |
| `successGreen` | Success states |
| `warningAmber` | Warnings |

**Ingredient Gradients:** Each of the 12 ingredients has a unique `List<Color>` pair for card backgrounds.

### Typography

All text uses **Poppins** (Google Fonts). Font sizes are scaled via the `sp()` responsive helper — they adapt to screen density and tablet layouts.

### Component Style

- Border radius: `12` for inputs, `14` for buttons, `16–20` for cards, `32` for bottom sheet overlays
- Elevation: `0` (flat design) — depth is created via `BoxShadow` and background contrast
- Buttons: `ElevatedButton` (gold fill) for primary, `OutlinedButton` for Google sign-in, `TextButton` for links
- Input fields: Filled with subtle border; gold focused border; `errorRed` error border

---

## 11. Data Layer

Static data is defined in `lib/data/` and loaded into `AppProvider` at startup:

### `ingredients_data.dart`
Complete metadata for all 12 ingredients including:
- Scientific name, origin country, emoji
- `benefits[]` — skin benefits list
- `evidenceLinks[]` — links to research papers
- `traditionalUses[]` — historical / cultural uses
- `commonProducts[]` — example product names
- `skinTypes[]` — compatible skin types
- `concerns[]` — target skin concerns
- `gradientColors[]` — unique UI gradient pair

### `products_data.dart`
Sample product catalogue entries with brand, price, category, rating, and ingredient list.

### `routines_data.dart`
Pre-defined AM and PM skincare routines per skin type. Each routine contains ordered `RoutineStep` objects with title, instructions, recommended ingredient, duration, and emoji.

---

## 12. Services

### `AuthService`

Thin wrapper around `FirebaseAuth` and `GoogleSignIn`. All methods return typed results; errors are caught and rethrown as friendly strings by `AuthProvider`.

### `FirestoreService`

All Firestore operations are static methods for simplicity:

| Method | Description |
|--------|-------------|
| `saveUserProfile(uid, data)` | Write / merge user document |
| `getUserProfile(uid)` | Read user document as `Map` |
| `setOnboarded(uid)` | Set `isOnboarded: true` |
| `saveSkinAnalysis(uid, analysis)` | Add to `analyses` subcollection |
| `getSkinAnalyses(uid)` | Fetch last 14 analyses |
| `saveRoutineLog(uid, date, data)` | Write today's routine log |
| `getTodayRoutineLog(uid)` | Read today's routine log |
| `saveFavorites(uid, ids)` | Overwrite favourites list |
| `getFavorites(uid)` | Fetch favourites list |

### `NotificationService`

- Uses `flutter_local_notifications` with an Android-specific channel (`afriglow_birthday`)
- Schedules a yearly notification at 9:00 AM on the user's birthday using `timezone` for correct local time

### `LocationService`

1. Requests GPS permission and reads coordinates (`geolocator`)
2. Calls Nominatim reverse-geocode endpoint with coordinates
3. Maps `lat/lon` to one of four climate zones:
   - **Harmattan** — Sahel / Sahara (lat > 10°N, lon 10°W–40°E)
   - **Tropical** — Equatorial belt (lat −5° to 10°)
   - **Coastal** — Transition zones
   - **Savanna** — Southern Africa (lat < −5°)
4. Returns a `LocationResult` with city, country, climate, and raw coordinates

---

## 13. Responsive Design

`lib/utils/responsive.dart` provides a `Responsive` helper class constructed from `BuildContext`:

| Helper | Description |
|--------|-------------|
| `isTablet` | Screen width ≥ 600 px |
| `isLargePhone` | Screen width ≥ 400 px |
| `isSmallPhone` | Screen width < 360 px |
| `sp(base)` | Scaled font size |
| `hp(base)` | Horizontal padding |
| `vp(base)` | Vertical padding |
| `iconSize(base)` | Scaled icon size |
| `gridCols` | 2 (phone) / 3 (tablet) |
| `cardAspect` | Aspect ratio for grid cards |
| `pctH(pct)` | % of screen height |
| `pctW(pct)` | % of screen width |

All font sizes in quiz and scanner screens use `sp()` so they scale correctly on all devices.

---

## 14. Dark Mode

Dark mode is supported throughout the app using Material 3 theming:

- Theme toggled by the user from `ProfileScreen` and stored in `AppProvider.themeMode`
- `app_theme.dart` defines separate `ThemeData` for light and dark
- Individual widgets detect the current brightness with:

```dart
final isDark = Theme.of(context).brightness == Brightness.dark;
```

- Text colours use `Theme.of(context).colorScheme.onSurface` to automatically adapt
- Container colours switch between `AppColors.darkSurface` / `AppColors.darkCard` in dark mode and `Colors.white` / `AppColors.background` in light mode
- All auth screens (Login, Register, Forgot Password) and shared widgets (`AuthField`, `AuthLabel`, `AuthGoogleButton`, etc.) are fully dark-mode-aware

---

## 15. Setup & Running

### Prerequisites

- Flutter SDK ≥ 3.0 installed and on `PATH`
- Android Studio or VS Code with Flutter extension
- A Firebase project with:
  - Authentication (Email/Password + Google provider) enabled
  - Cloud Firestore database created
  - `google-services.json` placed in `android/app/`
  - `GoogleService-Info.plist` placed in `ios/Runner/`

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/FODOPTACHEKAM/afri_glow.git
cd afri_glow

# 2. Install dependencies
flutter pub get

# 3. Run on a connected device or emulator
flutter run

# 4. Build release APK (Android)
flutter build apk --release

# 5. Build release AAB (Android Play Store)
flutter build appbundle --release
```

### Firebase Configuration

The file `lib/firebase_options.dart` contains platform-specific Firebase config generated by the FlutterFire CLI. To regenerate for a different Firebase project:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### Adding Team Photos

Place member photos in `assets/images/team/` and name them to match the `photoAsset` field in `lib/screens/profile/about_screen.dart`:

```
assets/images/team/ivan.jpg
assets/images/team/member2.jpg
assets/images/team/member3.jpg
assets/images/team/member4.jpg
assets/images/team/member5.jpg
```

If a photo file is missing, the app automatically falls back to an initials avatar.

---

*Document generated for AfriGlow v1.0.0 — 2026*
