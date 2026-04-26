import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgu_schedule/domain/entities/schedule/faculty.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_group.dart';
import 'package:sgu_schedule/domain/entities/schedule/study_form.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/get_schedule_selection_snapshot_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/save_schedule_selection_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_faculties_params.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_faculties_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_groups_params.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_groups_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_study_forms_params.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_study_forms_use_case.dart';
import 'package:sgu_schedule/presentation/schedule_selection_web/cubit/schedule_selection_state.dart';
import 'package:sgu_schedule/presentation/schedule_selection_web/services/schedule_selection_nav_interface.dart';

class ScheduleSelectionCubit extends Cubit<ScheduleSelectionState> {
  ScheduleSelectionCubit({
    required FetchFacultiesUseCaseInterface fetchFaculties,
    required FetchStudyFormsUseCaseInterface fetchStudyForms,
    required FetchGroupsUseCaseInterface fetchGroups,
    required GetScheduleSelectionSnapshotUseCaseInterface getSelectionSnapshot,
    required SaveScheduleSelectionUseCaseInterface saveScheduleSelection,
    required ScheduleSelectionNav nav,
  }) : _fetchFaculties = fetchFaculties,
       _fetchStudyForms = fetchStudyForms,
       _fetchGroups = fetchGroups,
       _getSelectionSnapshot = getSelectionSnapshot,
       _saveScheduleSelection = saveScheduleSelection,
       _nav = nav,
       super(const ScheduleSelectionState()) {
    loadFaculties();
  }

  final FetchFacultiesUseCaseInterface _fetchFaculties;
  final FetchStudyFormsUseCaseInterface _fetchStudyForms;
  final FetchGroupsUseCaseInterface _fetchGroups;
  final GetScheduleSelectionSnapshotUseCaseInterface _getSelectionSnapshot;
  final SaveScheduleSelectionUseCaseInterface _saveScheduleSelection;
  final ScheduleSelectionNav _nav;

  /// Один раз после первого успешного ответа факультетов — подставить преф.
  var _restoredFromPrefs = false;

  Future<void> loadFaculties() async {
    emit(state.copyWith(loadingFaculties: true, clearError: true));
    final r = await _fetchFaculties(
      const FetchFacultiesParams(
        forceUpdate: false,
        alwaysFallback: true,
      ),
    );
    await r.fold<Future<void>>(
      (e) async {
        emit(
          state.copyWith(
            loadingFaculties: false,
            error: e.message,
          ),
        );
      },
      (sourced) async {
        emit(
          state.copyWith(
            loadingFaculties: false,
            faculties: sourced.data,
          ),
        );
        if (!isClosed && !_restoredFromPrefs) {
          _restoredFromPrefs = true;
          await _restoreSelectionFromSnapshot(sourced.data);
        }
      },
    );
  }

  /// Подставляет факультет, форму и группу из [schedule_selection_v1], без навигации.
  Future<void> _restoreSelectionFromSnapshot(List<Faculty> faculties) async {
    final snapR = await _getSelectionSnapshot();
    if (isClosed) {
      return;
    }
    final snap = snapR.fold((_) => null, (s) => s);
    if (snap == null || snap.facultyId.isEmpty || snap.formId.isEmpty) {
      return;
    }
    final faculty = _findById(faculties, (Faculty f) => f.id, snap.facultyId);
    if (faculty == null) {
      return;
    }
    emit(
      state.copyWith(
        selectedFaculty: faculty,
        studyForms: const <StudyForm>[],
        groups: const <ScheduleGroup>[],
        selectedForm: null,
        selectedGroup: null,
        loadingForms: true,
        clearError: true,
      ),
    );
    final fr = await _fetchStudyForms(
      FetchStudyFormsParams(
        facultyId: faculty.id,
        forceUpdate: false,
        alwaysFallback: true,
      ),
    );
    if (isClosed) {
      return;
    }
    final form = fr.fold<StudyForm?>(
      (e) {
        emit(
          state.copyWith(loadingForms: false, error: e.message),
        );
        return null;
      },
      (s) {
        final studyForm = _findById(
          s.data,
          (StudyForm x) => x.id,
          snap.formId,
        );
        emit(
          state.copyWith(
            loadingForms: false,
            studyForms: s.data,
            selectedForm: studyForm,
            groups: const <ScheduleGroup>[],
            selectedGroup: null,
            loadingGroups: studyForm != null,
            clearError: true,
          ),
        );
        return studyForm;
      },
    );
    if (form == null || isClosed) {
      return;
    }
    final gr = await _fetchGroups(
      FetchGroupsParams(
        facultyId: faculty.id,
        formId: form.id,
        forceUpdate: false,
        alwaysFallback: true,
      ),
    );
    if (isClosed) {
      return;
    }
    gr.fold(
      (e) {
        emit(
          state.copyWith(loadingGroups: false, error: e.message),
        );
      },
      (s) {
        var group = _findById(
          s.data,
          (ScheduleGroup g) => g.id,
          snap.groupId,
        );
        if (group == null && snap.path.isNotEmpty) {
          final p = _normPath(snap.path);
          for (final g in s.data) {
            if (_normPath(g.schedulePath) == p) {
              group = g;
              break;
            }
          }
        }
        emit(
          state.copyWith(
            loadingGroups: false,
            groups: s.data,
            selectedGroup: group,
            clearError: true,
          ),
        );
      },
    );
  }

  static T? _findById<T>(
    List<T> items,
    String Function(T) getId,
    String id,
  ) {
    if (id.isEmpty) {
      return null;
    }
    for (final it in items) {
      if (getId(it) == id) {
        return it;
      }
    }
    return null;
  }

  static String _normPath(String path) {
    var s = path.trim();
    if (s.isEmpty) {
      return '';
    }
    return s.startsWith('/') ? s : '/$s';
  }

  void selectFaculty(Faculty? f) {
    emit(
      state.copyWith(
        selectedFaculty: f,
        studyForms: const <StudyForm>[],
        groups: const <ScheduleGroup>[],
        selectedForm: null,
        selectedGroup: null,
        clearError: true,
      ),
    );
    if (f == null) {
      return;
    }
    _loadForms(f.id);
  }

  Future<void> _loadForms(String facultyId) async {
    emit(
      state.copyWith(loadingForms: true, clearError: true),
    );
    final r = await _fetchStudyForms(
      FetchStudyFormsParams(
        facultyId: facultyId,
        forceUpdate: false,
        alwaysFallback: true,
      ),
    );
    r.fold(
      (e) {
        emit(
          state.copyWith(loadingForms: false, error: e.message),
        );
      },
      (s) {
        emit(
          state.copyWith(
            loadingForms: false,
            studyForms: s.data,
          ),
        );
      },
    );
  }

  void selectForm(StudyForm? form) {
    emit(
      state.copyWith(
        selectedForm: form,
        groups: const <ScheduleGroup>[],
        selectedGroup: null,
        clearError: true,
      ),
    );
    final f = state.selectedFaculty;
    if (f == null || form == null) {
      return;
    }
    _loadGroups(f.id, form.id);
  }

  Future<void> _loadGroups(String facultyId, String formId) async {
    emit(state.copyWith(loadingGroups: true, clearError: true));
    final r = await _fetchGroups(
      FetchGroupsParams(
        facultyId: facultyId,
        formId: formId,
        forceUpdate: false,
        alwaysFallback: true,
      ),
    );
    r.fold(
      (e) {
        emit(
          state.copyWith(loadingGroups: false, error: e.message),
        );
      },
      (s) {
        emit(
          state.copyWith(
            loadingGroups: false,
            groups: s.data,
          ),
        );
      },
    );
  }

  void selectGroup(ScheduleGroup? g) {
    emit(
      state.copyWith(selectedGroup: g, clearError: true),
    );
  }

  Future<void> confirmAndOpenSchedule() async {
    final g = state.selectedGroup;
    final f = state.selectedFaculty;
    final form = state.selectedForm;
    if (g == null || f == null || form == null) {
      return;
    }
    emit(state.copyWith(saving: true, clearError: true));
    final res = await _saveScheduleSelection(
      SaveScheduleSelectionInput(
        facultyId: f.id,
        formId: form.id,
        group: g,
      ),
    );
    res.fold(
      (e) {
        emit(
          state.copyWith(saving: false, error: e.message),
        );
      },
      (_) {
        emit(state.copyWith(saving: false));
        _nav.goToSchedule(g);
      },
    );
  }
}
