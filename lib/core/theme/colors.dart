import 'package:flutter/material.dart';

class AppColors {
  // ── Primary palette ───────────────────────────────────────────────
  static const Color primary    = Color(0xFF7B68EE); // soft indigo
  static const Color secondary  = Color(0xFFFF6B9D); // coral pink
  static const Color background = Color(0xFFFFF8F2); // warm cream
  static const Color card       = Color(0xFFFFFFFF);
  static const Color done       = Color(0xFFB5F0C8); // mint green
  static const Color text       = Color(0xFF2D2356); // deep purple-navy
  static const Color subtitle   = Color(0xFF9089AC); // muted lavender-grey
  static const Color deleteRed  = Color(0xFFFF7070); // soft coral red

  // ── Pastel accent swatches (task cards, avatars, chips) ──────────
  static const Color pastelCoral    = Color(0xFFFFB5A7);
  static const Color pastelMint     = Color(0xFFB5EAD7);
  static const Color pastelLavender = Color(0xFFD4C5F9);
  static const Color pastelSunshine = Color(0xFFFFF0A5);
  static const Color pastelSky      = Color(0xFFB5D8F7);
  static const Color pastelPeach    = Color(0xFFFFCBAA);
  static const Color pastelRose     = Color(0xFFFFD6E8);
  static const Color pastelTeal     = Color(0xFFB2F0ED);

  // ── Member color wheel (pastel-safe) ─────────────────────────────
  static const List<Color> memberColors = [
    Color(0xFF7B68EE), // indigo
    Color(0xFFFF6B9D), // coral pink
    Color(0xFF52C78B), // mint green
    Color(0xFFFFAA57), // warm orange
    Color(0xFF56CCF2), // sky blue
    Color(0xFFBB8FCE), // soft purple
  ];
}
