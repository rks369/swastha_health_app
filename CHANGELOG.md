# Changelog

All notable changes to Swastha are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.1.0] - 2026-10-25

### Added
- Date of birth (date picker) and gender are collected at registration. Age is now derived from the date of birth.
- Weight and BMI history: every saved BMI is stored per day, with a trend chart (weight or BMI) and a list showing the change from the previous entry. Available from the drawer and the BMI calculator.
- Quick-add sheet for water, sleep and calories with one-tap amount chips and a typed amount.
- Shared `AppPage` layout, a legend for the progress rings, an initials avatar, and a logout confirmation.
- Retry screen when the profile cannot be loaded at startup.
- Unit tests for the BMI/age helpers and the user model.
- App launcher icon generated from the Swastha logo.
- Stricter lint rules.

### Changed
- The BMI calculator asks for height and weight only; gender and age come from the profile. Weight can be set in 0.1 kg steps.
- Steps are counted from the phone's hardware step sensor (with the `ACTIVITY_RECOGNITION` permission) instead of a background accelerometer service. Steps taken while the app is closed are included the next time it opens.
- The four dashboards are replaced by one configurable dashboard.
- Music player moved to `audioplayers`.
- The whole app is wrapped in `SafeArea` and uses a shared theme.
- My Account validates goals as numbers, shows date of birth and gender, and no longer allows editing BMI by hand.
- Registration, OTP and sign-in screens show an in-page spinner instead of a blocking dialog and display the real error message.
- Privacy Policy and Terms pages show a "coming soon" message.

### Removed
- Profile picture upload during registration, along with `firebase_storage`, `image_picker` and `image_cropper`.
- Unused code and packages: the background step service, `audio_manager`, `sensors_plus`, `flutter_background_service`, `shared_preferences`, `flutter_zoom_drawer`, `device_info_plus`, `equatable`, `path_provider`, the unused water screen and the old `graph/` charts.
- The one-time `flutter_launcher_icons` dependency.

### Fixed
- The app crashed repeatedly at launch because a foreground service was started without the required manifest declarations.
- The OTP field was not connected to its controller, so the entered code was never sent for verification.
- Weekly charts showed the oldest seven days instead of the latest seven.
- Logging more than one kind of intake in a single save dropped all but one value.
- Failed sign-in, OTP and registration attempts left the app stuck loading with no message.
- Missing or zero goals could crash the home screen.
- Text controllers, animation controllers and audio players were not disposed.
- Typos: "Registeration", "Occured", "Thus" (weekday) and an incorrect name-validation message.

### Upgrade notes
- Existing accounts have no date of birth; the stored age is used until one is set.
- Weight history is stored in Firestore under `users/{uid}/weights`; make sure your security rules allow it.
- The local SQLite database is upgraded automatically (schema version 2).
