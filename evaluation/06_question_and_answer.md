# 6. Question and Answer Preparation — 25 Marks

## Overview
This document prepares answers for likely examiner questions across architecture, implementation, design decisions, and OOP/pattern usage in AfriGlow.

---

## Architecture Questions

**Q: Why did you choose Flutter over native Android/iOS development?**
Flutter allows a single codebase to target Android, iOS, and Windows simultaneously. For a team project with limited time, this is highly efficient. The Dart language is strongly typed and compiles to native ARM code, so there is no performance penalty compared to native development.

**Q: Why Firebase over a custom REST API backend?**
Firebase provided Authentication, Firestore, and Storage out of the box with no server setup. For a project of this scope, building a REST API (Node.js/Django) would have taken significant time away from app features. Firebase's real-time sync also improves UX without extra code.

**Q: How is state managed in the app?**
Using Flutter's `Provider` package, which implements the Observer pattern. `AppProvider` holds all UI state (scan results, routine, chat messages, skin history). `AuthProvider` handles authentication state. Both extend `ChangeNotifier` and notify the widget tree when data changes.

---

## Database Questions

**Q: Why Firestore instead of a relational database?**
The app's data model is naturally hierarchical: one user has many analyses, many routine logs, many chat messages. Firestore's document-subcollection structure maps directly to this. There are no complex JOIN queries needed, making NoSQL the right fit.

**Q: How do you ensure data security?**
Firestore security rules enforce that `request.auth.uid == userId` for every read and write. No user can access another user's data, even if they know the document path. The rules are applied at the Firebase server level — not just in the app — so they cannot be bypassed.

**Q: What happens if Firestore is unavailable?**
The app uses fire-and-forget saves (`catchError((_) {})`). The UI state lives in `AppProvider` in memory, so the app remains fully functional. Saves fail silently and the user loses only that session's data if offline. A production improvement would be Firestore offline persistence (`FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true)`).

---

## OOP Questions

**Q: Which OOP concepts did you apply?**
- **Encapsulation**: `FirestoreService` hides all Firestore calls behind static methods. Screens never call Firestore directly.
- **Abstraction**: `AuthService` abstracts Firebase Auth — the UI only calls `signIn()`, `signOut()`, `registerWithEmail()`.
- **Inheritance**: All screen widgets extend Flutter's `StatelessWidget` or `StatefulWidget`.
- **Polymorphism**: `ChangeNotifier` is overridden by both `AppProvider` and `AuthProvider`, each with different `notifyListeners()` triggers.

**Q: What design patterns did you use?**
- **Observer**: Provider/ChangeNotifier for reactive UI updates
- **Repository**: FirestoreService as the single data access layer
- **Singleton**: Firebase app instance (initialised once in `main()`)
- **Factory**: `SkinAnalysis.fromMap()`, `ChatMessage.fromMap()` constructors
- **Strategy**: Different scan analysis strategies depending on the detected skin condition

---

## Feature Questions

**Q: How does the skin scanner work?**
The scanner uses the device camera to capture a facial image. An AI model analyses the image for skin tone, texture, hydration level, and visible conditions (acne, hyperpigmentation). The result is a `SkinAnalysis` object with a score (0–100) and recommendations. The result is saved to `users/{uid}/analyses/{timestamp}` in Firestore.

**Q: How does the AI chat assistant work?**
User messages are sent to an AI API endpoint. The response is generated contextually based on the user's skin profile (from their onboarding quiz) and previous messages. Both user and bot messages are saved to `users/{uid}/chat_logs/` as `ChatMessage` objects. On app restart, history is loaded via `loadChatHistoryFromFirestore()`.

**Q: How does onboarding skip work for returning users?**
On quiz completion, `FirestoreService.saveUserProfile()` sets `isOnboarded: true` in the user's Firestore document. On splash screen load, the app reads this field. If true, it skips the quiz and navigates directly to the dashboard. New users always see the quiz.

---

## Deployment Questions

**Q: How did you sign the APK?**
Generated a Java KeyStore (`afriglow-release.jks`) with `keytool`, RSA-2048, 10,000-day validity. The keystore credentials are stored in `android/key.properties` (excluded from git). `build.gradle.kts` reads the properties and applies them in the `release` signingConfig.

**Q: What is the minimum Android version supported and why?**
Android 5.0 (API 21). This was chosen because Flutter's minimum supported SDK is 21 and it covers over 99% of active Android devices globally, including budget phones common in the target market (sub-Saharan Africa).

---

## Scrum Questions

**Q: How did you apply Scrum?**
Work was organised into sprints with a product backlog. Each sprint had a goal (e.g., Sprint 1: Auth + Onboarding; Sprint 2: Scanner + Dashboard; Sprint 3: Firestore persistence; Sprint 4: Deployment). Daily standups were held to track progress. See `07_application_of_scrum.md` for details.

---

## Summary
The Q&A preparation covers architecture rationale, database decisions, OOP concepts, design patterns, feature implementation, deployment process, and Scrum methodology — the five areas most likely to be examined in a 25-mark oral session.
