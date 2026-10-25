# Swastha

Swastha is a Flutter health and wellness app that brings physical and mental health tracking into one place, in a flat, minimal interface.

## Features

**Physical health**
- Step counter using the phone's hardware step sensor
- Water, calorie and sleep tracking with daily dashboards and charts
- BMI calculator for yourself (age and gender come from your profile) or for someone else (pick gender and age)
- Weight and BMI history with a trend chart

**Mental health**
- Guided breathing exercises
- Meditation with a countdown timer
- Music player with relaxing tracks

**Account**
- Phone OTP and Google sign-in (Firebase Auth), with date of birth and gender captured at registration
- Profile and user details stored in Cloud Firestore
- Local history stored on device with SQLite

## Screenshots

<!--
Put images in docs/screenshots/ with the file names below.
Use light mode, one phone size for every shot, and realistic data.
-->

### Onboarding and sign-in

| Onboarding | Login | Complete Registration |
| :---: | :---: | :---: |
| ![Onboarding](docs/screenshots/onboarding.png) | ![Login](docs/screenshots/login.png) | ![Complete Registration](docs/screenshots/user_detail.png) |

| Registration BMI | | |
| :---: | :---: | :---: |
| ![Registration BMI](docs/screenshots/registration_bmi.png) | | |

### Physical health

| Physical Health | Add Menu | Quick Add |
| :---: | :---: | :---: |
| ![Physical Health](docs/screenshots/physical_health.png) | ![Add Menu](docs/screenshots/add_menu.png) | ![Quick Add](docs/screenshots/quick_add.png) |

| Metric Dashboard | Activity Permission | |
| :---: | :---: | :---: |
| ![Metric Dashboard](docs/screenshots/metric_dashboard.png) | ![Activity Permission](docs/screenshots/activity_permission.png) | |

### Mental health

| Mental Health | Just Breath | Meditation Timer |
| :---: | :---: | :---: |
| ![Mental Health](docs/screenshots/mental_health.png) | ![Just Breath](docs/screenshots/just_breath.png) | ![Meditation Timer](docs/screenshots/meditation.png) |

| Zen Mode | Completion | Music Player |
| :---: | :---: | :---: |
| ![Zen Mode](docs/screenshots/zen_mode.png) | ![Completion](docs/screenshots/completion.png) | ![Music Player](docs/screenshots/music.png) |

| Resources | | |
| :---: | :---: | :---: |
| ![Resources](docs/screenshots/resources.png) | | |

### Menu and profile

| Side Menu | My Account | Weight History |
| :---: | :---: | :---: |
| ![Side Menu](docs/screenshots/drawer.png) | ![My Account](docs/screenshots/my_account.png) | ![Weight History](docs/screenshots/weight_history.png) |

| BMI (Myself) | BMI (Someone else) | BMI Result |
| :---: | :---: | :---: |
| ![BMI Myself](docs/screenshots/bmi_self.png) | ![BMI Someone else](docs/screenshots/bmi_other.png) | ![BMI Result](docs/screenshots/bmi_result.png) |

| Privacy Policy | Terms & Conditions | |
| :---: | :---: | :---: |
| ![Privacy Policy](docs/screenshots/privacy_policy.png) | ![Terms & Conditions](docs/screenshots/terms.png) | |

## Tech Stack

- Flutter / Dart
- State management: `flutter_bloc`
- Backend: Firebase (Auth, Firestore)
- Local storage: `sqflite`
- Steps: `pedometer`, `permission_handler`
- Charts: `fl_chart`; progress rings and bars are drawn with Flutter's own `CustomPaint`, so there is no commercial charting dependency
- UI: Material 3 with a single shared theme (`lib/utils/styles.dart`)
- Audio: `audioplayers`

## Project Structure

```
lib/
├── Bloc/        # AuthCubit, BreathCubit
├── database/    # SQLite helper
├── models/      # Data models, Metric enum
├── screens/     # Authentication, home, dashboards, side drawer
├── services/    # Step tracker, navigation helpers
├── utils/       # Styles, constants, BMI/age helpers
└── widgets/     # Reusable widgets (AppPage, rings, quick-add sheet)
```

## Getting Started

### Prerequisites
- Flutter SDK (Dart `^3.13.7`)
- Android Studio or VS Code with the Flutter extension
- A Firebase project

### Setup

1. Clone the repository and install dependencies:
   ```
   flutter pub get
   ```
2. Add your Firebase config:
   - Android: place `google-services.json` in `android/app/`
   - Regenerate `lib/firebase_options.dart` with `flutterfire configure`
3. Run the app:
   ```
   flutter run
   ```

### Release build

Create `android/key.properties` with `keyAlias`, `keyPassword`, `storeFile` and `storePassword`, then:

```
flutter build apk --release
```

To skip x86 emulator code and keep one installable file, build for ARM only:

```
flutter build apk --release --target-platform android-arm,android-arm64
```

### Sharing with testers (Firebase App Distribution)

Upload the APK from `build/app/outputs/flutter-apk/app-release.apk`. An AAB is only accepted if the Firebase project is linked to Google Play. Increase the build number in `pubspec.yaml` (the part after `+`) before every upload.

## Permissions (Android)

`ACTIVITY_RECOGNITION` is requested at runtime so the step sensor can be read. Steps are counted from the sensor's total since boot, with a per-day baseline kept in SQLite, so steps taken while the app is closed are included the next time it opens.

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## Tests

```
flutter test
```
