// presentation/widgets/error_display.dart
import 'package:flutter/material.dart';
import 'package:notes_app/View/screens/constants/app_strings.dart';
import 'package:notes_app/View/screens/constants/colors.dart';

class ErrorDisplay extends StatelessWidget {
  final String message;

  const ErrorDisplay({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message.isNotEmpty ? message : AppStrings.noNotesFound,
        style: const TextStyle(
          color: AppColors.grey,
          fontSize: 16,
        ),
      ),
    );
  }
}
