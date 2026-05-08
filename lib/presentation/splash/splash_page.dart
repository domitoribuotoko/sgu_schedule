import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgu_schedule/core/di/di_interface.dart';
import 'package:sgu_schedule/presentation/splash/cubit/splash_cubit.dart';
import 'package:sgu_schedule/presentation/splash/cubit/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  SplashCubit _createCubit() {
    final di = context.read<DiPresentationScope>();
    return di.factories.splashCubitFactory.create(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _createCubit(),
      child: const _SplashBody(),
    );
  }
}

class _SplashBody extends StatelessWidget {
  const _SplashBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<SplashCubit, SplashState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Расписание СГУ'),
                  const SizedBox(height: 24),
                  if (state.loading) const CircularProgressIndicator(),
                  if (!state.loading && state.error != null) ...[
                    Text(
                      state.error!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () =>
                          context.read<SplashCubit>().onRetryTap(),
                      child: const Text('Повторить'),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
