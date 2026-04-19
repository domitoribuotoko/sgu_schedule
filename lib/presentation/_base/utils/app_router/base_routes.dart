import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BaseRoute extends GoRoute {
  BaseRoute({
    required super.path,
    super.routes,
    super.parentNavigatorKey,
    Widget Function(BuildContext _, GoRouterState state)? builder,
    Widget? child,
  }) : super(
         name: path,
         builder: (context, state) {
           assert(child != null || builder != null);
           return child ?? builder!.call(context, state);
         },
       );
}
