# 8. CI/CD Pipeline — 5 Marks

## Overview
AfriGlow uses a Continuous Integration and Continuous Deployment pipeline built on GitHub Actions to automate code validation and release APK generation on every push to the main branch.

## Pipeline File
Located at `.github/workflows/flutter_ci.yml`

## Pipeline Stages

### Stage 1 — Trigger
```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
```
The pipeline runs on every push to `main` and on every pull request targeting `main`.

### Stage 2 — Setup
```yaml
- uses: actions/checkout@v4
- uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.x'
    channel: 'stable'
- run: flutter pub get
```
- Checks out the repository
- Installs the Flutter SDK (stable channel)
- Fetches all Dart/Flutter dependencies

### Stage 3 — Code Analysis (CI)
```yaml
- run: flutter analyze
```
- Runs Dart's static analyser across all source files
- Fails the build if any error or warning is found
- Enforces code quality before any merge to main

### Stage 4 — Tests (CI)
```yaml
- run: flutter test
```
- Executes all unit and widget tests in the `test/` directory
- Ensures no regressions are introduced by new commits

### Stage 5 — Release APK Build (CD)
```yaml
- name: Build APK
  run: flutter build apk --release
  env:
    KEY_STORE_PASSWORD: ${{ secrets.KEY_STORE_PASSWORD }}
    KEY_PASSWORD: ${{ secrets.KEY_PASSWORD }}
    KEY_ALIAS: ${{ secrets.KEY_ALIAS }}
    STORE_FILE: ${{ secrets.STORE_FILE }}
```
- Builds the signed release APK using credentials stored as GitHub Secrets
- Keystore file (`afriglow-release.jks`) is stored as a base64-encoded secret
- The `key.properties` file is generated dynamically from secrets — never committed to git

### Stage 6 — Upload Artefact (CD)
```yaml
- uses: actions/upload-artifact@v4
  with:
    name: AfriGlow-APK
    path: build/app/outputs/flutter-apk/app-release.apk
```
- Uploads the signed APK as a build artefact
- Artefact is downloadable directly from the GitHub Actions run page

### Stage 7 — GitHub Release (CD, on tag push)
```yaml
on:
  push:
    tags: ['v*']
- uses: softprops/action-gh-release@v2
  with:
    files: build/app/outputs/flutter-apk/app-release.apk
```
- When a version tag (e.g., `v1.0.0`) is pushed, the APK is automatically published to GitHub Releases
- This is the source of the public download link used by the website

## Security — Secrets Management
The following are stored as encrypted GitHub repository secrets, never in source code:
- `KEY_STORE_PASSWORD` — keystore password
- `KEY_PASSWORD` — key password
- `KEY_ALIAS` — key alias (`afriglow`)
- `STORE_FILE_BASE64` — base64-encoded `.jks` file

The `android/key.properties` file and `android/app/*.jks` are in `.gitignore`.

## Benefits Delivered

| Benefit | How |
|---------|-----|
| No broken code on main | `flutter analyze` gate on every push |
| Reproducible builds | Same Flutter version pinned in workflow |
| Automated APK delivery | No manual `flutter build` needed for releases |
| Secure signing | Credentials never in source code |
| Team confidence | PRs can't merge if analysis fails |

## Summary
The CI/CD pipeline automates the quality gates (analysis, tests) on every commit and the release process (signed APK build and publish) on every version tag, ensuring AfriGlow is always in a releasable state without manual intervention.
