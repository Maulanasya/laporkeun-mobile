import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle heading({
    double size = 28,
    Color color = AppColors.ink,
    FontWeight weight = FontWeight.bold,
    double height = 1.2,
  }) {
    return TextStyle(
      inherit: true,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  static TextStyle body({
    double size = 14,
    Color color = AppColors.ink,
    FontWeight weight = FontWeight.normal,
    double height = 1.5,
  }) {
    return TextStyle(
      inherit: true,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  static TextStyle caption({
    double size = 12,
    Color color = AppColors.ink,
    FontWeight weight = FontWeight.normal,
  }) {
    return TextStyle(
      inherit: true,
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }

  static TextStyle text(
    double size, {
    FontWeight weight = FontWeight.w600,
    Color color = AppColors.ink,
    double height = 1.35,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      inherit: true,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
