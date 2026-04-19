import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Обёртка над [BlocBuilder] с селекторами: перестраивает виджет только при
/// изменении хотя бы одного из значений [selectors(state)].
/// По мотивам `sauri_flutter/.../bloc_multi_selector.dart`.
class BlocMultiSelector<C extends StateStreamable<S>, S>
    extends StatelessWidget {
  const BlocMultiSelector({
    super.key,
    required this.selectors,
    this.builder,
    this.cubitBuilder,
    this.buildWhen,
  }) : assert(
         builder != null || cubitBuilder != null,
         'Нужен builder или cubitBuilder',
       );

  final List<dynamic> Function(S state) selectors;
  final bool Function(List<dynamic> previous, List<dynamic> current)? buildWhen;
  final Widget Function(BuildContext context, S state)? builder;
  final Widget Function(BuildContext context, C cubit, S state)? cubitBuilder;

  static const DeepCollectionEquality _equality = DeepCollectionEquality();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, S>(
      buildWhen: (previous, current) {
        final previousValues = selectors(previous);
        final currentValues = selectors(current);

        if (buildWhen != null) {
          return buildWhen!(previousValues, currentValues);
        }

        if (previousValues.length != currentValues.length) {
          return true;
        }

        for (var i = 0; i < previousValues.length; i++) {
          if (!_identity(previousValues[i], currentValues[i])) {
            return true;
          }
        }

        return false;
      },
      builder: (context, state) {
        if (builder != null) {
          return builder!(context, state);
        }
        final cubit = context.read<C>();
        return cubitBuilder!(context, cubit, state);
      },
    );
  }

  static bool _identity(dynamic a, dynamic b) {
    if (identical(a, b)) {
      return true;
    }
    return _equality.equals(a, b);
  }
}
