# 7. Application of Scrum — 5 Marks

## Overview
AfriGlow was developed following the Scrum agile framework, with work organised into focused sprints, a maintained product backlog, and defined roles within the team.

## Scrum Roles

| Role | Team Member |
|------|-------------|
| Product Owner | FODOPTACHEKAM (defines features, priorities) |
| Scrum Master | Rotating per sprint |
| Development Team | All team members |

## Product Backlog (Sample Items)

| ID | User Story | Priority | Story Points |
|----|-----------|----------|--------------|
| US-01 | As a user, I can register with email so I can create an account | High | 3 |
| US-02 | As a user, I can log in with Google for convenience | High | 5 |
| US-03 | As a new user, I complete a skin quiz to personalise my experience | High | 8 |
| US-04 | As a user, I can scan my skin and get an AI health score | High | 13 |
| US-05 | As a user, I can track my daily skincare routine | Medium | 8 |
| US-06 | As a user, I can chat with an AI assistant about skincare | Medium | 8 |
| US-07 | As a user, I can browse African ingredients and their benefits | Medium | 5 |
| US-08 | As a returning user, I skip the quiz and go straight to dashboard | High | 3 |
| US-09 | As a user, my routine and chat history are saved between sessions | High | 8 |
| US-10 | As a user, I can download the app from a website | Low | 5 |

## Sprint Plan

### Sprint 1 — Foundation (Week 1–2)
**Goal**: Authentication and onboarding working end-to-end
- Set up Flutter project, Firebase, Provider
- Implement Login screen (Email + Google Sign-In)
- Implement Register screen
- Build skin quiz (SkinQuizScreen)
- Wire `saveUserProfile()` to Firestore on quiz completion
- **Review**: Users can register, log in, and complete the quiz. Profile saved to Firestore.

### Sprint 2 — Core Features (Week 3–4)
**Goal**: Scanner and dashboard functional
- Build Dashboard with skin score ring and quick actions
- Build SkinScannerScreen with camera integration and AI model
- Build IngredientScreen with African ingredients list
- Build RoutineScreen with AM/PM step tracking
- **Review**: Main app loop works — scan, view score, follow routine.

### Sprint 3 — Persistence & Chat (Week 5–6)
**Goal**: All data persists to Firestore
- Wire all Firestore saves (analysis, routine logs, favorites)
- Build ChatScreen with AI assistant
- Implement `saveChatMessage()` and `loadChatHistoryFromFirestore()`
- Implement `loadTodayRoutineFromFirestore()` and `loadSkinHistoryFromFirestore()`
- **Review**: App is stateful — all user data survives restarts.

### Sprint 4 — Deployment & Polish (Week 7–8)
**Goal**: App ready for public release
- Change package name to `com.afriglow.skinwise`
- Generate keystore and configure APK signing
- Generate app icons via `flutter_launcher_icons`
- Update Firestore security rules
- Build marketing website (AfriGlow_Website)
- Build signed release APK
- **Review**: App downloadable by anyone from the website.

## Scrum Ceremonies

| Ceremony | Frequency | Duration |
|----------|-----------|----------|
| Sprint Planning | Start of each sprint | 1 hour |
| Daily Standup | Each working day | 15 minutes |
| Sprint Review | End of each sprint | 30 minutes |
| Sprint Retrospective | End of each sprint | 20 minutes |

## Definition of Done
A user story is considered done when:
1. Feature is implemented in Dart/Flutter
2. Data is persisted to/loaded from Firestore where applicable
3. `flutter analyze` reports no issues
4. The feature has been tested on a real Android device

## Summary
Scrum provided AfriGlow with a structured, iterative development process. Each sprint delivered a working, demonstrable increment. The backlog was continuously refined based on sprint reviews, ensuring the highest-value features were always implemented first.
