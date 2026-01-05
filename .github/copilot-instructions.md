**Purpose**
- **Summary:** Provide concise, actionable guidance so an AI coding agent can be immediately productive in this Flutter + Firebase app.

**Big Picture**
- **App type:** Flutter multi-platform app (mobile/web/desktop) with Firebase backends. Key platforms: Android (`android/`), iOS (`ios/`), web (`web/`), macOS (`macos/`).
- **Entry point:** [lib/main.dart](lib/main.dart) initializes Firebase via [lib/firebase_options.dart](lib/firebase_options.dart) and wires routing/state.
- **Routing & UI:** Routing is defined in [lib/routing/router.dart](lib/routing/router.dart) with route names in [lib/routing/names.dart](lib/routing/names.dart). Main UI pages live in [lib/ui/](lib/ui/) (e.g., [lib/ui/LoginPage.dart](lib/ui/LoginPage.dart), [lib/ui/RegisterPage.dart](lib/ui/RegisterPage.dart)).
- **State management:** Uses Riverpod (`riverpod`, `flutter_riverpod`) — expect providers and consumer widgets throughout `lib/`.

**Critical Workflows**
- **Install deps:** `flutter pub get` (root).
- **Run (dev):** `flutter run -d <device>` — on iOS ensure CocoaPods are installed and run `pod install` in `ios/` if needed.
- **Build:** `flutter build apk` / `flutter build ios` / `flutter build web` as usual.
- **Tests:** `flutter test` (test files under `test/`, e.g., [test/widget_test.dart](test/widget_test.dart)).
- **Firebase emulators:** Project has `firebase.json`. Typical command: `firebase emulators:start`. Note: emulator setup may require `firebase init` and platform-specific config; first-time runs can fail (see local terminal history).

**Project-specific conventions & patterns**
- **File naming:** UI pages use PascalCase filenames ending with `Page.dart` (e.g., `LoginPage.dart`).
- **Routing:** Route definitions use `go_router`; prefer editing [lib/routing/router.dart](lib/routing/router.dart) and route names in [lib/routing/names.dart](lib/routing/names.dart).
- **Firebase config:** Android: [android/app/google-services.json](android/app/google-services.json); iOS: [ios/Runner/GoogleService-Info.plist](ios/Runner/GoogleService-Info.plist); runtime Firebase options are in [lib/firebase_options.dart](lib/firebase_options.dart).
- **Native build files:** Android uses Kotlin Gradle scripts (`*.gradle.kts`) under `android/` — avoid changing Gradle configuration unless necessary.
- **Lints & analysis:** Project uses `analysis_options.yaml` and `flutter_lints`; follow existing lint rules when modifying code.

**Integration points & external dependencies**
- **Firebase packages:** `firebase_core`, `firebase_auth` are direct dependencies in `pubspec.yaml` — edits to auth flows will touch `lib/firebase_options.dart` and native configs listed above.
- **Routing & state:** `go_router`, `riverpod`, `flutter_riverpod` — changes to navigation or state likely affect many files in `lib/`.
- **Platform specifics:** iOS requires CocoaPods (see `ios/Podfile`), Android is Gradle/Kotlin — CI might run platform builds separately.

**What to change vs what to avoid**
- **Change:** UI-level logic, new providers, route handlers, small Dart refactors in `lib/`.
- **Avoid:** Changing generated/native tooling without confirmation (Gradle Kotlin scripts, Podspecs, `android/` top-level Gradle settings) unless the task explicitly requires it.

**Quick examples (how to make common edits)**
- To add a new route: update [lib/routing/names.dart](lib/routing/names.dart) then add route handling in [lib/routing/router.dart](lib/routing/router.dart) and create UI in `lib/ui/`.
- To add Firebase-auth usage: import `firebase_auth` in the provider or service file, initialize via `Firebase.initializeApp()` in `lib/main.dart` if not present, and ensure native files remain intact.

**References**
- Entry and initialization: [lib/main.dart](lib/main.dart)
- Firebase options: [lib/firebase_options.dart](lib/firebase_options.dart)
- Routing: [lib/routing/router.dart](lib/routing/router.dart), [lib/routing/names.dart](lib/routing/names.dart)
- UI: [lib/ui/](lib/ui/)
- Android native config: [android/app/google-services.json](android/app/google-services.json)
- iOS native config: [ios/Runner/GoogleService-Info.plist](ios/Runner/GoogleService-Info.plist)
- Tests: [test/widget_test.dart](test/widget_test.dart)

If any section is unclear or you want deeper coverage (providers locations, common utility files, or CI scripts), tell me which area to expand and I'll update this file.
