import 'package:flutter/material.dart';
import 'package:sgu_schedule/core/di/di_interface.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_faculties_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_groups_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_study_forms_use_case.dart';
import 'package:sgu_schedule/domain/use_cases/telegram/save_telegram_schedule_binding_use_case.dart';
import 'package:sgu_schedule/presentation/schedule_selection_web/cubit/schedule_selection_cubit.dart';
import 'package:sgu_schedule/presentation/schedule_selection_web/services/schedule_selection_nav.dart';

abstract interface class ScheduleSelectionCubitFactory {
  ScheduleSelectionCubit create(BuildContext context);
}

final class ScheduleSelectionCubitFactoryImpl
    implements ScheduleSelectionCubitFactory {
  ScheduleSelectionCubitFactoryImpl(this._di);

  final DIContainer _di;

  @override
  ScheduleSelectionCubit create(BuildContext context) {
    final uc = _di.useCases;
    return ScheduleSelectionCubit(
      fetchFaculties: _di.get<FetchFacultiesUseCaseInterface>(),
      fetchStudyForms: _di.get<FetchStudyFormsUseCaseInterface>(),
      fetchGroups: _di.get<FetchGroupsUseCaseInterface>(),
      getSelectionSnapshot: uc.getScheduleSelectionSnapshot,
      saveScheduleSelection: uc.saveScheduleSelection,
      saveTelegramBinding: _di.get<SaveTelegramScheduleBindingUseCaseInterface>(),
      telegramGateway: _di.dependencies.telegramMiniApp,
      nav: ScheduleSelectionNavService(context),
    );
  }
}
