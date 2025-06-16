import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryRed = Color(0xFFFF4D4D);
  static const Color darkText = Colors.black;
  static const Color lightGrey = Color(0xFFF9F9F9);

  static ButtonStyle redButton = ElevatedButton.styleFrom(
    backgroundColor: primaryRed,
    foregroundColor: darkText,
    textStyle: const TextStyle(fontSize: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  static InputDecoration input(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: Colors.grey[700]),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
