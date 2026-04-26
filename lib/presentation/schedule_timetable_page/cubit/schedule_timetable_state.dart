import 'package:equatable/equatable.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_timetable.dart';

class ScheduleTimetableState extends Equatable {
  const ScheduleTimetableState({
    this.loading = false,
    this.error = '',
    this.timetable,
  });

  final bool loading;
  final String error;
  final ScheduleTimetable? timetable;

  bool get hasError => error.isNotEmpty;

  ScheduleTimetableState copyWith({
    bool? loading,
    String? error,
    ScheduleTimetable? timetable,
    bool clearTimetable = false,
  }) {
    return ScheduleTimetableState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      timetable: clearTimetable ? null : (timetable ?? this.timetable),
    );
  }

  @override
  List<Object?> get props => [loading, error, timetable];
}
