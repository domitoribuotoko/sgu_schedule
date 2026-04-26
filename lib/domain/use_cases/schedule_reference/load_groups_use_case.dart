import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';
import 'package:sgu_schedule/domain/_base/base_use_case.dart';
import 'package:sgu_schedule/domain/entities/schedule/schedule_group.dart';
import 'package:sgu_schedule/domain/repositories/schedule_reference_repository.dart';

class LoadGroupsParams {
  const LoadGroupsParams({
    this.facultyId = '',
    this.formId = '',
  });

  final String facultyId;
  final String formId;
}

abstract interface class LoadGroupsUseCaseInterface
    extends BaseUseCase<LoadGroupsParams, List<ScheduleGroup>> {}

final class LoadGroupsUseCase implements LoadGroupsUseCaseInterface {
  LoadGroupsUseCase({required ScheduleReferenceRepository repository})
    : _repository = repository;

  final ScheduleReferenceRepository _repository;

  @override
  Future<Either<AppFailure, List<ScheduleGroup>>> call([
    LoadGroupsParams params = const LoadGroupsParams(),
  ]) {
    if (params.facultyId.isEmpty || params.formId.isEmpty) {
      return Future.value(
        const Left<AppFailure, List<ScheduleGroup>>(
          AppFailure(
            message: 'LoadGroups: не заданы facultyId / formId',
            kind: AppFailureKind.unknown,
          ),
        ),
      );
    }
    return _repository.getGroups(
      facultyId: params.facultyId,
      formId: params.formId,
    );
  }
}
