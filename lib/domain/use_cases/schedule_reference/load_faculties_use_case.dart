import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/entities/schedule/faculty.dart';
import 'package:sgu_schedule/domain/repositories/schedule_reference_repository.dart';
abstract interface class LoadFacultiesUseCaseInterface
    extends BaseUseCase<Unit, List<Faculty>> {}

final class LoadFacultiesUseCase implements LoadFacultiesUseCaseInterface {
  LoadFacultiesUseCase({required ScheduleReferenceRepository repository})
    : _repository = repository;

  final ScheduleReferenceRepository _repository;

  @override
  Future<Either<AppFailure, List<Faculty>>> call([Unit params = unit]) {
    return _repository.getFaculties();
  }
}
