# Swastha

Swastha is a Flutter health and wellness app that brings physical and mental health tracking into one place.

## Features

**Physical health**
- Step counter using the phone's hardware step sensor
- Water, calorie and sleep tracking with daily dashboards and charts
- BMI calculator (height and weight only; age and gender come from your profile)
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

<!-- Put images in docs/screenshots/ and replace the placeholders below. -->

| Onboarding | Login | Home |
| :---: | :---: | :---: |
| ![Onboarding](docs/screenshots/onboarding.png) | ![Login](docs/screenshots/login.png) | ![Home](docs/screenshots/home.png) |

| Physical Health | Steps Dashboard | Water Dashboard |
| :---: | :---: | :---: |
| ![Physical Health](docs/screenshots/physical_health.png) | ![Steps](docs/screenshots/steps.png) | ![Water](docs/screenshots/water.png) |

| Mental Health | Breathing | Music Player |
| :---: | :---: | :---: |
| ![Mental Health](docs/screenshots/mental_health.png) | ![Breathing](docs/screenshots/breathing.png) | ![Music](docs/screenshots/music.png) |

## Tech Stack

- Flutter / Dart
- State management: `flutter_bloc`
- Backend: Firebase (Auth, Firestore)
- Local storage: `sqflite`, `shared_preferences`
- Steps: `pedometer`, `permission_handler`
- Charts and gauges: `fl_chart`, `syncfusion_flutter_gauges`
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

## Permissions (Android)

`ACTIVITY_RECOGNITION` is requested at runtime so the step sensor can be read. Steps are counted from the sensor's total since boot, with a per-day baseline kept in SQLite, so steps taken while the app is closed are included the next time it opens.

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## Tests

```
flutter test
```
