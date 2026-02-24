import 'package:flutter/material.dart';

class AppColors {
  // Primary palette - Google Blue inspired
  static const Color primary = Color(0xFF1A73E8);
  static const Color primaryLight = Color(0xFF4DA3FF);
  static const Color primaryDark = Color(0xFF1557B0);
  static const Color onPrimary = Colors.white;

  // Surface colors
  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceWhite = Colors.white;
  static const Color surfaceVariant = Color(0xFFE8EAED);

  // Text colors
  static const Color textPrimary = Color(0xFF202124);
  static const Color textSecondary = Color(0xFF5F6368);
  static const Color textHint = Color(0xFF9AA0A6);

  // Status colors
  static const Color error = Color(0xFFD93025);
  static const Color success = Color(0xFF1E8E3E);
  static const Color warning = Color(0xFFF9AB00);

  // Favorite
  static const Color favoriteActive = Color(0xFFFBBC04);
  static const Color favoriteInactive = Color(0xFF9AA0A6);

  // Divider
  static const Color divider = Color(0xFFDADCE0);

  // Avatar colors for contact initials
  static const List<Color> avatarColors = [
    Color(0xFF1A73E8), // Blue
    Color(0xFF34A853), // Green
    Color(0xFFEA4335), // Red
    Color(0xFFFBBC04), // Yellow
    Color(0xFF9334E6), // Purple
    Color(0xFFE8710A), // Orange
    Color(0xFF00ACC1), // Cyan
    Color(0xFFD81B60), // Pink
    Color(0xFF00897B), // Teal
    Color(0xFF5C6BC0), // Indigo
    Color(0xFF7CB342), // Light Green
    Color(0xFFE53935), // Red variant
  ];

  /// Get a consistent color for a contact based on their name
  static Color getAvatarColor(String name) {
    if (name.isEmpty) return avatarColors[0];
    int hash = 0;
    for (int i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return avatarColors[hash.abs() % avatarColors.length];
  }
}
