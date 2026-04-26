import 'package:sgu_schedule/domain/entities/schedule/schedule_group.dart';

class CachedGroupsParams {
  const CachedGroupsParams({
    this.facultyId = '',
    this.formId = '',
  });

  final String facultyId;
  final String formId;
}

class SaveGroupsToCacheParams {
  const SaveGroupsToCacheParams({
    this.facultyId = '',
    this.formId = '',
    this.items = const <ScheduleGroup>[],
  });

  final String facultyId;
  final String formId;
  final List<ScheduleGroup> items;
}
