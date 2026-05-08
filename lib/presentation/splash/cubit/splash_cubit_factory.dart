import 'package:flutter/material.dart';
import 'package:sgu_schedule/core/di/di_interface.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_faculties_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/telegram/get_telegram_schedule_binding_use_case.dart';
import 'package:sgu_schedule/presentation/splash/cubit/splash_cubit.dart';
import 'package:sgu_schedule/presentation/splash/services/splash_nav.dart';

abstract interface class SplashCubitFactory {
  SplashCubit create(BuildContext context);
}

final class SplashCubitFactoryImpl implements SplashCubitFactory {
  SplashCubitFactoryImpl(this._di);

  final DIContainer _di;

  @override
  SplashCubit create(BuildContext context) {
    final uc = _di.useCases;
    final cubit = SplashCubit(
      telegramGateway: _di.dependencies.telegramMiniApp,
      getTelegramBinding: _di.get<GetTelegramScheduleBindingUseCaseInterface>(),
      getLocalSnapshot: uc.getScheduleSelectionSnapshot,
      saveLocalSelection: uc.saveScheduleSelection,
      fetchFaculties: _di.get<FetchFacultiesUseCaseInterface>(),
      nav: SplashNavService(context),
    );
    cubit.init();
    return cubit;
  }
}
