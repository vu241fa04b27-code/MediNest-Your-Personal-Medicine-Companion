import 'package:flutter/material.dart';

class AppColors {
  // Brand colors
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color primaryGreenDark = Color(0xFF388E3C);
  static const Color primaryGreenLight = Color(0xFFE8F5E9);

  static const Color accentBlue = Color(0xFF2196F3);
  static const Color accentBlueDark = Color(0xFF1976D2);
  static const Color accentBlueLight = Color(0xFFE3F2FD);

  // Background & Surfaces (Strictly Light Mode Only)
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color cardBgTintedGreen = Color(0xFFF1F8F4);
  static const Color cardBgTintedBlue = Color(0xFFF0F7FF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Status & Alerts
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFED6C02);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color danger = Color(0xFFD32F2F);
  static const Color dangerLight = Color(0xFFFFEBEE);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color divider = Color(0xFFE2E8F0);

  // Soft shadows
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.06),
          offset: const Offset(0, 4),
          blurRadius: 16,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withOpacity(0.10),
          offset: const Offset(0, 8),
          blurRadius: 24,
          spreadRadius: 0,
        ),
      ];
}
