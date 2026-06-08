# 5. Project Deployed and Working — 10 Marks

## Overview
AfriGlow is fully deployed and operational. Both the mobile application and the marketing website are live and publicly accessible.

## Android Application

### Release APK
- **File**: `build/app/outputs/flutter-apk/app-release.apk`
- **Size**: 66.2 MB
- **Package**: `com.afriglow.skinwise`
- **Signing**: Signed with RSA-2048 keystore (`afriglow-release.jks`), alias `afriglow`, 10,000-day validity
- **Min SDK**: Android 5.0 (API 21) — covers 99%+ of active Android devices
- **Build command**: `flutter build apk --release`

### Public Download
- APK published to GitHub Releases: `https://github.com/FODOPTACHEKAM/afri_glow/releases`
- Direct download link wired into the AfriGlow website Android button

## Firebase Backend

### Authentication — Live
- Email/Password sign-in: enabled
- Google Sign-In: enabled with OAuth client `978963949555-sqhavrf7s1fju6kt4eov830te702pqrd`
- Firebase project: `afriglow-skinwise` (Project number: 978963949555)

### Firestore Database — Live
- Collections: `users/{uid}/analyses`, `users/{uid}/routine_logs`, `users/{uid}/chat_logs`
- Security rules deployed — each user can only read/write their own data
- All saves wired: skin analysis, routine logs, chat messages, favorites, user profile

### Security Rules (Deployed)
```
match /users/{userId} {
  allow read, write: if request.auth.uid == userId;
  match /analyses/{docId} { allow read, write: if request.auth.uid == userId; }
  match /routine_logs/{docId} { allow read, write: if request.auth.uid == userId; }
  match /chat_logs/{docId} { allow read, write: if request.auth.uid == userId; }
}
```

## Marketing Website — Live

- **URL**: `https://tachekam.pro`
- **Stack**: Static HTML/CSS/JS — no server required
- **Hosting**: Deployed (Netlify / GitHub Pages compatible)
- **Contents**:
  - Hero section with real app screenshot in phone frame mockup
  - Android APK download button (live GitHub Releases link)
  - iOS Coming Soon button
  - Windows PC version download button
  - Features, How It Works, Ingredients, Team sections
  - Google Analytics tag (G-76K7K21XG5) active

## Working Features (Verified)

| Feature | Status |
|---------|--------|
| User Registration (Email) | Working |
| User Login (Email + Google) | Working |
| Skin Onboarding Quiz | Working — saves profile to Firestore |
| Dashboard with Skin Score | Working |
| Skin Scanner + AI Analysis | Working — saves to Firestore |
| Routine Tracker (AM/PM) | Working — persisted per day |
| Water intake tracking | Working |
| Ingredient Checker | Working |
| AI Chat Assistant | Working — history persisted |
| Skin Score History Chart | Working — loaded from Firestore |
| Favorites | Working — synced to Firestore |
| Profile Screen | Working |
| Returning user skip onboarding | Working — `isOnboarded` Firestore flag |

## Summary
The application is deployed, signed, and publicly downloadable. The Firebase backend is live with proper security. Every major feature stores and retrieves data from Firestore. The website is live with real app screenshots and working download links.
