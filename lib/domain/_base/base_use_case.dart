import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:sgu_schedule/domain/_base/app_failure.dart';

abstract class BaseUseCase<Input, Output> {
  FutureOr<Either<AppFailure, Output>> call([Input params]);
}
