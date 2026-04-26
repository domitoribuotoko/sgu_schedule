import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sgu_schedule/data/dto/schedule_content/schedule_content_dtos.dart';
import 'package:sgu_schedule/data/dto/schedule_reference/schedule_reference_dtos.dart';

part 'sgu_schedule_api.g.dart';

@RestApi()
abstract class SguScheduleApi {
  factory SguScheduleApi(Dio dio, {String? baseUrl}) = _SguScheduleApi;

  @GET('/v1/schedule/faculties')
  Future<FacultiesListResponseDto> getFaculties();

  @GET('/v1/schedule/faculties/{facultyId}/study-forms')
  Future<StudyFormsListResponseDto> getStudyForms(
    @Path('facultyId') String facultyId,
  );

  @GET('/v1/schedule/faculties/{facultyId}/study-forms/{formId}/groups')
  Future<GroupsListResponseDto> getGroups(
    @Path('facultyId') String facultyId,
    @Path('formId') String formId,
  );

  /// Тело страницы расписания: бек скачивает `https://www.sgu.ru{path}` (и варианты
  /// [view]) и возвращает структуру для UI. См. [docs/schedule_content_api.md].
  @GET('/v1/schedule/content')
  Future<ScheduleContentResponseDto> getScheduleContent(
    @Query('path') String path,
    @Query('view') String view,
  );
}
