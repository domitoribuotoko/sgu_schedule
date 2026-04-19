import 'dart:async';

import 'package:sgu_schedule/domain/_base/di_getters.dart';

abstract class DiPresentationScope {
  Factories get factories;

  Dependencies get dependencies;

  UseCases get useCases;
}

abstract class DIContainer extends DiPresentationScope {
  T get<T extends Object>();

  FutureOr<void> init();
}
