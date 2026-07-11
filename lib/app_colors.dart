import 'package:flutter/material.dart';

abstract final class AppColors {
  // ==========================================================
  // BRAND
  // ==========================================================

  static const Color primary = Color(0xFF536FE7);
  static const Color primarySoft = Color(0xFFEEF2FF);

  static const Color accent = Color(0xFFFF7A59);
  static const Color accentSoft = Color(0xFFFFEEE8);

  static const Color activeButtonText = Color(0xFF172033);

  // ==========================================================
  // BACKGROUND
  // ==========================================================

  static const Color background = Color(0xFFF8F9FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);

  static const Color divider = Color(0xFFE8ECF3);
  static const Color border = Color(0xFFE8ECF3);

  // ==========================================================
  // TEXT
  // ==========================================================

  static const Color heading = Color(0xFF172033);
  static const Color body = Color(0xFF667085);
  static const Color caption = Color(0xFF98A2B3);

  static const Color white = Colors.white;
  static const Color black = Color(0xFF111827);

  // ==========================================================
  // STATUS
  // ==========================================================

  static const Color success = Color(0xFF4BA66A);
  static const Color successLight = Color(0xFFE2F4E9);

  static const Color warning = Color(0xFFD69238);
  static const Color warningLight = Color(0xFFFFF0D4);

  static const Color error = Color(0xFFD95C67);
  static const Color errorLight = Color(0xFFFFE3E6);

  static const Color info = Color(0xFF536FE7);
  static const Color infoLight = Color(0xFFEEF2FF);

  // ==========================================================
  // GREY SCALE
  // ==========================================================

  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // ==========================================================
  // ICONS
  // ==========================================================

  static const Color iconPrimary = primary;
  static const Color iconSecondary = body;
  static const Color iconMuted = caption;
  static const Color iconDisabled = grey400;
  static const Color iconWhite = white;

  // ==========================================================
  // BUTTONS
  // ==========================================================

  static const Color buttonPrimary = primary;
  static const Color buttonPrimaryHover = Color(0xFF425DD5);
  static const Color buttonPrimaryDisabled = grey300;

  static const Color buttonSecondary = accent;
  static const Color buttonSecondaryHover = Color(0xFFCC7A00);

  // ==========================================================
  // INPUT
  // ==========================================================

  static const Color inputFill = white;
  static const Color inputBorder = border;
  static const Color inputFocused = primary;
  static const Color inputError = error;

  // ==========================================================
  // DASHBOARD COLORS
  // ==========================================================

  static const Color attendance = Color(0xFF43A047); // Emerald Green
  static const Color income = Color(0xFF536FE7); // Brand Blue
  static const Color expense = Color(0xFFE05D6F); // Soft Rose Red
  static const Color student = Color(0xFF7C6AE6); // Soft Indigo Purple
  static const Color notification = Color(0xFFE6A23C); // Warm Amber

  static const Color seatAvailable = success;
  static const Color seatOccupied = error;

  // ==========================================================
  // MEMBER COLORS
  // ==========================================================

  static const Color memberActive = Color(0xFF4BA66A);
  static const Color memberActiveSoft = Color(0xFFE2F4E9);

  static const Color memberExpiring = Color(0xFFD69238);
  static const Color memberExpiringSoft = Color(0xFFFFF0D4);

  static const Color memberExpired = Color(0xFFD95C67);
  static const Color memberExpiredSoft = Color(0xFFFFE3E6);

  static const Color memberPending = Color(0xFF64748B);
  static const Color memberPendingSoft = Color(0xFFEFF3F7);

  // ==========================================================
  // EXTRA
  // ==========================================================

  static const Color whatsapp = Color(0xFF52C96B);
  static const Color purple = Color(0xFF9364E8);

  static const Color shadow = Color(0x14000000);

  static const Color primaryOpacity10 = Color(0x1A536FE7);
  static const Color primaryOpacity20 = Color(0x33536FE7);

  static const Color secondaryOpacity10 = Color(0x1AF59E0B);
  static const Color secondaryOpacity20 = Color(0x33F59E0B);

  // ==========================================================
  // FORM
  // ==========================================================

  static const Color formLabel = Color(0xFF6B7280); // Soft gray
  static const Color formLabelLight = Color(0xFF98A2B3);
}
