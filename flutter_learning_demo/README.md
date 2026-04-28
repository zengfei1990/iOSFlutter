# Flutter Learning Demo

This is a small Flutter demo project built for learning cross-platform basics.

## What you can learn here

- One shared codebase for iOS, Android, Web, macOS, and Windows
- Adaptive UI using Material and Cupertino widgets
- Platform awareness with `defaultTargetPlatform` and `kIsWeb`
- State updates with `StatefulWidget`
- A simple page structure that is easy to expand later

## Project structure

```text
flutter_learning_demo/
  lib/
    main.dart
  test/
    widget_test.dart
  pubspec.yaml
  analysis_options.yaml
```

## Main ideas in `lib/main.dart`

- `CrossPlatformApp`: app entry and theme setup
- `LearningHomePage`: one page showing shared UI plus platform-specific hints
- `PlatformSummaryCard`: explains what platform the app is currently running on
- `LearningTopic`: small data model used to render the topic list

## How to run

You need a local Flutter SDK first. On macOS, the simplest path is usually:

1. Install Flutter from the official site.
2. Run `flutter doctor` and finish the environment setup.
3. If you want a standalone Flutter app, in this folder run `flutter create .`
4. Then run `flutter pub get`
5. Start with `flutter run -d chrome` or an iOS simulator/device

Why `flutter create .`?

Because this workspace currently does not have the Flutter SDK installed, I created the learning files first. Running that command later will generate the missing platform runner folders such as `ios/`, `android/`, `web/`, and `macos/` without replacing your `lib/` code.

## If you want iOS add-to-app

Use the project root guide at `/Users/zf/Desktop/iOSFlutter/FLUTTER_ADD_TO_APP_GUIDE.md`.

The Flutter side is already prepared for:

- initial route `/learning`
- extra route `/about-host`
- being opened from a native iOS host page

## Suggested learning order

1. Read `lib/main.dart` from top to bottom.
2. Run the app on Web first because startup is easiest.
3. Compare how the top bar and buttons feel on iOS and Android.
4. Change colors, copy, and topic cards to get familiar with hot reload.
5. Add a second page and try navigation.
