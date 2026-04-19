import 'package:flutter/material.dart';

/// Цвета, извлечённые из агрегированных стилей [www.sgu.ru](https://www.sgu.ru)
/// (Drupal-тема: доминируют сине-лазурная гамма и нейтраль `#3d455f` для текста).
///
/// Не зависят от [ThemeData] — только «сырые» токены для сборки [ColorScheme].
abstract final class SguPalette {
  SguPalette._();

  /// Основной корпоративный синий (частые значения `#354786`, `#4a61aa`).
  static const Color primary = Color(0xFF354786);

  /// Светлее основного — заголовки, крупные акценты (`#668bd4`).
  static const Color primaryLight = Color(0xFF668BD4);

  /// Контейнеры / подсветка блоков (`#bec7e7`, `#e6eaf8`).
  static const Color primaryContainer = Color(0xFFBEC7E7);
  static const Color primarySurfaceTint = Color(0xFFE6EAF8);

  /// Вторичный акцент — «морской» (`#6cafc9`, `#6dc2ab` на сайте).
  static const Color secondary = Color(0xFF6CAFC9);
  static const Color secondaryMuted = Color(0xFF6DC2AB);

  /// Фон страницы / карточек (`#f8f9ff`, `#f5f5f5`).
  static const Color surface = Color(0xFFF8F9FF);
  static const Color surfaceDim = Color(0xFFF5F5F5);

  /// Основной цвет текста на светлом фоне (`#3d455f`).
  static const Color onSurface = Color(0xFF3D455F);

  /// Вторичный текст / подписи (`#949abc`).
  static const Color onSurfaceVariant = Color(0xFF949ABC);

  /// Разделители / бордеры (`#cdd2e4`).
  static const Color outline = Color(0xFFCDD2E4);

  /// Доп. акцент с сайта (оливково-зелёный `#94b478`) — редкие бейджи и т.п.
  static const Color accentGreen = Color(0xFF94B478);

  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);

  static const Color shadow = Color(0x1A354786);
}
