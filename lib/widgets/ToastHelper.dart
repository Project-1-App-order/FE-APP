import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_1_btl/utils/constants.dart'; // Adjust the import path as needed

class ToastHelper {
  // Static method to show a toast with custom configuration
  static void showToast({
    required String message,
    Color backgroundColor = const Color(0xFFFF9D3D),
    Color textColor = Colors.white,
    ToastGravity gravity = ToastGravity.BOTTOM,
    double fontSize = 16.0,
    Toast toastLength = Toast.LENGTH_SHORT,
  }) {
    // Attempt to set a square shape by modifying the backgroundColor to a non-rounded appearance
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: backgroundColor, // Background color, no border radius
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}
