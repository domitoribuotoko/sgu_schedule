import 'package:equatable/equatable.dart';
import 'package:sgu_schedule/domain/entities/schedule/faculty.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_group.dart';
import 'package:sgu_schedule/domain/entities/schedule/study_form.dart';

class ScheduleSelectionState extends Equatable {
  const ScheduleSelectionState({
    this.faculties = const [],
    this.studyForms = const [],
    this.groups = const [],
    this.selectedFaculty,
    this.selectedForm,
    this.selectedGroup,
    this.loadingFaculties = false,
    this.loadingForms = false,
    this.loadingGroups = false,
    this.saving = false,
    this.error,
  });

  final List<Faculty> faculties;
  final List<StudyForm> studyForms;
  final List<ScheduleGroup> groups;
  final Faculty? selectedFaculty;
  final StudyForm? selectedForm;
  final ScheduleGroup? selectedGroup;
  final bool loadingFaculties;
  final bool loadingForms;
  final bool loadingGroups;
  final bool saving;
  final String? error;

  static const Object _kKeep = Object();

  ScheduleSelectionState copyWith({
    List<Faculty>? faculties,
    List<StudyForm>? studyForms,
    List<ScheduleGroup>? groups,
    Object? selectedFaculty = _kKeep,
    Object? selectedForm = _kKeep,
    Object? selectedGroup = _kKeep,
    bool? loadingFaculties,
    bool? loadingForms,
    bool? loadingGroups,
    bool? saving,
    String? error,
    bool clearError = false,
  }) {
    return ScheduleSelectionState(
      faculties: faculties ?? this.faculties,
      studyForms: studyForms ?? this.studyForms,
      groups: groups ?? this.groups,
      selectedFaculty: _resolveNullable(selectedFaculty, this.selectedFaculty),
      selectedForm: _resolveNullable(selectedForm, this.selectedForm),
      selectedGroup: _resolveNullable(selectedGroup, this.selectedGroup),
      loadingFaculties: loadingFaculties ?? this.loadingFaculties,
      loadingForms: loadingForms ?? this.loadingForms,
      loadingGroups: loadingGroups ?? this.loadingGroups,
      saving: saving ?? this.saving,
      error: clearError ? null : (error ?? this.error),
    );
  }

  T? _resolveNullable<T>(Object? p, T? current) {
    if (identical(p, _kKeep)) {
      return current;
    }
    return p as T?;
  }

  @override
  List<Object?> get props => [
    faculties,
    studyForms,
    groups,
    selectedFaculty,
    selectedForm,
    selectedGroup,
    loadingFaculties,
    loadingForms,
    loadingGroups,
    saving,
    error,
  ];
}
