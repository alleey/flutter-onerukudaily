

import 'dart:developer';

import 'package:flutter/material.dart';

import '../blocs/reader_bloc.dart';
import '../common/constants.dart';

class ReaderNavigationObserver extends NavigatorObserver {
  final BuildContext context;

  ReaderNavigationObserver({required this.context});

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    // On back navigation from Reader clear the reader state (clear cached ruku).
    //
    if (route.settings.name == KnownRouteNames.readruku &&
        previousRoute?.settings.name == KnownRouteNames.main)
    {
      context.readerBloc.add(ClearReaderStateBlocEvent());
      log("navigting reset reader cache");
    }
  }
}

class DebugRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _logRoute(route, 'Pushed');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _logRoute(route, 'Popped');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    _logRoute(route, 'Removed');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logRoute(oldRoute, 'Replaced');
    _logRoute(newRoute, 'New Route');
  }

  void _logRoute(Route? route, String action) {
    if (route?.settings.name != null) {
      log('route: $action: ${route?.settings.name}');
    } else {
      log('route: $action: unnamed route');
    }
  }
}
