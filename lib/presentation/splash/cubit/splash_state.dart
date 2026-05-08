import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  const SplashState({
    this.loading = true,
    this.error,
  });

  final bool loading;
  final String? error;

  static const Object _kKeep = Object();

  SplashState copyWith({
    bool? loading,
    Object? error = _kKeep,
    bool clearError = false,
  }) {
    return SplashState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error == _kKeep ? this.error : error as String?),
    );
  }

  @override
  List<Object?> get props => [loading, error];
}
