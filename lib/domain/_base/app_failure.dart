enum AppFailureKind { storage, unknown }

final class AppFailure {
  const AppFailure({required this.message, this.kind = AppFailureKind.unknown});

  final String message;
  final AppFailureKind kind;
}
