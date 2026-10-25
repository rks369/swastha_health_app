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
| <img src="docs/screenshots/onboarding.png" alt="Onboarding" width="220"> | <img src="docs/screenshots/login.png" alt="Login" width="220"> | <img src="docs/screenshots/user_detail.png" alt="Complete Registration" width="220"> |

| Registration BMI | | |
| :---: | :---: | :---: |
| <img src="docs/screenshots/registration_bmi.png" alt="Registration BMI" width="220"> | | |

### Physical health

| Physical Health | Add Menu | Quick Add |
| :---: | :---: | :---: |
| <img src="docs/screenshots/physical_health.png" alt="Physical Health" width="220"> | <img src="docs/screenshots/add_menu.png" alt="Add Menu" width="220"> | <img src="docs/screenshots/quick_add.png" alt="Quick Add" width="220"> |

| Metric Dashboard | Activity Permission | |
| :---: | :---: | :---: |
| <img src="docs/screenshots/metric_dashboard.png" alt="Metric Dashboard" width="220"> | <img src="docs/screenshots/activity_permission.png" alt="Activity Permission" width="220"> | |

### Mental health

| Mental Health | Just Breath | Meditation Timer |
| :---: | :---: | :---: |
| <img src="docs/screenshots/mental_health.png" alt="Mental Health" width="220"> | <img src="docs/screenshots/just_breath.png" alt="Just Breath" width="220"> | <img src="docs/screenshots/meditation.png" alt="Meditation Timer" width="220"> |

| Zen Mode | Completion | Music Player |
| :---: | :---: | :---: |
| <img src="docs/screenshots/zen_mode.png" alt="Zen Mode" width="220"> | <img src="docs/screenshots/completion.png" alt="Completion" width="220"> | <img src="docs/screenshots/music.png" alt="Music Player" width="220"> |

| Resources | | |
| :---: | :---: | :---: |
| <img src="docs/screenshots/resources.png" alt="Resources" width="220"> | | |

### Menu and profile

| Side Menu | My Account | Weight History |
| :---: | :---: | :---: |
| <img src="docs/screenshots/drawer.png" alt="Side Menu" width="220"> | <img src="docs/screenshots/my_account.png" alt="My Account" width="220"> | <img src="docs/screenshots/weight_history.png" alt="Weight History" width="220"> |

| BMI (Myself) | BMI (Someone else) | BMI Result |
| :---: | :---: | :---: |
| <img src="docs/screenshots/bmi_self.png" alt="BMI Myself" width="220"> | <img src="docs/screenshots/bmi_other.png" alt="BMI Someone else" width="220"> | <img src="docs/screenshots/bmi_result.png" alt="BMI Result" width="220"> |

| Privacy Policy | Terms & Conditions | |
| :---: | :---: | :---: |
| <img src="docs/screenshots/privacy_policy.png" alt="Privacy Policy" width="220"> | <img src="docs/screenshots/terms.png" alt="Terms & Conditions" width="220"> | |

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
