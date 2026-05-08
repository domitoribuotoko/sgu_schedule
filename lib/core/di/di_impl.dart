import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sgu_schedule/core/di/di_interface.dart';
import 'package:sgu_schedule/data/drift/schedule_ref_database.dart';
import 'package:sgu_schedule/data/local/schedule_path_repository_impl.dart';
import 'package:sgu_schedule/data/network/schedule_dio.dart';
import 'package:sgu_schedule/data/network/sgu_schedule_api.dart';
import 'package:sgu_schedule/data/repositories/schedule_reference_cache_repository_impl.dart';
import 'package:sgu_schedule/data/repositories/schedule_reference_repository_impl.dart';
import 'package:sgu_schedule/data/repositories/schedule_timetable_cache_repository_impl.dart';
import 'package:sgu_schedule/data/repositories/schedule_timetable_repository_impl.dart';
import 'package:sgu_schedule/domain/_base/di_getters.dart';
import 'package:sgu_schedule/domain/repositories/schedule_path_repository.dart';
import 'package:sgu_schedule/domain/repositories/schedule_reference_cache_repository.dart';
import 'package:sgu_schedule/domain/repositories/schedule_reference_repository.dart';
import 'package:sgu_schedule/domain/repositories/schedule_timetable_cache_repository.dart';
import 'package:sgu_schedule/domain/repositories/schedule_timetable_repository.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/get_cached_faculties_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/get_cached_groups_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/get_cached_study_forms_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/save_faculties_cache_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/save_groups_cache_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/cache/save_study_forms_cache_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule/load_schedule_timetable_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_faculties_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_groups_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_study_forms_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/load_faculties_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/load_groups_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/load_study_forms_use_case.dart';
import 'package:sgu_schedule/presentation/schedule_selection_web/cubit/schedule_selection_cubit_factory.dart';
import 'package:sgu_schedule/presentation/schedule_timetable_page/cubit/schedule_timetable_cubit_factory.dart';

class DIImplementation implements DIContainer {
  DIImplementation() : _getIt = GetIt.asNewInstance();

  final GetIt _getIt;

  @override
  Factories get factories => Factories(this);

  @override
  Dependencies get dependencies => Dependencies();

  @override
  UseCases get useCases => UseCases(this);

  @override
  T get<T extends Object>() => _getIt.get<T>();

  @override
  FutureOr<void> init() async {
    final repo = await SchedulePathRepositoryImpl.create();
    _getIt.registerSingleton<SchedulePathRepository>(repo);
    _getIt.registerSingleton<ScheduleRefDatabase>(ScheduleRefDatabase());
    _getIt.registerLazySingleton<ScheduleReferenceCacheRepository>(
      () => ScheduleReferenceCacheRepositoryImpl(
        db: _getIt.get<ScheduleRefDatabase>(),
      ),
    );
    _getIt.registerLazySingleton<ScheduleSelectionCubitFactory>(
      () => ScheduleSelectionCubitFactoryImpl(this),
    );
    _getIt.registerLazySingleton<ScheduleTimetableCubitFactory>(
      () => ScheduleTimetableCubitFactoryImpl(this),
    );

    _getIt.registerLazySingleton<Dio>(createScheduleDio);
    _getIt.registerLazySingleton<SguScheduleApi>(
      () => SguScheduleApi(_getIt.get<Dio>()),
    );
    _getIt.registerLazySingleton<ScheduleReferenceRepository>(
      () => ScheduleReferenceRepositoryImpl(api: _getIt.get<SguScheduleApi>()),
    );
    _getIt.registerLazySingleton<ScheduleTimetableCacheRepository>(
      () => ScheduleTimetableCacheRepositoryImpl(
        db: _getIt.get<ScheduleRefDatabase>(),
      ),
    );
    _getIt.registerLazySingleton<ScheduleTimetableRepository>(
      () => ScheduleTimetableRepositoryImpl(
        api: _getIt.get<SguScheduleApi>(),
      ),
    );
    _getIt.registerLazySingleton<LoadScheduleTimetableUseCaseInterface>(
      () => LoadScheduleTimetableUseCase(
        remote: _getIt.get<ScheduleTimetableRepository>(),
        cache: _getIt.get<ScheduleTimetableCacheRepository>(),
      ),
    );
    _getIt.registerLazySingleton<LoadFacultiesUseCaseInterface>(
      () => LoadFacultiesUseCase(
        repository: _getIt.get<ScheduleReferenceRepository>(),
      ),
    );
    _getIt.registerLazySingleton<LoadStudyFormsUseCaseInterface>(
      () => LoadStudyFormsUseCase(
        repository: _getIt.get<ScheduleReferenceRepository>(),
      ),
    );
    _getIt.registerLazySingleton<LoadGroupsUseCaseInterface>(
      () => LoadGroupsUseCase(
        repository: _getIt.get<ScheduleReferenceRepository>(),
      ),
    );

    _getIt.registerLazySingleton<GetCachedFacultiesUseCaseInterface>(
      () => GetCachedFacultiesUseCase(
        cache: _getIt.get<ScheduleReferenceCacheRepository>(),
      ),
    );
    _getIt.registerLazySingleton<SaveFacultiesToCacheUseCaseInterface>(
      () => SaveFacultiesToCacheUseCase(
        cache: _getIt.get<ScheduleReferenceCacheRepository>(),
      ),
    );
    _getIt.registerLazySingleton<GetCachedStudyFormsUseCaseInterface>(
      () => GetCachedStudyFormsUseCase(
        cache: _getIt.get<ScheduleReferenceCacheRepository>(),
      ),
    );
    _getIt.registerLazySingleton<SaveStudyFormsToCacheUseCaseInterface>(
      () => SaveStudyFormsToCacheUseCase(
        cache: _getIt.get<ScheduleReferenceCacheRepository>(),
      ),
    );
    _getIt.registerLazySingleton<GetCachedGroupsUseCaseInterface>(
      () => GetCachedGroupsUseCase(
        cache: _getIt.get<ScheduleReferenceCacheRepository>(),
      ),
    );
    _getIt.registerLazySingleton<SaveGroupsToCacheUseCaseInterface>(
      () => SaveGroupsToCacheUseCase(
        cache: _getIt.get<ScheduleReferenceCacheRepository>(),
      ),
    );
    _getIt.registerLazySingleton<FetchFacultiesUseCaseInterface>(
      () => FetchFacultiesUseCase(
        loadFaculties: _getIt.get<LoadFacultiesUseCaseInterface>(),
        getCached: _getIt.get<GetCachedFacultiesUseCaseInterface>(),
        saveToCache: _getIt.get<SaveFacultiesToCacheUseCaseInterface>(),
      ),
    );
    _getIt.registerLazySingleton<FetchStudyFormsUseCaseInterface>(
      () => FetchStudyFormsUseCase(
        load: _getIt.get<LoadStudyFormsUseCaseInterface>(),
        getCached: _getIt.get<GetCachedStudyFormsUseCaseInterface>(),
        save: _getIt.get<SaveStudyFormsToCacheUseCaseInterface>(),
      ),
    );
    _getIt.registerLazySingleton<FetchGroupsUseCaseInterface>(
      () => FetchGroupsUseCase(
        load: _getIt.get<LoadGroupsUseCaseInterface>(),
        getCached: _getIt.get<GetCachedGroupsUseCaseInterface>(),
        save: _getIt.get<SaveGroupsToCacheUseCaseInterface>(),
      ),
    );
  }
}


