# 2. Quality of Report (UML Diagrams etc.) — 15 Marks

## Overview
The AfriGlow project report documents the full software engineering process, including system design, architecture diagrams, and implementation details.

## Report Contents

### Use Case Diagram
- Actors: Guest User, Registered User, Firebase (system actor)
- Use Cases: Register/Login, Take Skin Scan, View Analysis, Track Routine, Browse Ingredients, Chat with AI Assistant, View Profile, Download App
- Relationships: `<<include>>` for authentication flows, `<<extend>>` for optional Google Sign-In

### Class Diagram (Key Classes)
- `AppProvider` — central state manager (ChangeNotifier)
- `AuthProvider` — authentication state
- `FirestoreService` — all database operations (static methods)
- `AuthService` — Firebase Auth wrapper
- `SkinAnalysis` — model for scan results
- `ChatMessage` — model for AI chat
- `UserProfile` — model for user skin data
- Relationships: dependency, association, and realisation shown between layers

### Sequence Diagrams
- **Login Flow**: User → LoginScreen → AuthService → Firebase Auth → Firestore → SplashScreen → Dashboard
- **Skin Scan Flow**: User → ScannerScreen → ML Model → FirestoreService → Firestore → Analysis Result
- **Routine Tracking**: User → RoutineScreen → AppProvider → FirestoreService → Firestore (fire-and-forget)

### Architecture Diagram
- Layered architecture: Presentation → Business Logic (Providers) → Service Layer → Firebase
- Shows separation of UI, state, services, and backend

### Entity-Relationship Diagram (Firestore)
```
users/{uid}
  ├── analyses/{docId}
  ├── routine_logs/{docId}
  └── chat_logs/{docId}
```
- Each collection documented with field names and data types

### State Transition Diagram
- App states: Unauthenticated → Onboarding → Dashboard
- Transition conditions: login success, quiz completion, `isOnboarded` flag

## Report Quality Indicators
- Written using formal academic structure (Introduction, Literature Review, Design, Implementation, Testing, Conclusion)
- All diagrams generated using standard UML notation
- References to Flutter, Firebase, and design pattern documentation included
- Report cross-references code file locations for each feature

## Summary
The report provides a thorough software engineering artefact with UML diagrams at every design level — use case, structural (class), behavioural (sequence, state), and data (ER) — giving a complete picture of how AfriGlow was designed and built.
