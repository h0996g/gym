import 'package:flutter/material.dart';

/// GymPro uses a minimal 2-color brand palette:
///   Primary — indigo violet (#5B50E8)
///   Accent  — amber (#F59E0B) — used only for warnings/alerts
///
/// All other colors are adaptive neutrals (dark / light mode).
abstract final class AppColors {
  // ── Brand (2 core colors) ────────────────────────────────────────────────────
  static const Color primary = Color(0xFF5B50E8);
  static const Color primaryLight = Color(0xFF8B83F0);
  static const Color primaryDark = Color(0xFF3E35C4);

  static const Color accent = Color(0xFFF59E0B);

  // ── Semantic ────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // ── Dark Mode ───────────────────────────────────────────────────────────────
  static const Color darkBgBase = Color(0xFF0D0D14);
  static const Color darkBgSurface = Color(0xFF16161F);
  static const Color darkBgCard = Color(0xFF1E1E2A);
  static const Color darkBgElevated = Color(0xFF262636);
  static const Color darkBgSidebar = Color(0xFF111119);
  static const Color darkTextPrimary = Color(0xFFF0F0F5);
  static const Color darkTextSecondary = Color(0xFF8A8AA0);
  static const Color darkTextDisabled = Color(0xFF44445A);
  static const Color darkBorder = Color(0xFF252535);

  // ── Light Mode ──────────────────────────────────────────────────────────────
  static const Color lightBgBase = Color(0xFFF2F2F7);
  static const Color lightBgSurface = Color(0xFFFFFFFF);
  static const Color lightBgCard = Color(0xFFFFFFFF);
  static const Color lightBgElevated = Color(0xFFEEEEF8);
  static const Color lightBgSidebar = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF111127);
  static const Color lightTextSecondary = Color(0xFF6B6B85);
  static const Color lightTextDisabled = Color(0xFFB0B0C8);
  static const Color lightBorder = Color(0xFFE2E2EE);

  // ── Stat Card Gradients ─────────────────────────────────────────────────────
  static const List<Color> gradientMembers = [Color(0xFF5B50E8), Color(0xFF3E35C4)];
  static const List<Color> gradientEntries = [Color(0xFF06B6D4), Color(0xFF0284C7)];
  static const List<Color> gradientRevenue = [Color(0xFF22C55E), Color(0xFF16A34A)];
  static const List<Color> gradientStock   = [Color(0xFFF59E0B), Color(0xFFD97706)];
}
