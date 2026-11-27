import 'package:flutter/material.dart';
import 'package:pharoh_lense/core/theme/app_colors.dart';

abstract class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme(
      // background: AppColors.backgroundLightColor,
      brightness: Brightness.light,
      primary: AppColors.lightprimaryColor,
      onPrimary: AppColors.lighttexteColor,
      secondary: AppColors.lightsecondaryColor,
      onSecondary: AppColors.lighttexteColor,
      error: Colors.red,
      onError: AppColors.lightsurfaceColor,
      surface: AppColors.lightbackgroundColor,
      onSurface: AppColors.lighttexteColor,
      onPrimaryContainer: AppColors.lightprimaryColor,
      primaryContainer: AppColors.lightsurfaceColor,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: .bold,
        color: AppColors.lighttexteColor,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: .bold,
        color: AppColors.lighttexteColor,
      ),
      titleSmall: TextStyle(
        fontSize: 18,
        fontWeight: .bold,
        color: AppColors.lighttexteColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: .normal,
        color: AppColors.lighttexteColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: .normal,
        color: AppColors.lighttexteColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: .normal,
        color: AppColors.lighttexteColor,
      ),
      labelLarge: TextStyle(
        fontSize: 20,
        fontWeight: .w500,
        color: AppColors.lighttexteColor,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: .normal,
        color: AppColors.lighttexteColor,
      ),
      labelSmall: TextStyle(
        fontSize: 14,
        fontWeight: .normal,
        color: AppColors.lighttexteColor,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
        side: const BorderSide(color: AppColors.lightprimaryColor),
        backgroundColor: AppColors.lightsurfaceColor,
      ),
    ),
  );
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme(
      // background: AppColors.backgroundDarkColor,
      brightness: Brightness.dark,
      primary: AppColors.darkprimaryColor,
      onPrimary: AppColors.darktexteColor,
      secondary: AppColors.darksecondaryColor,
      onSecondary: AppColors.darktexteColor,
      error: Colors.red,
      onError: AppColors.darktexteColor,
      surface: AppColors.darkbackgroundColor,
      onSurface: AppColors.darktexteColor,
      onPrimaryContainer: AppColors.darkprimaryColor,
      primaryContainer: AppColors.darksurfaceColor,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: .bold,
        color: AppColors.darktexteColor,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: .bold,
        color: AppColors.darktexteColor,
      ),
      titleSmall: TextStyle(
        fontSize: 18,
        fontWeight: .bold,
        color: AppColors.darktexteColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: .normal,
        color: AppColors.darktexteColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: .normal,
        color: AppColors.darktexteColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: .normal,
        color: AppColors.darktexteColor,
      ),
      labelLarge: TextStyle(
        fontSize: 20,
        fontWeight: .w500,
        color: AppColors.darktexteColor,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: .normal,
        color: AppColors.darktexteColor,
      ),
      labelSmall: TextStyle(
        fontSize: 14,
        fontWeight: .normal,
        color: AppColors.darktexteColor,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
        side: const BorderSide(color: AppColors.darkprimaryColor),
        backgroundColor: AppColors.darksurfaceColor,
      ),
    ),
  );
}
