# AfriGlow – Flutter / Dart Login Screen

A pixel-faithful port of the AfriGlow HTML login page into **Flutter (Dart)**.

---

## Project structure

```
afriglow_flutter/
├── pubspec.yaml
└── lib/
    ├── main.dart                        # App entry point
    ├── theme/
    │   └── app_theme.dart              # Brand colours & gradients
    ├── services/
    │   └── auth_service.dart           # Login / forgot-password API calls
    ├── widgets/
    │   ├── toast_overlay.dart          # Slide-in toast notification
    │   ├── afriglow_text_field.dart    # Styled email/password input
    │   └── left_panel.dart            # Decorative left panel with botanical art
    └── screens/
        └── login_screen.dart          # Main login screen (responsive)
```

---

## Prerequisites

| Tool | Version |
|------|---------|
| Flutter SDK | ≥ 3.10 |
| Dart SDK | ≥ 3.0 |

Install Flutter: https://docs.flutter.dev/get-started/install

---

## Getting started

```bash
# 1 – enter the project folder
cd afriglow_flutter

# 2 – fetch dependencies
flutter pub get

# 3 – run (choose a target)
flutter run -d chrome          # web browser
flutter run -d macos           # macOS desktop
flutter run -d windows         # Windows desktop
flutter run                    # connected Android / iOS device
```

---

## Connecting your backend

Open `lib/services/auth_service.dart` and replace the placeholder:

```dart
const _apiBase = 'https://your-api.afriglow.com'; // ← change this
```

### Expected POST /api/auth/login
**Request body**
```json
{ "email": "...", "password": "...", "rememberMe": true }
```
**Success response (200)**
```json
{
  "token": "...",
  "user": { "name": "Ada" },
  "redirectUrl": "/dashboard"
}
```
**Error response (4xx)**
```json
{ "message": "Invalid credentials." }
```

### Expected POST /api/auth/forgot-password
**Request body**
```json
{ "email": "..." }
```

---

## Features ported from HTML

| Feature | Status |
|---------|--------|
| Split layout (left panel + form) | ✅ |
| Responsive — collapses to single column on narrow screens | ✅ |
| Botanical SVG decorations (custom painters) | ✅ |
| Brand logo, badges | ✅ |
| Email & password fields with icons | ✅ |
| Real-time blur validation | ✅ |
| Password show / hide toggle | ✅ |
| Remember me checkbox | ✅ |
| Forgot password (with email pre-check) | ✅ |
| Animated Sign In button with loading spinner | ✅ |
| Google / Apple social login stubs | ✅ |
| Slide-in toast notifications (success / error / info) | ✅ |
| Fade + slide-up entry animation | ✅ |
| Token persistence via SharedPreferences | ✅ |
| Demo mode when API is not yet connected | ✅ |

---

## Adding navigation

When login succeeds, look for the TODO comments in `login_screen.dart`:

```dart
// TODO: Navigator.pushReplacementNamed(context, result.redirectUrl ?? '/dashboard');
```

Wire these up to your own routes once you add more screens.
