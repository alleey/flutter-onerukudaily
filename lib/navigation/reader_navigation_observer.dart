

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

    log("navigting ${previousRoute?.settings.name} -> ${route.settings.name}");
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