# Swastha

Swastha is a Flutter health and wellness app that brings physical and mental health tracking into one place.

## Features

**Physical health**
- Background step counter using the accelerometer
- Water, calorie and sleep tracking with daily dashboards and charts
- BMI calculator

**Mental health**
- Guided breathing exercises
- Meditation with a countdown timer
- Music player with relaxing tracks

**Account**
- Phone OTP and Google sign-in (Firebase Auth)
- Profile and user details stored in Cloud Firestore, with profile photo upload to Firebase Storage
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
- Backend: Firebase (Auth, Firestore, Storage)
- Local storage: `sqflite`, `shared_preferences`
- Background work: `flutter_background_service`, `sensors_plus`
- Charts and gauges: `fl_chart`, `syncfusion_flutter_gauges`
- Audio: `audioplayers`, `audio_manager`

## Project Structure

```
lib/
├── Bloc/        # AuthCubit, BreathCubit
├── database/    # SQLite helper
├── graph/       # Chart widgets
├── models/      # Data models
├── screens/     # Authentication, home, dashboards, side drawer
├── services/    # Snackbars, navigation helpers
├── utils/       # Styles, constants, extensions
└── widgets/     # Reusable widgets
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

The step counter runs as a foreground service, so the app declares `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_SPECIAL_USE` and `POST_NOTIFICATIONS`.
