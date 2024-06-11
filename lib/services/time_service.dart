import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimeService {

  String localTimezone = "";

  Future<void> initialize() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    localTimezone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimezone));
  }

  tz.TZDateTime timeAfter(Duration duration)
    => tz.TZDateTime.now(tz.local).add(duration);


  tz.TZDateTime nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var result = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute, 0);
    if (result.isBefore(now)) {
      result = result.add(const Duration(days: 1));
    }
    return result;
  }
}
