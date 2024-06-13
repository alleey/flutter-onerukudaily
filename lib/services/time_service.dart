import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart';

class TimeService {

  String localTimezone = "";

  Future<void> initialize() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }

    localTimezone = await FlutterTimezone.getLocalTimezone();

    initializeTimeZones();
    setLocalLocation(getLocation(localTimezone));
    log("local timezone -> $localTimezone");
  }

  TZDateTime now() => TZDateTime.now(local);

  TZDateTime timeAfter(Duration duration) => now().add(duration);

  TZDateTime nextInstanceOfTime(TimeOfDay time, { bool tomorrow = false }) {

    final dateNow = now();
    var result = TZDateTime(local, dateNow.year, dateNow.month, dateNow.day, time.hour, time.minute, 0);

    if (result.isBefore(dateNow) || (tomorrow && dateNow.year == result.year && dateNow.month == result.month && dateNow.day == result.day)) {
      result = result.add(const Duration(days: 1));
    }

    return result;
  }
}
