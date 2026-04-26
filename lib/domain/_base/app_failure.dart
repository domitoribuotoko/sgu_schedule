enum AppFailureKind { storage, network, unknown }

final class AppFailure {
  const AppFailure({required this.message, this.kind = AppFailureKind.unknown});

  final String message;
  final AppFailureKind kind;
}
