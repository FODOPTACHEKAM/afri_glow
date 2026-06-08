# Mastery and Use of Design Patterns — 10 Marks

## Overview
AfriGlow applies four recognised software design patterns from the Gang of Four (GoF) and architectural catalogues. Each pattern solves a specific problem and is demonstrated with real code from the project.

---

## 1. Observer Pattern (Behavioural)

**Problem**: The UI must update automatically whenever app state changes (new scan result, routine toggled, chat message sent) without tight coupling between data and widgets.

**Solution**: Flutter's `Provider` package implements the Observer pattern. `AppProvider` is the **Subject** (observable). Widgets that call `context.watch<AppProvider>()` are **Observers** (listeners).

```dart
// Subject — notifies all observers when state changes
class AppProvider extends ChangeNotifier {
  void toggleRoutineStep(String stepId) {
    _routineChecks[stepId] = !(_routineChecks[stepId] ?? false);
    notifyListeners(); // broadcasts to all observers
    _persistRoutineLog();
  }
}

// Observer — rebuilds automatically when AppProvider notifies
class RoutineScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>(); // subscribes
    // this widget rebuilds every time notifyListeners() is called
    ...
  }
}
```

**Where used**: Every screen in AfriGlow observes either `AppProvider` or `AuthProvider`. State changes in the provider immediately reflect in the UI without manual refresh calls.

---

## 2. Repository Pattern (Architectural)

**Problem**: Screens and providers should not know whether data comes from Firestore, a local cache, or a REST API. Mixing database calls into UI code makes testing and maintenance difficult.

**Solution**: `FirestoreService` is the **Repository** — a single class that owns all data access. Nothing else touches `FirebaseFirestore.instance` directly.

```dart
// Repository — single point of data access
class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> saveSkinAnalysis(String uid, SkinAnalysis a) async {
    await _db.collection('users').doc(uid).collection('analyses').add({
      'skinScore': a.skinScore,
      'concerns': a.concerns,
      'analyzedAt': Timestamp.fromDate(a.analyzedAt),
    });
  }

  static Future<List<Map<String, dynamic>>> getSkinAnalyses(String uid) async {
    final snap = await _db
        .collection('users').doc(uid).collection('analyses')
        .orderBy('analyzedAt', descending: true).limit(14).get();
    return snap.docs.map((d) => d.data()).toList();
  }
}

// AppProvider uses the repository — doesn't know it's Firestore
FirestoreService.saveSkinAnalysis(uid, analysis).catchError((_) {});
```

**Benefits**: To switch from Firestore to SQLite or a REST API, only `FirestoreService` needs to change. All 12 screens and both providers remain untouched.

**All repository methods**:
- `saveUserProfile` / `getUserProfile`
- `saveSkinAnalysis` / `getSkinAnalyses`
- `saveRoutineLog` / `getTodayRoutineLog`
- `saveFavorites` / `getFavorites`
- `saveChatMessage` / `getChatHistory`
- `saveProfileImageUrl`

---

## 3. Singleton Pattern (Creational)

**Problem**: Firebase must be initialised exactly once. Creating multiple Firebase app instances causes runtime errors.

**Solution**: `Firebase.initializeApp()` is called once in `main()` before `runApp()`. All subsequent Firebase service calls reuse the single instance — this is the Singleton pattern.

```dart
// main.dart — Firebase is initialised exactly once
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(...);
}

// Anywhere in the app — always the same instance
FirebaseAuth.instance        // → same singleton auth object
FirebaseFirestore.instance   // → same singleton database object
FirebaseStorage.instance     // → same singleton storage object
```

**`NotificationService`** also uses the Singleton pattern:
```dart
class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin(); // single instance
  // All methods are static — no constructor, no multiple instances
}
```

---

## 4. Factory Pattern (Creational)

**Problem**: Firestore returns raw `Map<String, dynamic>` data. The app needs typed Dart objects. Creating these objects with complex logic scattered across the codebase would be error-prone.

**Solution**: Each model class has a `fromMap()` factory constructor that centralises the creation logic.

```dart
// SkinAnalysis factory
class SkinAnalysis {
  factory SkinAnalysis.fromMap(Map<String, dynamic> map) {
    return SkinAnalysis(
      skinScore: (map['skinScore'] as num).toDouble(),
      concerns: List<String>.from(map['concerns'] ?? []),
      skinTone: map['skinTone'] ?? 'medium',
      recommendations: List<String>.from(map['recommendations'] ?? []),
      analyzedAt: map['analyzedAt'] is String
          ? DateTime.parse(map['analyzedAt'])
          : (map['analyzedAt'] as Timestamp).toDate(),
    );
  }
}

// ChatMessage factory
class ChatMessage {
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'] as String,
      isUser: map['isUser'] as bool,
      timestamp: DateTime.parse(map['timestamp'] as String),
      quickReplies: map['quickReplies'] != null
          ? List<String>.from(map['quickReplies'] as List)
          : null,
    );
  }
}
```

**Why Factory over a regular constructor**: The factory handles type coercion, null safety, and timestamp format differences (Firestore `Timestamp` vs ISO string) — logic that would pollute caller code if written inline.

---

## 5. Strategy Pattern (Behavioural) — Bonus

**Problem**: Different skin types require different routine steps and ingredient recommendations. Hard-coding `if (skinType == 'oily') { ... }` throughout the app creates tightly coupled, unmaintainable code.

**Solution**: `getRoutinesForSkinType(skinType)` in `lib/data/routines_data.dart` acts as a Strategy selector — it returns the correct `Routine` object (strategy) based on the user's skin type at runtime.

```dart
// Routine screen selects the strategy at runtime
final skinType = provider.userProfile?.skinType ?? 'normal';
final routines = getRoutinesForSkinType(skinType); // strategy selection

// Each skin type has its own steps — different strategy, same interface
final morning = routines.firstWhere((r) => r.type == 'morning');
```

---

## Design Patterns Summary

| Pattern | Category | Problem Solved | File(s) |
|---------|----------|---------------|---------|
| Observer | Behavioural | Reactive UI updates without tight coupling | `app_provider.dart`, all screens |
| Repository | Architectural | Data source abstraction — swap DB without touching UI | `firestore_service.dart` |
| Singleton | Creational | Single Firebase / notification plugin instance | `main.dart`, `notification_service.dart` |
| Factory | Creational | Type-safe model creation from raw Firestore maps | All model files |
| Strategy | Behavioural | Runtime selection of skin-type-specific routines | `routines_data.dart`, `routine_screen.dart` |

Each pattern in AfriGlow solves a real problem — none are used for academic demonstration only.
