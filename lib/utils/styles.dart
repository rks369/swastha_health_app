import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xff7A64E4);

const Color kSecondaryColor = Color(0xff6b6b73);

const Color kActiveSelect = Color(0xff9B99F9);

const Color kWhite = Colors.white;

const Color kInk = Color(0xff1c1b22);

const Color kBorder = Color(0xffebebf0);

const Color kSurface = Color(0xfff6f6f9);

const double kRadius = 16;

const TextStyle kHeadingTextStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w600,
  color: kInk,
);
const TextStyle kSubHeadingTextStyle = TextStyle(
  fontSize: 16,
  color: kSecondaryColor,
);

const TextStyle kNormalTextStyle = TextStyle(
  fontSize: 13,
  color: kSecondaryColor,
);
const TextStyle kLinkTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: kPrimaryColor,
);

OutlineInputBorder _inputBorder(Color color, [double width = 1]) =>
    OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    );

final kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: kWhite,
  labelStyle: const TextStyle(color: kSecondaryColor),
  floatingLabelStyle: const TextStyle(color: kPrimaryColor),
  contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
  border: _inputBorder(kBorder),
  enabledBorder: _inputBorder(kBorder),
  focusedBorder: _inputBorder(kPrimaryColor, 1.5),
  errorBorder: _inputBorder(Colors.red.shade300),
  focusedErrorBorder: _inputBorder(Colors.red.shade400, 1.5),
);

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: kPrimaryColor,
    surface: kWhite,
  ).copyWith(primary: kPrimaryColor, onSurface: kInk);
  const noTint = Colors.transparent;

  return ThemeData(
    colorScheme: scheme,
    scaffoldBackgroundColor: kWhite,
    dividerTheme: const DividerThemeData(color: kBorder, thickness: 1),
    iconTheme: const IconThemeData(color: kInk),
    appBarTheme: const AppBarTheme(
      backgroundColor: kWhite,
      foregroundColor: kInk,
      surfaceTintColor: noTint,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: kInk,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: kWhite,
      elevation: 0,
      surfaceTintColor: noTint,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadius),
        side: const BorderSide(color: kBorder),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: kWhite,
      surfaceTintColor: noTint,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: kWhite,
      surfaceTintColor: noTint,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: kBorder),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: kInk,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: kWhite,
      side: const BorderSide(color: kBorder),
      labelStyle: const TextStyle(color: kInk),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: kPrimaryColor,
      inactiveTrackColor: kPrimaryColor.withValues(alpha: 0.15),
      thumbColor: kPrimaryColor,
      overlayColor: kPrimaryColor.withValues(alpha: 0.1),
      trackHeight: 4,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: kPrimaryColor,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        side: const WidgetStatePropertyAll(BorderSide(color: kBorder)),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? kPrimaryColor.withValues(alpha: 0.1)
              : kWhite,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? kPrimaryColor
              : kSecondaryColor,
        ),
      ),
    ),
  );
}
