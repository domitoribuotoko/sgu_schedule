import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sgu_schedule/core/di/di_interface.dart';
import 'package:sgu_schedule/domain/use_cases/schedule_reference/fetch/fetch_faculties_params.dart';
import 'package:sgu_schedule/presentation/_base/utils/app_router/route_paths.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  Future<void> _load() async {
    setState(() {
      _error = null;
    });
    final di = context.read<DiPresentationScope>();
    if (kIsWeb) {
      final snapR = await di.useCases.getScheduleSelectionSnapshot();
      if (!mounted) {
        return;
      }
      final snap = snapR.fold((_) => null, (s) => s);
      if (snap != null && snap.path.isNotEmpty) {
        if (mounted) {
          context.go(RoutePaths.scheduleTimetable);
        }
        return;
      }
    }
    final r = await di.useCases.fetchFaculties(
      const FetchFacultiesParams(
        forceUpdate: true,
        alwaysFallback: true,
      ),
    );
    if (!mounted) {
      return;
    }
    r.fold(
      (e) {
        setState(() {
          _error = e.message;
        });
      },
      (_) {
        if (mounted) {
          context.go(RoutePaths.select);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Расписание СГУ'),
              const SizedBox(height: 24),
              if (_error == null) const CircularProgressIndicator(),
              if (_error != null) ...[
                Text(_error!, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _load,
                  child: const Text('Повторить'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
