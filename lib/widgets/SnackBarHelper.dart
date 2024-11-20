import 'package:flutter/material.dart';
import 'package:project_1_btl/utils/constants.dart'; // Adjust the import path as needed

class SnackBarHelper {
  // Static method to show a custom SnackBar with configuration
  static void showSnackBar({
    required BuildContext context,
    required String message,
    Color backgroundColor = const Color(0xFFFF9D3D),
    Color textColor = Colors.white,
    double fontSize = 16.0,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontFamily: "RobotoRegular",
            fontWeight: FontWeight.w600
        ),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.fixed, // Keeps the SnackBar at the bottom
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // No border radius
      duration: Duration(seconds: 1), // Duration for how long the SnackBar stays visible
    );

    // Show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Simplified method to show a SnackBar with just the message
  static void showSimpleSnackBar({
    required BuildContext context,
    required String message,
  }) {
    showSnackBar(
      context: context,
      message: message,
      // Using default values for the other parameters
    );
  }
}
