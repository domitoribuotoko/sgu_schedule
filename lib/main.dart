import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sgu_schedule/core/di/di_impl.dart';
import 'package:sgu_schedule/core/di/di_interface.dart';
import 'package:sgu_schedule/presentation/_base/theme/sgu_app_theme.dart';
import 'package:sgu_schedule/presentation/_base/utils/app_router/app_router.dart'
    show AppRouter;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final di = await _initDiContainer();
  runApp(SguScheduleApp(di: di));
}

class SguScheduleApp extends StatefulWidget {
  const SguScheduleApp({required this.di, super.key});

  final DIContainer di;

  @override
  State<SguScheduleApp> createState() => _SguScheduleAppState();
}

class _SguScheduleAppState extends State<SguScheduleApp> {
  final GoRouter _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<DiPresentationScope>.value(
      value: widget.di,
      child: MaterialApp.router(
        title: 'Расписание СГУ',
        theme: SguAppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}

Future<DIContainer> _initDiContainer() async {
  final di = DIImplementation();
  await di.init();
  return di;
}
