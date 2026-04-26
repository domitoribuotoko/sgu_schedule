import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sgu_schedule/presentation/_base/utils/app_router/route_paths.dart';

/// Глобальный [RoutingConfig.redirect]: Mini App с `?tgWebAppData=...` и путём `/`
/// не должен открывать [RoutePaths.schedule] ("/"), иначе теряется сценарий splash.
FutureOr<String?> telegramTgWebGlobalRedirect(
  BuildContext context,
  GoRouterState state,
) {
  if (!kIsWeb) {
    return null;
  }
  final u = state.uri;
  if (u.path == '/' && u.queryParameters.containsKey('tgWebAppData')) {
    return u.hasQuery
        ? '${RoutePaths.splash}?${u.query}'
        : RoutePaths.splash;
  }
  return null;
}

void telegramTgWebOnException(
  BuildContext context,
  GoRouterState state,
  GoRouter router,
) {
  if (!kIsWeb) {
    return;
  }
  if (state.error is! GoException) {
    return;
  }
  final msg = state.error.toString();
  if (!msg.contains('no routes')) {
    return;
  }
  final b = Uri.base;
  if (b.queryParameters.containsKey('tgWebAppData')) {
    final target = b.hasQuery
        ? '${RoutePaths.splash}?${b.query}'
        : RoutePaths.splash;
    router.go(target);
  } else {
    router.go(RoutePaths.splash);
  }
}
