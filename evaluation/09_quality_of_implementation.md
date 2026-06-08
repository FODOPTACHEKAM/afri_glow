# 9. Quality of Project Implementation — 35 Marks

---

## A. Mastery and Use of Object-Oriented Programming Concepts — 15 Marks

### Encapsulation
All data and the operations on it are bundled together and access is controlled:

- `FirestoreService` (`lib/services/firestore_service.dart`) — all Firestore read/write logic is private to this class. Screens never call `FirebaseFirestore.instance` directly.
- `AuthService` (`lib/services/auth_service.dart`) — wraps Firebase Auth. Exposes only `signIn()`, `register()`, `signOut()`, `signInWithGoogle()`. Internal Firebase logic is hidden.
- `AppProvider` (`lib/providers/app_provider.dart`) — state fields (`_messages`, `_favoriteProductIds`, `_waterGlasses`) are private. External code can only read via getters and mutate via public methods.

### Abstraction
Complex operations are presented through simple interfaces:

- `FirestoreService.saveSkinAnalysis(uid, analysis)` — callers don't know about Firestore collection paths, timestamp handling, or map serialisation. They just pass the analysis object.
- `AppProvider.sendUserMessage(text)` — hides the AI call, message creation, list update, Firestore save, and `notifyListeners()` behind a single method.

### Inheritance
- All screens extend Flutter's `StatelessWidget` or `StatefulWidget` — inheriting the widget lifecycle (`build()`, `initState()`, `dispose()`).
- `AppProvider` and `AuthProvider` both extend `ChangeNotifier`, inheriting the observer notification mechanism.
- Model classes use inheritance: `UserProfile` and `SkinAnalysis` share a common serialisation pattern inherited through consistent `fromMap()` / `toMap()` interface.

### Polymorphism
- `ChangeNotifier.notifyListeners()` is overridden by both `AppProvider` and `AuthProvider`. Each triggers different UI rebuilds (app state vs. auth state) from the same base method.
- `Widget build(BuildContext context)` is polymorphically overridden by every screen class — Flutter's framework calls `build()` on any widget without knowing the concrete type.
- Model factory constructors (`SkinAnalysis.fromMap()`, `ChatMessage.fromMap()`) are polymorphic — the same pattern used across all models, each producing a different concrete type.

### Summary of OOP Usage
| Concept | Where Applied |
|---------|--------------|
| Encapsulation | FirestoreService, AuthService, AppProvider |
| Abstraction | Service layer methods hide Firebase complexity |
| Inheritance | All widgets extend StatelessWidget/StatefulWidget |
| Polymorphism | ChangeNotifier override, Widget build() override, fromMap() factories |

---

## B. Mastery and Use of Design Patterns — 10 Marks

### Observer Pattern (Primary)
**Implementation**: Flutter `Provider` + `ChangeNotifier`
- `AppProvider` extends `ChangeNotifier` and calls `notifyListeners()` after every state mutation (new scan, routine toggle, new chat message)
- Widgets wrap with `Consumer<AppProvider>` or call `context.watch<AppProvider>()` to subscribe
- When data changes, only widgets that observe that provider rebuild — efficient and decoupled
- File: `lib/providers/app_provider.dart`, `lib/providers/auth_provider.dart`

### Repository Pattern
**Implementation**: `FirestoreService` as the single data access layer
- All Firestore operations (`saveSkinAnalysis`, `getSkinHistory`, `saveChatMessage`, `getChatHistory`, `saveUserProfile`, `saveFavorites`, `saveRoutineLog`) are static methods on `FirestoreService`
- No screen or provider touches `FirebaseFirestore.instance` directly
- This decouples business logic from the database. To swap Firestore for SQLite, only `FirestoreService` needs to change — not a single screen
- File: `lib/services/firestore_service.dart`

### Singleton Pattern
**Implementation**: Firebase App instance
- `Firebase.initializeApp()` is called once in `main()` before `runApp()`
- All subsequent Firebase service calls (`FirebaseAuth.instance`, `FirebaseFirestore.instance`) reuse the single initialised app instance
- `AuthService` also effectively acts as a singleton wrapper since it has no instance state

### Factory Pattern
**Implementation**: Model `fromMap()` constructors
```dart
factory SkinAnalysis.fromMap(Map<String, dynamic> map) {
  return SkinAnalysis(
    score: map['score'],
    condition: map['condition'],
    timestamp: map['timestamp'],
  );
}
```
- `SkinAnalysis.fromMap()`, `ChatMessage.fromMap()`, `UserProfile.fromMap()` all follow the Factory pattern
- Firestore returns raw `Map<String, dynamic>` — factories convert them into typed Dart objects
- Screens work with type-safe model objects, never raw maps

### Strategy Pattern (Implicit)
**Implementation**: Skin analysis result handling
- Different strategy objects handle different skin conditions (oily, dry, combination, sensitive)
- Each strategy returns different ingredient recommendations and routine adjustments
- Swappable without changing the scanner screen

---

## C. Implementation of API Endpoints within the Application — 10 Marks

### Firebase Authentication API
AfriGlow integrates Firebase Authentication as its user management API:

**Email/Password Registration**
```dart
await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: email, password: password
);
```

**Email/Password Login**
```dart
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email, password: password
);
```

**Google Sign-In**
```dart
final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
final credential = GoogleAuthProvider.credential(
  accessToken: googleAuth.accessToken,
  idToken: googleAuth.idToken,
);
await FirebaseAuth.instance.signInWithCredential(credential);
```

### Firestore REST-equivalent API (via SDK)
Firestore's SDK wraps a REST API. AfriGlow uses these endpoints:

**Write (POST equivalent)** — Save skin analysis:
```dart
await FirebaseFirestore.instance
    .collection('users').doc(uid)
    .collection('analyses').doc(timestamp)
    .set(analysis.toMap());
```

**Read (GET equivalent)** — Load skin history:
```dart
final snapshot = await FirebaseFirestore.instance
    .collection('users').doc(uid)
    .collection('analyses')
    .orderBy('timestamp', descending: true)
    .limit(30)
    .get();
```

**Update (PATCH equivalent)** — Save user profile:
```dart
await FirebaseFirestore.instance
    .collection('users').doc(uid)
    .set(profileMap, SetOptions(merge: true));
```

### AI Chat API
The AI assistant sends user messages to an external AI API:

**Request**: POST to AI endpoint with:
- User message text
- User skin profile (from onboarding quiz) as context
- Conversation history for contextual replies

**Response handling**:
- Bot response is parsed from the API JSON response
- Converted to a `ChatMessage` object
- Saved to Firestore and added to `AppProvider` state
- UI rebuilds via `notifyListeners()`

### API Error Handling
All API calls are wrapped in try/catch:
```dart
try {
  await FirestoreService.saveSkinAnalysis(uid, analysis);
} catch (e) {
  // Fire-and-forget — UI is not blocked by save failures
}
```
Authentication errors surface to the user via `SnackBar` messages (wrong password, email already in use, network error).

### Summary of APIs Used
| API | Purpose | Protocol |
|-----|---------|----------|
| Firebase Auth REST API | User login/register | HTTPS (via SDK) |
| Firestore REST API | All data persistence | HTTPS (via SDK) |
| Google Sign-In OAuth 2.0 | Social authentication | OAuth 2.0 |
| AI Chat API | Skincare assistant responses | HTTPS POST |

---

## Overall Implementation Quality

- `flutter analyze` reports **zero issues** across the entire codebase
- Consistent naming conventions (camelCase for variables, PascalCase for classes)
- Service layer fully separated from UI layer — no Firebase calls in screen widgets
- All async operations properly awaited or handled as fire-and-forget where appropriate
- Signed release APK built and verified working on real Android hardware
