import 'package:flutter/material.dart';
import 'package:sgu_schedule/presentation/_base/theme/sgu_palette.dart';
import 'package:sgu_schedule/presentation/_base/theme/sgu_theme_tokens.dart';
import 'package:sgu_schedule/presentation/_base/theme/sgu_typography.dart';

/// Светлая тема приложения, согласованная с визуалом [www.sgu.ru](https://www.sgu.ru).
abstract final class SguAppTheme {
  SguAppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.light(
      primary: SguPalette.primary,
      onPrimary: SguPalette.onPrimary,
      primaryContainer: SguPalette.primaryContainer,
      onPrimaryContainer: SguPalette.primary,
      secondary: SguPalette.secondary,
      onSecondary: SguPalette.onSecondary,
      secondaryContainer: const Color(0xFFD2E8EF),
      onSecondaryContainer: const Color(0xFF154555),
      tertiary: SguPalette.secondaryMuted,
      onTertiary: SguPalette.onPrimary,
      surface: SguPalette.surface,
      onSurface: SguPalette.onSurface,
      onSurfaceVariant: SguPalette.onSurfaceVariant,
      outline: SguPalette.outline,
      shadow: SguPalette.shadow,
      scrim: Color(0x993D455F),
      inverseSurface: SguPalette.primary,
      onInverseSurface: SguPalette.onPrimary,
      surfaceContainerHighest: SguPalette.primarySurfaceTint,
    );

    final textTheme = SguTypography.textTheme(colorScheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: SguPalette.surface,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        backgroundColor: SguPalette.primary,
        foregroundColor: SguPalette.onPrimary,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: SguPalette.onPrimary,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: SguPalette.onPrimary),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: SguThemeTokens.radiusMd,
          side: const BorderSide(color: SguPalette.outline, width: 1),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: SguThemeTokens.spacingLg,
            vertical: SguThemeTokens.spacingMd,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: SguThemeTokens.radiusSm,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SguPalette.primary,
          side: const BorderSide(color: SguPalette.primaryLight),
          padding: const EdgeInsets.symmetric(
            horizontal: SguThemeTokens.spacingLg,
            vertical: SguThemeTokens.spacingMd,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: SguThemeTokens.radiusSm,
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: SguThemeTokens.radiusMd,
          side: const BorderSide(color: SguPalette.outline),
        ),
        textStyle: textTheme.bodyMedium,
      ),
      dividerTheme: const DividerThemeData(
        color: SguPalette.outline,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: SguPalette.secondary,
        circularTrackColor: SguPalette.primarySurfaceTint,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: SguThemeTokens.radiusLg),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
    );
  }
}
