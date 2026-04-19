import 'package:flutter/material.dart';

/// Геометрия и прочие константы визуала в духе портала (без привязки к DI).
abstract final class SguThemeTokens {
  SguThemeTokens._();

  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(6));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(10));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(14));

  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 24;

  /// Единая тень для карточек / баров — лёгкая, в тон primary.
  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x14354886),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
}
