import 'package:equatable/equatable.dart';

class ScheduleGroup extends Equatable {
  const ScheduleGroup({
    required this.id,
    required this.name,
    required this.schedulePath,
  });

  final String id;
  final String name;

  /// Путь вида `/schedule/.../.../123` (без origin).
  final String schedulePath;

  @override
  List<Object?> get props => [id, name, schedulePath];
}
