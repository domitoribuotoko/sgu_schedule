import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sgu_schedule/presentation/_base/theme/sgu_palette.dart';

/// Типографика в стиле сайта: **Golos Text** (используется в CSS портала СГУ).
abstract final class SguTypography {
  SguTypography._();

  /// Базовая схема начертаний; цвета текста задаёт [ThemeData.colorScheme].
  static TextTheme textTheme(ColorScheme colors) {
    final base = GoogleFonts.golosTextTextTheme();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(color: colors.onSurface),
      displayMedium: base.displayMedium?.copyWith(color: colors.onSurface),
      displaySmall: base.displaySmall?.copyWith(color: colors.onSurface),
      headlineLarge: base.headlineLarge?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: base.titleSmall?.copyWith(
        color: colors.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: base.bodyLarge?.copyWith(color: colors.onSurface),
      bodyMedium: base.bodyMedium?.copyWith(color: colors.onSurface),
      bodySmall: base.bodySmall?.copyWith(color: colors.onSurfaceVariant),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      labelMedium: base.labelMedium?.copyWith(color: colors.onSurfaceVariant),
      labelSmall: base.labelSmall?.copyWith(color: colors.onSurfaceVariant),
    );
  }

  /// Для мест без [Theme]: тот же шрифт, цвет из палитры.
  static TextStyle golos({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = SguPalette.onSurface,
    double height = 1.35,
  }) {
    return GoogleFonts.golosText(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }
}
