# Changelog

All notable changes to Swastha are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2.0.1] - 2026-10-25

### Added
- `LICENSE`: PolyForm Noncommercial 1.0.0, so the code can be used for non-commercial purposes only.
- A pop-up on the Physical tab explains why physical-activity access is needed before the system permission prompt appears. It is shown once per app session; the existing banner remains for allowing it later.
- Sample Privacy Policy and Terms & Conditions pages on a shared `LegalPage` layout, replacing the "coming soon" messages. The text is placeholder and must be replaced with reviewed content before a public release.

## [2.0.0] - 2026-10-25

### Added
- BMI calculator for **Myself** or **Someone else**. For yourself it uses the gender and date-of-birth age from your profile; for someone else it asks for gender (selectable cards) and age (− / + stepper). Results for someone else are not saved to your history.
- Reusable BMI result dialog, with neutral wording for other people and a note that adult ranges do not apply under 18.
- Floating pill-style bottom switch (icon above label) with a sliding highlight, docked at the bottom centre.
- Shared design tokens and one app-wide theme (`buildAppTheme`) covering cards, dialogs, sheets, sliders, chips and segmented buttons.
- Package-free `RingGauge`, `ProgressBar`, `StepperCard` and `GenderSelector` widgets.

### Changed
- The whole UI is restyled to a flat, minimal look: white background, hairline borders, no elevation, quieter typography and the brand purple kept as the only accent.
- The purple header and rounded sheet are replaced by a plain centred title with a simple back arrow on every page.
- The side menu is now a standard Material `Drawer` with a light layout; menu items close the drawer before opening a screen.
- Metric colours refreshed: water sky blue, steps soft green, sleep muted slate-indigo, calories warm orange. Sleep was previously red.
- Progress rings now start at 12 o'clock; the 7-day charts use a light card with bars in each metric's colour.
- Dashboard tiles use a tinted icon and a thin progress bar.
- Resources and Music Player use the shared page layout; the breathing timer ring is thinner and the zen-mode animation is softer.
- Weight and height cards share one style with the new age and gender cards.

### Removed
- `syncfusion_flutter_gauges` (community-licence) and `flutter_advanced_drawer`; `fl_chart` is kept for the bar and line charts.
- Unused `barColor` and `kGrey` constants and the bottom navigation bar theme.

### Fixed
- Overflow in the bottom switch.
- Possible hero-tag collision between the menu button and the add (+) button when opening a screen from the Physical tab.

### Upgrade notes
- Run `flutter pub get` after pulling; two dependencies were removed.
- For Firebase App Distribution, upload an APK (`flutter build apk --release`). An AAB is only accepted when the Firebase project is linked to Google Play.
- Bump the build number in `pubspec.yaml` for every upload.

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
