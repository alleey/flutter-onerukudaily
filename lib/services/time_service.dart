import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimeService {

  String localTimezone = "";

  Future<void> initialize() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    localTimezone = tz.local.name;
    tz.setLocalLocation(tz.getLocation(localTimezone));
    log("local timezone -> $localTimezone");
  }

  tz.TZDateTime timeAfter(Duration duration)
    => tz.TZDateTime.now(tz.local).add(duration);

  tz.TZDateTime nextInstanceOfTime(TimeOfDay time, { bool tomorrow = false }) {

    final now = tz.TZDateTime.now(tz.local);
    var result = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute, 0);

    if (result.isBefore(now) || (tomorrow && now.year == result.year && now.month == result.month && now.day == result.day)) {
      result = result.add(const Duration(days: 1));
    }
    return result;
  }
}
