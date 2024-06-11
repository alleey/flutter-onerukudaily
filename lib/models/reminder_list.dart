import 'dart:convert';

import 'package:flutter/material.dart';

import '../common/time_of_day_extensions.dart';

class RemindersList {
  final List<TimeOfDay> _schedules = [];

  List<TimeOfDay> get list => List.unmodifiable(_schedules);

  RemindersList();

  factory RemindersList.fromJson(String jsonString) {
    final result = RemindersList();
    final jsonSchedules = json.decode(jsonString);
    for (var jsonSchedule in jsonSchedules) {
      result.add(TimeOfDayExtensions.fromJson(jsonSchedule));
    }
    return result;
  }

  void copyAll(RemindersList other) => addAll(other._schedules);
  void addAll(Iterable<TimeOfDay> other) {
    for (var schedule in other) {
      _schedules.add(schedule);
    }
    _sortSchedules();
  }

  void add(TimeOfDay schedule) {
    if (!contains(schedule)) {
      _schedules.add(schedule);
      _sortSchedules();
    }
  }

  void remove(TimeOfDay schedule) {
    _schedules.remove(schedule);
  }

  void clear() => _schedules.clear();
  bool contains(TimeOfDay schedule) => _schedules.contains(schedule);

  bool get isEmpty => _schedules.isEmpty;
  bool get isNotEmpty => _schedules.isNotEmpty;

  void _sortSchedules() {
    _schedules.sort((a, b) {
      int hourComparison = a.hour.compareTo(b.hour);
      if (hourComparison != 0) return hourComparison;
      return a.minute.compareTo(b.minute);
    });
  }

  String toJson() {
    final jsonSchedules = _schedules.map((schedule) => schedule.toJson()).toList();
    return json.encode(jsonSchedules);
  }
}
