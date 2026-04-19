import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:sgu_schedule/core/di/di_interface.dart';
import 'package:sgu_schedule/data/local/schedule_path_repository_impl.dart';
import 'package:sgu_schedule/domain/_base/di_getters.dart';
import 'package:sgu_schedule/domain/repositories/schedule_path_repository.dart';
import 'package:sgu_schedule/presentation/schedule_webview_page/cubit/schedule_webview_cubit_factory.dart';

class DIImplementation implements DIContainer {
  DIImplementation() : _getIt = GetIt.asNewInstance();

  final GetIt _getIt;

  @override
  Factories get factories => Factories(this);

  @override
  Dependencies get dependencies => Dependencies(this);

  @override
  UseCases get useCases => UseCases(this);

  @override
  T get<T extends Object>() => _getIt.get<T>();

  @override
  FutureOr<void> init() async {
    final repo = await SchedulePathRepositoryImpl.create();
    _getIt.registerSingleton<SchedulePathRepository>(repo);
    _getIt.registerLazySingleton<ScheduleWebviewCubitFactory>(
      () => ScheduleWebviewCubitFactoryImpl(this),
    );
  }
}


