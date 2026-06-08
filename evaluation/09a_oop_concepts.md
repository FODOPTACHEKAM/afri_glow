# Mastery and Use of Object-Oriented Programming Concepts — 15 Marks

## Overview
AfriGlow is built entirely in Dart, a purely object-oriented language. Every feature of the app demonstrates the four core OOP pillars: Encapsulation, Abstraction, Inheritance, and Polymorphism.

---

## 1. Encapsulation

Encapsulation bundles data and the methods that operate on it inside a class, and restricts direct access from outside.

### AppProvider (`lib/providers/app_provider.dart`)
All state fields are private (prefixed with `_`). External code cannot directly modify them — it must go through controlled public methods.

```dart
class AppProvider extends ChangeNotifier {
  // Private fields — no direct external access
  UserProfile? _userProfile;
  SkinAnalysis? _latestAnalysis;
  final Set<String> _favoriteProductIds = {};
  final List<ChatMessage> _messages = [];
  String? _profileImageUrl;

  // Controlled read access via getters
  UserProfile? get userProfile => _userProfile;
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  // Controlled write access via methods only
  void setAnalysis(SkinAnalysis analysis) {
    _latestAnalysis = analysis;
    _skinScoreHistory.add(analysis.skinScore);
    notifyListeners();
  }
}
```

### FirestoreService (`lib/services/firestore_service.dart`)
All Firestore collection paths, document structures, and query logic are hidden inside static methods. Screens never know that `users/{uid}/analyses` is the collection path — they just call `saveSkinAnalysis(uid, analysis)`.

```dart
class FirestoreService {
  static final _db = FirebaseFirestore.instance; // private, hidden

  // Public interface — callers don't know the internal structure
  static Future<void> saveSkinAnalysis(String uid, SkinAnalysis analysis) async {
    await _db.collection('users').doc(uid).collection('analyses').add({...});
  }
}
```

### AuthService (`lib/services/auth_service.dart`)
Firebase Auth SDK calls are encapsulated. Screens call `AuthService.signIn(email, password)` without knowing Firebase's internal credential flow.

---

## 2. Abstraction

Abstraction presents a simple interface while hiding complex implementation details.

### Service Layer Abstraction
`AppProvider.sendUserMessage(text)` hides six internal operations behind one call:
1. Creates a `ChatMessage` object
2. Adds it to the messages list
3. Calls `notifyListeners()` to update the UI
4. Fires a Firestore save asynchronously
5. Generates an AI response after an 800ms delay
6. Saves the bot message to Firestore

The calling screen (ChatScreen) only does:
```dart
provider.sendUserMessage(userInput);
```

### Score Abstraction
`provider.quizBasedScore` abstracts a multi-variable calculation (sleep, water intake, skin type, concerns) into a single `double` value that the UI reads directly.

### Model Abstraction via `fromMap()`
Firestore returns raw `Map<String, dynamic>`. The model layer abstracts this conversion:
```dart
// Caller never handles raw maps
final analysis = SkinAnalysis.fromMap(rawData);
print(analysis.scoreLabel); // "Good", "Excellent", etc.
```

---

## 3. Inheritance

Inheritance allows a class to reuse behaviour from a parent class.

### Widget Inheritance
Every screen class inherits from Flutter's `StatelessWidget` or `StatefulWidget`:
```dart
class HomeScreen extends StatelessWidget { ... }
class RoutineScreen extends StatefulWidget { ... }
class _RoutineScreenState extends State<RoutineScreen>
    with SingleTickerProviderStateMixin { ... }
```
By inheriting `StatefulWidget`, `RoutineScreen` gets the full lifecycle: `initState()`, `build()`, `dispose()`.

### Provider Inheritance
Both `AppProvider` and `AuthProvider` extend `ChangeNotifier`:
```dart
class AppProvider extends ChangeNotifier { ... }
class AuthProvider extends ChangeNotifier { ... }
```
They inherit `notifyListeners()`, `addListener()`, and `dispose()` from the parent class without re-implementing them.

### Mixin Inheritance
`_RoutineScreenState` uses `with SingleTickerProviderStateMixin` — a mixin that provides `vsync` support for `TabController`, inherited via Dart's mixin mechanism:
```dart
class _RoutineScreenState extends State<RoutineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  // vsync: this works because of the mixin
  _tabs = TabController(length: 3, vsync: this);
}
```

---

## 4. Polymorphism

Polymorphism allows different classes to be treated through the same interface, with each responding differently.

### Widget `build()` Override
Every widget in Flutter overrides the same `build(BuildContext context)` method. The framework calls `build()` on any widget without knowing its concrete type — each returns a completely different widget tree:
```dart
// Flutter calls build() on all of these — same signature, different result
class HomeScreen extends StatelessWidget {
  Widget build(BuildContext context) => /* full home page */;
}
class ChatScreen extends StatelessWidget {
  Widget build(BuildContext context) => /* chat interface */;
}
```

### ChangeNotifier Polymorphism
`Provider` stores widgets as `ChangeNotifier` references. Both `AppProvider` and `AuthProvider` respond to `notifyListeners()` polymorphically — each triggers rebuilds for different parts of the widget tree:
```dart
context.watch<AppProvider>()   // triggers on skin data changes
context.watch<AuthProvider>()  // triggers on login state changes
```

### Factory Constructor Polymorphism
Model classes share the same `fromMap()` factory pattern but produce different objects:
```dart
SkinAnalysis.fromMap(data)   // → SkinAnalysis with score, concerns, tone
ChatMessage.fromMap(data)    // → ChatMessage with text, timestamp, isUser
UserProfile.fromMap(data)    // → UserProfile with skinType, climate, etc.
```

---

## OOP Coverage Summary

| OOP Concept | Where Applied | Files |
|-------------|--------------|-------|
| Encapsulation | Private fields + public getters | `app_provider.dart`, `firestore_service.dart`, `auth_service.dart` |
| Abstraction | Service layer methods, `quizBasedScore`, `fromMap()` | All service + model files |
| Inheritance | Widget hierarchy, ChangeNotifier, mixins | All screens + providers |
| Polymorphism | `build()` override, `notifyListeners()`, `fromMap()` factories | All screens, providers, models |

All four OOP pillars are applied consistently throughout the AfriGlow codebase — not just in one isolated class, but as the foundational architecture of the entire application.
