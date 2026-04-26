import 'package:sgu_schedule/domain/entities/schedule/study_form.dart';

class CachedStudyFormsParams {
  const CachedStudyFormsParams({this.facultyId = ''});

  final String facultyId;
}

class SaveStudyFormsToCacheParams {
  const SaveStudyFormsToCacheParams({
    this.facultyId = '',
    this.items = const <StudyForm>[],
  });

  final String facultyId;
  final List<StudyForm> items;
}
