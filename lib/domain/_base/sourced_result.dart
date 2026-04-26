/// Откуда взята полезная нагрузка (как в Sauri).
enum CaseResultSource {
  /// Локальный кэш в сценарии «сначала кэш».
  cacheExpected,

  /// Кэш после сетевой ошибки (fallback).
  cacheUnexpected,

  /// Успешный ответ сети, когда сеть — ожидаемый путь.
  networkExpected,

  /// Сеть, когда планом было чтение кэша, но кэш пуст/ошибка.
  networkUnexpected,

  /// Возврат кэша при throttled force-update.
  cacheServedThrottled;

  bool get isUnexpected =>
      this == cacheUnexpected ||
      this == networkUnexpected;
}

abstract class SourcedResult<T> {
  const SourcedResult();

  CaseResultSource get source;
  T get data;
}

class SourcedData<T> implements SourcedResult<T> {
  const SourcedData({required this.source, required this.data});

  @override
  final CaseResultSource source;
  @override
  final T data;
}
