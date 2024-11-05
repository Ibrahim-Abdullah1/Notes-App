import 'package:flutter/material.dart';
import 'package:notes_app/View/screens/constants/colors.dart';

class AppStyles {
  static const TextStyle formLabelTextStyle = TextStyle(fontSize: 18);
  static const TextStyle buttonTextStyle = TextStyle(fontSize: 18);

  static InputDecoration inputDecoration({
    required String labelText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: formLabelTextStyle,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      prefixIcon: Icon(prefixIcon),
    );
  }

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(
      vertical: 12.0,
      horizontal: 24.0,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  );

  static const TextStyle noteTitleTextStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle noteBodyTextStyle = TextStyle(
    fontSize: 18,
    height: 1.5,
    color: AppColors.black,
  );

  static const TextStyle timestampTextStyle = TextStyle(
    fontSize: 14,
    color: AppColors.grey,
  );

  static const IconThemeData appBarIconTheme = IconThemeData(color: AppColors.white);

  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(24.0));

  static const EdgeInsets cardPadding = EdgeInsets.all(24.0);

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [AppColors.gradientStart, AppColors.gradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 18,
    height: 1.5,
    color: AppColors.black,
  );

}
