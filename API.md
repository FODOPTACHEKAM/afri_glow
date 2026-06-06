# AfriGlow — API Reference

This document describes every external API and platform service used by the AfriGlow Flutter application, including endpoints, request/response formats, authentication, and the exact code that calls each service.

---

## Table of Contents

1. [Firebase Authentication](#1-firebase-authentication)
2. [Cloud Firestore](#2-cloud-firestore)
3. [Google Sign-In (OAuth 2.0)](#3-google-sign-in-oauth-20)
4. [Nominatim Reverse Geocoding](#4-nominatim-reverse-geocoding)
5. [Geolocator (Device GPS)](#5-geolocator-device-gps)
6. [Flutter Local Notifications](#6-flutter-local-notifications)
7. [Unsplash CDN](#7-unsplash-cdn)
8. [Wikimedia Commons CDN](#8-wikimedia-commons-cdn)
9. [Google Fonts CDN](#9-google-fonts-cdn)
10. [API Summary Table](#10-api-summary-table)

---

## 1. Firebase Authentication

**Provider:** Google Firebase  
**Package:** `firebase_auth: ^5.3.1`  
**Base URL (managed by SDK):** `https://identitytoolkit.googleapis.com/v1/`  
**Authentication:** Firebase project API key (embedded in `firebase_options.dart`)  
**Source file:** `lib/services/auth_service.dart`

Firebase Authentication is used for all user identity operations. The Flutter SDK wraps the REST calls; the app never calls the REST endpoints directly.

---

### 1.1 Email / Password Sign-Up

**SDK method:** `FirebaseAuth.createUserWithEmailAndPassword()`

```dart
static Future<UserCredential> signUpWithEmail(
    String email, String password) async {
  return await _auth.createUserWithEmailAndPassword(
      email: email, password: password);
}
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `email` | `String` | User's email address |
| `password` | `String` | Plain-text password (min 6 characters, enforced client-side) |

**Returns:** `UserCredential` containing a `User` object with `uid`, `email`, `displayName`.

**Error codes handled:**

| Firebase code | User message |
|---------------|-------------|
| `email-already-in-use` | That email is already registered. Try signing in. |
| `invalid-email` | Please enter a valid email address. |
| `weak-password` | Password should be at least 6 characters. |
| `network-request-failed` | No internet connection. Please try again. |

---

### 1.2 Email / Password Sign-In

**SDK method:** `FirebaseAuth.signInWithEmailAndPassword()`

```dart
static Future<UserCredential> signInWithEmail(
    String email, String password) async {
  return await _auth.signInWithEmailAndPassword(
      email: email, password: password);
}
```

**Error codes handled:**

| Firebase code | User message |
|---------------|-------------|
| `user-not-found` | No account found for that email. |
| `wrong-password` | Incorrect password. Please try again. |
| `invalid-credential` | Invalid email or password. |
| `too-many-requests` | Too many failed attempts. Please wait before trying again. |
| `user-disabled` | This account has been disabled. Contact support. |

---

### 1.3 Password Reset Email

**SDK method:** `FirebaseAuth.sendPasswordResetEmail()`

```dart
static Future<void> resetPassword(String email) async {
  await _auth.sendPasswordResetEmail(email: email);
}
```

Sends a password reset link to the provided email. The link is valid for 1 hour (Firebase default). No response body — throws on failure.

---

### 1.4 Update Display Name

**SDK method:** `FirebaseAuth.currentUser.updateDisplayName()`

```dart
static Future<void> updateDisplayName(String name) async {
  await _auth.currentUser?.updateDisplayName(name);
}
```

Called immediately after `signUpWithEmail` to attach the user's full name to their Firebase identity.

---

### 1.5 Sign Out

**SDK method:** `FirebaseAuth.signOut()`

```dart
static Future<void> signOut() async {
  await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
}
```

Both Firebase Auth and Google Sign-In sessions are cleared in parallel.

---

### 1.6 Auth State Stream

**SDK method:** `FirebaseAuth.authStateChanges()`

```dart
static Stream<User?> get authStateChanges => _auth.authStateChanges();
```

Emits `User?` whenever auth state changes (login / logout / token refresh). The `app.dart` `AuthGate` widget listens to this stream to route between `LoginScreen` and `MainScaffold`.

---

## 2. Cloud Firestore

**Provider:** Google Firebase  
**Package:** `cloud_firestore: ^5.4.4`  
**Base URL (managed by SDK):** `https://firestore.googleapis.com/v1/`  
**Authentication:** Firebase Auth token (automatically attached by SDK)  
**Source file:** `lib/services/firestore_service.dart`

---

### Database Schema

```
users/{uid}                       ← User profile document
  ├── name              String
  ├── email             String
  ├── dateOfBirth       String    (ISO 8601: "YYYY-MM-DDTHH:mm:ss.sss")
  ├── skinType          String    ("oily" | "dry" | "combination" | "sensitive")
  ├── skinConcerns      Array<String>
  ├── location          String    (e.g. "Yaoundé, Cameroon")
  ├── climate           String    ("harmattan" | "tropical" | "coastal" | "savanna")
  ├── waterIntake       Number    (glasses per day goal)
  ├── sleepHours        Number    (hours per night goal)
  ├── isOnboarded       Boolean
  ├── latestSkinScore   Number    (0–100)
  ├── favorites         Array<String>  (product IDs)
  └── updatedAt         Timestamp

  analyses/{auto-id}             ← One document per skin scan
    ├── skinScore         Number
    ├── concerns          Map<String, double>
    ├── skinTone          String
    ├── recommendations   Array<String>
    ├── suggestedIngredients Array<String>
    └── analyzedAt        Timestamp

  routine_logs/{YYYY-MM-DD}      ← One document per calendar day
    ├── checks            Map<String, bool>   (step-id → completed)
    ├── waterGlasses      Number
    ├── date              String
    └── updatedAt         Timestamp
```

---

### 2.1 Save User Profile

**Operation:** `set` with `merge: true`  
**Collection:** `users/{uid}`

```dart
static Future<void> saveUserProfile(
    String uid, UserProfile profile, String email) async {
  await _db.collection('users').doc(uid).set({
    'name': profile.name,
    'email': email,
    'dateOfBirth': profile.dateOfBirth.toIso8601String(),
    'skinType': profile.skinType,
    'skinConcerns': profile.skinConcerns,
    'location': profile.location,
    'climate': profile.climate,
    'waterIntake': profile.waterIntake,
    'sleepHours': profile.sleepHours,
    'isOnboarded': true,
    'updatedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}
```

`merge: true` means existing fields not in the payload are preserved. Called after the 5-step onboarding quiz completes, and again whenever the user edits their profile.

---

### 2.2 Get User Profile

**Operation:** `get`  
**Collection:** `users/{uid}`

```dart
static Future<Map<String, dynamic>?> getUserProfile(String uid) async {
  final doc = await _db.collection('users').doc(uid).get();
  return doc.exists ? doc.data() : null;
}
```

Returns `null` if the document does not exist (first-time user). Called on every login to decide whether to route to `OnboardingScreen` or `MainScaffold`.

---

### 2.3 Set Onboarded Flag

**Operation:** `set` with `merge: true`  
**Collection:** `users/{uid}`

```dart
static Future<void> setOnboarded(String uid) async {
  await _db.collection('users').doc(uid).set(
    {'isOnboarded': true, 'updatedAt': FieldValue.serverTimestamp()},
    SetOptions(merge: true),
  );
}
```

---

### 2.4 Save Skin Analysis

**Operation:** `add` (auto-ID) + `update`  
**Collections:** `users/{uid}/analyses` and `users/{uid}`

```dart
static Future<void> saveSkinAnalysis(
    String uid, SkinAnalysis analysis) async {
  await _db
      .collection('users').doc(uid)
      .collection('analyses')
      .add({
    'skinScore': analysis.skinScore,
    'concerns': analysis.concerns,
    'skinTone': analysis.skinTone,
    'recommendations': analysis.recommendations,
    'suggestedIngredients': analysis.suggestedIngredients,
    'analyzedAt': Timestamp.fromDate(analysis.analyzedAt),
  });
  await _db.collection('users').doc(uid).update({
    'latestSkinScore': analysis.skinScore,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}
```

Two writes happen sequentially: the analysis document is created in the subcollection, then `latestSkinScore` on the parent profile is updated.

---

### 2.5 Get Skin Analyses

**Operation:** `get` with `orderBy` + `limit`  
**Collection:** `users/{uid}/analyses`

```dart
static Future<List<Map<String, dynamic>>> getSkinAnalyses(
    String uid) async {
  final snap = await _db
      .collection('users').doc(uid)
      .collection('analyses')
      .orderBy('analyzedAt', descending: true)
      .limit(14)
      .get();
  return snap.docs.map((d) => d.data()).toList();
}
```

Returns the 14 most recent analyses, ordered newest-first. Used to populate the rolling skin-score chart in `DashboardScreen`.

---

### 2.6 Save Routine Log

**Operation:** `set` (overwrite)  
**Collection:** `users/{uid}/routine_logs/{YYYY-MM-DD}`

```dart
static Future<void> saveRoutineLog(
    String uid, Map<String, bool> checks, int waterGlasses) async {
  final date = _dateKey(DateTime.now()); // "2026-06-05"
  await _db
      .collection('users').doc(uid)
      .collection('routine_logs').doc(date)
      .set({
    'checks': checks,
    'waterGlasses': waterGlasses,
    'date': date,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}
```

Document ID is the ISO date string (`YYYY-MM-DD`), ensuring exactly one document per calendar day.

---

### 2.7 Get Today's Routine Log

**Operation:** `get`  
**Collection:** `users/{uid}/routine_logs/{today}`

```dart
static Future<Map<String, dynamic>?> getTodayRoutineLog(
    String uid) async {
  final date = _dateKey(DateTime.now());
  final doc = await _db
      .collection('users').doc(uid)
      .collection('routine_logs').doc(date)
      .get();
  return doc.exists ? doc.data() : null;
}
```

---

### 2.8 Save Favourites

**Operation:** `update`  
**Collection:** `users/{uid}`

```dart
static Future<void> saveFavorites(
    String uid, Set<String> favoriteIds) async {
  await _db.collection('users').doc(uid).update({
    'favorites': favoriteIds.toList(),
    'updatedAt': FieldValue.serverTimestamp(),
  });
}
```

---

### 2.9 Get Favourites

**Operation:** `get`  
**Collection:** `users/{uid}`

```dart
static Future<List<String>> getFavorites(String uid) async {
  final doc = await _db.collection('users').doc(uid).get();
  if (!doc.exists) return [];
  return List<String>.from(doc.data()?['favorites'] ?? []);
}
```

---

## 3. Google Sign-In (OAuth 2.0)

**Provider:** Google Identity  
**Package:** `google_sign_in: ^6.2.1`  
**OAuth 2.0 endpoint:** `https://accounts.google.com/o/oauth2/auth`  
**Source file:** `lib/services/auth_service.dart`

Google Sign-In is a two-step flow: the `google_sign_in` plugin handles the OAuth consent screen and token exchange; the resulting credential is then passed to Firebase Auth.

```dart
static Future<UserCredential?> signInWithGoogle() async {
  // Step 1 — Show Google account picker; returns null if user cancels
  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  if (googleUser == null) return null;

  // Step 2 — Get access token + ID token from Google
  final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

  // Step 3 — Exchange Google credential for Firebase UserCredential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  return await _auth.signInWithCredential(credential);
}
```

**Scopes requested:** Default (`email`, `profile`) — no additional scopes are requested.

**Tokens:**

| Token | Description |
|-------|-------------|
| `accessToken` | Short-lived Google API token (used to verify identity with Firebase) |
| `idToken` | JWT containing user's Google profile (email, name, photo URL) |

**On sign-out**, both sessions are cleared:

```dart
await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
```

**Platform setup required:**
- Android: `google-services.json` in `android/app/`
- iOS: `GoogleService-Info.plist` in `ios/Runner/` + URL scheme in `Info.plist`

---

## 4. Nominatim Reverse Geocoding

**Provider:** OpenStreetMap / Nominatim  
**Type:** Public REST API (no API key required)  
**Package:** `http: ^1.2.0`  
**Source file:** `lib/services/location_service.dart`

Used to convert GPS coordinates into a human-readable city and country name for display in the user profile and onboarding.

---

### Endpoint

```
GET https://nominatim.openstreetmap.org/reverse
```

### Request

```dart
final uri = Uri.parse(
  'https://nominatim.openstreetmap.org/reverse'
  '?lat=${position.latitude}&lon=${position.longitude}'
  '&format=json&accept-language=en',
);
final response = await http.get(
  uri,
  headers: {'User-Agent': 'AfriGlow/1.0 (skincare-app)'},
).timeout(const Duration(seconds: 8));
```

**Query parameters:**

| Parameter | Value | Description |
|-----------|-------|-------------|
| `lat` | `double` | GPS latitude from device |
| `lon` | `double` | GPS longitude from device |
| `format` | `json` | Response format |
| `accept-language` | `en` | Force English place names |

**Required header:** `User-Agent` — Nominatim's usage policy requires a descriptive `User-Agent` string identifying the application.

**Timeout:** 8 seconds.

---

### Response

```json
{
  "place_id": 123456,
  "lat": "3.8634",
  "lon": "11.5163",
  "address": {
    "city": "Yaoundé",
    "state": "Centre Region",
    "country": "Cameroon",
    "country_code": "cm"
  },
  "display_name": "Yaoundé, Centre Region, Cameroon"
}
```

**Fields used:**

```dart
final addr = data['address'] as Map<String, dynamic>?;
city = addr['city']    ??
       addr['town']    ??
       addr['village'] ??
       addr['county']  ??
       addr['state']   ??
       'My Location';
country = addr['country'] ?? '';
```

The fallback chain (`city` → `town` → `village` → `county` → `state`) handles rural areas where `city` is absent.

**Error handling:** Any network failure is silently caught — the climate zone (calculated from raw coordinates) is still returned without a city name:

```dart
} catch (_) {
  // Network unavailable — climate still determined from coordinates
}
```

---

### Climate Zone Mapping (Coordinate Logic)

After geocoding, coordinates are mapped to one of four AfriGlow climate zones:

```dart
static String _climateFromCoords(double lat, double lon) {
  if (lat > 18) return 'harmattan';                         // Sahara / far Sahel
  if (lat > 8 && lon > -20 && lon < 20) return 'harmattan';// West-African Sahel
  if (lat >= -5 && lat <= 8) return 'tropical';             // Equatorial belt
  if (lat < -12) return 'savanna';                          // Southern Africa
  if (lat >= 5 && lat <= 15 && lon >= 20) return 'tropical';// East-African highlands
  return 'coastal';                                          // Default / transitional
}
```

| Climate Zone | Emoji | Geographic range |
|-------------|-------|-----------------|
| `harmattan` | 🌬️ | Sahara, Sahel, West Africa above 8°N |
| `tropical` | 🌴 | Equatorial belt (−5° to 8°N), East African highlands |
| `coastal` | 🌊 | Transitional coastal strips |
| `savanna` | 🌾 | Southern Africa (below −12°S) |

---

## 5. Geolocator (Device GPS)

**Type:** Device / OS API (not a network call)  
**Package:** `geolocator: ^13.0.0`  
**Source file:** `lib/services/location_service.dart`

Geolocator accesses the device's built-in location hardware via the Android `FusedLocationProviderClient` and iOS `CLLocationManager`.

---

### Permission Flow

```dart
// 1 — Check if location services are enabled on the device
final serviceEnabled = await Geolocator.isLocationServiceEnabled();
if (!serviceEnabled) throw 'Location services are disabled...';

// 2 — Check app permission status
var permission = await Geolocator.checkPermission();

// 3 — Request if not yet granted
if (permission == LocationPermission.denied) {
  permission = await Geolocator.requestPermission();
}

// 4 — Abort if denied or permanently denied
if (permission == LocationPermission.denied) throw '...';
if (permission == LocationPermission.deniedForever) throw '...';
```

---

### Position Request

```dart
position = await Geolocator.getCurrentPosition(
  locationSettings: const LocationSettings(
    accuracy: LocationAccuracy.medium,
  ),
).timeout(const Duration(seconds: 15));
```

| Setting | Value | Reason |
|---------|-------|--------|
| `accuracy` | `medium` | Sufficient for climate-zone detection; reduces battery impact vs. `high` |
| timeout | 15 seconds | Avoids hanging indefinitely in low-signal environments |

**Returns:** `Position` with `latitude`, `longitude`, `accuracy`, `timestamp`.

**Platform manifest entries required:**
- Android: `ACCESS_FINE_LOCATION` and `ACCESS_COARSE_LOCATION` in `AndroidManifest.xml`
- iOS: `NSLocationWhenInUseUsageDescription` in `Info.plist`

---

## 6. Flutter Local Notifications

**Type:** Device / OS API (no network)  
**Package:** `flutter_local_notifications: ^18.0.0`  
**Timezone package:** `timezone: ^0.9.4`  
**Source file:** `lib/services/notification_service.dart`

Used to schedule a recurring annual birthday notification for the user.

---

### Initialisation

```dart
static Future<void> init() async {
  tz.initializeTimeZones();
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: android);
  await _plugin.initialize(settings);
  await _plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}
```

Called once in `main.dart` at app startup.

---

### Schedule Birthday Notification

```dart
static Future<void> scheduleBirthday(DateTime dob, String firstName) async {
  await _plugin.cancel(_birthdayId); // Cancel any existing birthday notification

  final now = DateTime.now();
  var next = DateTime(now.year, dob.month, dob.day, 9, 0); // 9:00 AM this year
  if (!next.isAfter(now)) {
    next = DateTime(now.year + 1, dob.month, dob.day, 9, 0); // Move to next year
  }

  await _plugin.zonedSchedule(
    _birthdayId,                               // Notification ID: 42
    '🎂 Happy Birthday, $firstName!',          // Title
    'Your skin is glowing today...',           // Body
    tz.TZDateTime.from(next, tz.local),        // Fire time (local timezone)
    const NotificationDetails(android: _androidChannel),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}
```

**Android notification channel:**

| Property | Value |
|----------|-------|
| Channel ID | `afriglow_birthday` |
| Channel name | `Birthday Notifications` |
| Importance | `Importance.high` |
| Priority | `Priority.high` |

**Schedule mode:** `exactAllowWhileIdle` — fires even when the device is in Doze mode (Android 6+). Requires the `SCHEDULE_EXACT_ALARM` permission on Android 12+.

---

## 7. Unsplash CDN

**Provider:** Unsplash (unsplash.com)  
**Type:** Public image CDN (no API key required for direct image URLs)  
**Source file:** `lib/utils/app_images.dart`

All hero, onboarding, quiz background, and ingredient images are served from the Unsplash CDN using direct photo URLs. Images are free to use in apps under the Unsplash License.

---

### URL Format

```
https://images.unsplash.com/photo-{photo-id}?w={width}&q={quality}
https://images.unsplash.com/photo-{photo-id}?w={width}&fit=crop&q={quality}
```

| Parameter | Value | Description |
|-----------|-------|-------------|
| `w` | `600` or `800` | Max width in pixels |
| `q` | `80` | JPEG quality (1–100) |
| `fit=crop` | (optional) | Crop to exact dimensions |

---

### Images Used

| Key | Usage | Width |
|-----|-------|-------|
| `onboarding1` | Login screen hero | 800 |
| `onboarding2` | Register screen hero | 800 |
| `onboarding3` | Onboarding step hero | 800 |
| `homeBanner` | Home screen banner | 800 |
| `quizStep1` | Quiz step 1 background | 800 |
| `quizStep2` | Quiz step 2 background | 800 |
| `quizStep3` | Quiz step 3 background | 800 |
| `quizStep4` | Quiz step 4 background | 800 |
| `quizStep5` | Quiz step 5 background | 800 |
| `womanSkincare1` | Home lifestyle image | 600 |
| `womanSkincare2` | Home lifestyle image | 600 |
| `shea_butter` | Ingredient card | 600 |
| `baobab` | Ingredient card | 600 |
| `moringa` | Ingredient card | 600 |
| `coconut_oil` | Ingredient card | 600 |
| `argan_oil` | Ingredient card | 600 |
| `marula` | Ingredient card | 600 |
| `african_black_soap` | Ingredient card | 600 |
| `rooibos` | Ingredient card | 600 |
| `neem` | Ingredient card | 600 |

**Error handling:** Every `Image.network()` call in the app includes an `errorBuilder` that falls back to a solid `AppColors.cocoa` container if the CDN is unreachable.

---

## 8. Wikimedia Commons CDN

**Provider:** Wikimedia Foundation  
**Type:** Public image CDN (no API key required)  
**License:** CC BY-SA / public domain  
**Source file:** `lib/utils/app_images.dart`

Three ingredient images are sourced from Wikimedia Commons instead of Unsplash because more accurate botanical photographs are available there under open licenses.

---

### URL Format

```
https://commons.wikimedia.org/wiki/Special:FilePath/{filename}?width={width}
```

| Parameter | Description |
|-----------|-------------|
| `filename` | Exact Wikimedia Commons file name (URL-encoded) |
| `width` | Requested image width in pixels |

---

### Images Used

| Ingredient | Wikimedia File | Width |
|-----------|---------------|-------|
| `aloe_vera` | `Aloe_vera_flower_inset.png` | 400 |
| `black_seed` | `Nigella_sativa_seeds.jpg` | 400 |
| `hibiscus` | `Hibiscus_sabdariffa_flowers.jpg` | 400 |

**Example URL:**
```
https://commons.wikimedia.org/wiki/Special:FilePath/Nigella_sativa_seeds.jpg?width=400
```

---

## 9. Google Fonts CDN

**Provider:** Google Fonts  
**Type:** Font CDN  
**Package:** `google_fonts: ^6.2.1`

The `google_fonts` package downloads the **Poppins** font family at runtime on first launch and caches it locally on the device. No API key is required.

**Font used throughout the app:** Poppins  
**Weights used:** 400 (regular), 500 (medium), 600 (semi-bold), 700 (bold), 800 (extra-bold)

```dart
// Example usage throughout the codebase
Text('AfriGlow',
  style: GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  ));
```

**Caching:** After the first download the font is stored in the device's application cache directory and served locally on subsequent launches — no CDN call is made.

**Offline fallback:** If the CDN is unreachable on first launch, the system default sans-serif font is used.

---

## 10. API Summary Table

| # | API / Service | Provider | Auth Required | Network Call | Purpose |
|---|---------------|----------|---------------|--------------|---------|
| 1 | Firebase Authentication | Google | API key (in `firebase_options.dart`) | Yes | User sign-up, sign-in, password reset |
| 2 | Cloud Firestore | Google | Firebase Auth token | Yes | User profiles, skin analyses, routine logs, favourites |
| 3 | Google Sign-In (OAuth 2.0) | Google | OAuth client ID | Yes | "Continue with Google" button |
| 4 | Nominatim Reverse Geocoding | OpenStreetMap | None (User-Agent header) | Yes | Convert GPS coordinates to city/country name |
| 5 | Geolocator (GPS) | Device OS | Device permission | No (local) | Read device GPS coordinates |
| 6 | Flutter Local Notifications | Device OS | Device permission | No (local) | Birthday reminder at 9 AM |
| 7 | Unsplash CDN | Unsplash | None | Yes | Hero, onboarding, lifestyle, and ingredient images |
| 8 | Wikimedia Commons CDN | Wikimedia | None | Yes | Botanical ingredient images (aloe, black seed, hibiscus) |
| 9 | Google Fonts CDN | Google | None | Yes (first launch only) | Poppins typeface |

---

### Rate Limits & Usage Policies

| Service | Limit / Policy |
|---------|---------------|
| Firebase Auth | Free tier: 10,000 sign-ins/month (email), unlimited Google sign-in |
| Cloud Firestore | Free tier: 50,000 reads, 20,000 writes, 20,000 deletes per day |
| Nominatim | Max 1 request/second; must include `User-Agent`; no bulk geocoding |
| Unsplash | Hotlinking from direct photo URLs is permitted under the Unsplash License |
| Wikimedia Commons | Public CDN; no rate limit for reasonable app traffic |
| Google Fonts | No stated limit; fonts are cached locally after first download |

---

*Document generated for AfriGlow v1.0.0 — 2026*
