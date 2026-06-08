# 3. Quality of Presentation — 25 Marks

## Overview
The AfriGlow presentation demonstrates the project from problem statement through live demonstration, covering the full software engineering process in a structured and professional manner.

## Presentation Structure

### Slide 1 — Title & Team
- Project name: AfriGlow — AI-Powered Skincare for African Skin
- Team members, roles, and student IDs
- Course: OOADI 11

### Slide 2 — Problem Statement
- 70%+ of skincare apps are trained on non-African skin types
- African and melanin-rich skin has unique needs (hyperpigmentation, humidity tolerance, traditional ingredient compatibility)
- No personalised, locally-aware skincare assistant existed for this demographic

### Slide 3 — Solution & Value Proposition
- AI-powered skin health scanner using camera input
- 12 traditional African ingredients database (Shea Butter, Argan Oil, Baobab, etc.)
- Personalised routine tracking, ingredient checker, and AI chat assistant
- Climate-aware tips (tropical/humid environment awareness)

### Slide 4 — Architecture Overview
- Flutter frontend (cross-platform: Android, iOS, Windows)
- Firebase backend: Auth, Firestore, Storage
- Provider pattern for state management
- Layered clean architecture diagram shown

### Slide 5 — Key Features Demo Walkthrough
1. Onboarding skin quiz → profile creation saved to Firestore
2. Dashboard with live skin health score ring
3. Skin Scanner → AI analysis → score stored in history
4. Daily Routine tracker with Firestore persistence
5. Ingredient Checker with product compatibility
6. AI Chat Assistant with conversation history
7. Profile screen with skin history chart

### Slide 6 — Database Design
- Firestore NoSQL structure shown
- Security rules explained (per-user isolation)
- Real-time sync demonstrated

### Slide 7 — OOP & Design Patterns
- Observer Pattern via Flutter Provider
- Repository Pattern via FirestoreService
- Singleton via Firebase.initializeApp
- Factory via model fromMap() constructors

### Slide 8 — Scrum Process
- Sprint board screenshots
- Backlog items mapped to features
- Velocity and burndown chart

### Slide 9 — CI/CD & Deployment
- GitHub Actions pipeline shown
- Signed APK build process
- Firebase rules deployment
- Live website at tachekam.pro

### Slide 10 — Live Demo
- App running on real Android device
- All 5 core features demonstrated live
- Firestore updates visible in Firebase Console in real time

### Slide 11 — Challenges & Lessons Learned
- Firebase Windows SDK (806 MB download, CMake issues resolved)
- Package name migration from `com.example` to `com.afriglow.skinwise`
- Keystore signing and release configuration

### Slide 12 — Conclusion & Future Work
- iOS App Store submission (requires Apple Developer account)
- Dermatologist partnership for ML model improvement
- Community ingredient reviews

## Presentation Delivery Notes
- Each team member presents their assigned section
- Live device demo prepared with app pre-logged in
- Backup screenshots available in case of connectivity issues
- Q&A preparation covered in `06_question_and_answer.md`

## Summary
The presentation is structured to tell a coherent story: problem → solution → architecture → features → process → deployment → future, with a live demo as the centrepiece to validate that the app truly works end-to-end.
