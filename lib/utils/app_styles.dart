import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  // Border Radii - 20px rounded cards as required
  static const double cardRadiusValue = 20.0;
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(cardRadiusValue));
  static const BorderRadius buttonRadius = BorderRadius.all(Radius.circular(16.0));
  static const BorderRadius pillRadius = BorderRadius.all(Radius.circular(30.0));

  // Typography for high readability & elderly eyes
  static const TextStyle headingLarge = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.25,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.45,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.45,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.2,
  );

  static const TextStyle badgeText = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  // Standard Card Decoration
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: cardRadius,
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: AppColors.cardShadow,
      );

  static BoxDecoration get greenTintCardDecoration => BoxDecoration(
        color: AppColors.cardBgTintedGreen,
        borderRadius: cardRadius,
        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3), width: 1.2),
        boxShadow: AppColors.cardShadow,
      );

  static BoxDecoration get blueTintCardDecoration => BoxDecoration(
        color: AppColors.cardBgTintedBlue,
        borderRadius: cardRadius,
        border: Border.all(color: AppColors.accentBlue.withOpacity(0.3), width: 1.2),
        boxShadow: AppColors.cardShadow,
      );
}
