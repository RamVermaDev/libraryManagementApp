import 'package:flutter/material.dart';

class AppColors {
  // ==========================================================
  // BRAND COLORS (Original - Do Not Change)
  // ==========================================================

  static const Color primary = Color(0xFF1E3A8A);
  static const Color secondary = Color(0xFFF59E0B);

  // ==========================================================
  // BACKGROUND
  // ==========================================================

  static const Color background = Color(0xFFF8FAFC);
  static const Color card = Color(0xFFFFF3CB);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFFDFDFD);
  static const Color divider = Color(0xFFE5E7EB);

  static const Color bottomBar = Color(0xFFD0E6FF);

  // ==========================================================
  // TEXT COLORS
  // ==========================================================

  static const Color heading = Color(0xFF4A4A4A);
  static const Color body = Color(0xFF4B5563);
  static const Color caption = Color(0xFF9CA3AF);

  static const Color white = Colors.white;
  static const Color black = Color(0xFF111827);

  // ==========================================================
  // STATUS COLORS
  // ==========================================================

  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFE8F8ED);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFDECEC);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFF7E6);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFEAF3FF);

  // ==========================================================
  // PRIMARY SHADES
  // ==========================================================

  static const Color primary50 = Color(0xFFEAF1FF);
  static const Color primary100 = Color(0xFFD4E2FF);
  static const Color primary200 = Color(0xFFA8C4FF);
  static const Color primary300 = Color(0xFF7CA6FF);
  static const Color primary400 = Color(0xFF5088FF);
  static const Color primary500 = primary;
  static const Color primary600 = Color(0xFF19317A);
  static const Color primary700 = Color(0xFF142863);
  static const Color primary800 = Color(0xFF10204D);
  static const Color primary900 = Color(0xFF0B1738);

  // ==========================================================
  // SECONDARY SHADES
  // ==========================================================

  static const Color secondary50 = Color(0xFFFFFAEB);
  static const Color secondary100 = Color(0xFFFFF3CB);
  static const Color secondary200 = Color(0xFFFDE68A);
  static const Color secondary300 = Color(0xFFFCD34D);
  static const Color secondary400 = Color(0xFFFBBF24);
  static const Color secondary500 = secondary;
  static const Color secondary600 = Color(0xFFD97706);
  static const Color secondary700 = Color(0xFFB45309);
  static const Color secondary800 = Color(0xFF92400E);
  static const Color secondary900 = Color(0xFF78350F);

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
  // ICON COLORS
  // ==========================================================

  static const Color iconPrimary = primary;
  static const Color iconSecondary = grey600;
  static const Color iconDisabled = grey400;
  static const Color iconWhite = Colors.white;

  // ==========================================================
  // BUTTON COLORS
  // ==========================================================

  static const Color buttonPrimary = primary;
  static const Color buttonPrimaryHover = primary600;
  static const Color buttonPrimaryDisabled = grey300;

  static const Color buttonSecondary = secondary;
  static const Color buttonSecondaryHover = secondary600;

  static const Color activeButton = Color(0xFFF5A623);
  static const Color totalButton = Color(0xFF4A90E2);

  static const Color activeButtonText = Color(0xFF85008E);

  // ==========================================================
  // INPUT FIELDS
  // ==========================================================

  static const Color inputFill = Colors.white;
  static const Color inputBorder = grey300;
  static const Color inputFocused = primary;
  static const Color inputError = error;

  // ==========================================================
  // BADGES
  // ==========================================================

  static const Color badgeSuccess = success;
  static const Color badgeWarning = warning;
  static const Color badgeError = error;
  static const Color badgeInfo = info;

  // ==========================================================
  // SHADOW
  // ==========================================================

  static const Color shadow = Color(0x1A000000);

  // ==========================================================
  // TRANSPARENT COLORS
  // ==========================================================

  static const Color primaryOpacity10 = Color(0x1A1E3A8A);
  static const Color primaryOpacity20 = Color(0x331E3A8A);

  static const Color secondaryOpacity10 = Color(0x1AF59E0B);
  static const Color secondaryOpacity20 = Color(0x33F59E0B);

  // ==========================================================
  // SPECIAL COLORS FOR DASHBOARD
  // ==========================================================

  static const Color attendance = Color(0xFF10B981);
  static const Color income = Color(0xFF2563EB);
  static const Color expense = Color(0xFFDC2626);
  static const Color student = Color(0xFF7C3AED);
  static const Color notification = Color(0xFFF97316);
  static const Color seatAvailable = Color(0xFF16A34A);
  static const Color seatOccupied = Color(0xFFEF4444);

  static const Color container = Color.fromARGB(67, 211, 188, 255);
}


// 🔵 Primary Blue → Trust, security, professionalism.
// 🟡 Amber → Attention, energy, premium highlights.
// ⚪ White & Light Backgrounds → Clean, spacious UI.
// ⚫ Gray Scale → Consistent typography and dividers.
// 🟢 Success → Payments, attendance, verification.
// 🔴 Error → Validation, failed actions.
// 🔵 Info → Notifications, updates.
// 🟠 Warning → Pending fees, reminders.