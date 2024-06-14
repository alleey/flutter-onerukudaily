import 'dart:convert';

import 'package:flutter/material.dart';

import '../common/time_of_day_extensions.dart';

class RemindersList implements Comparable<RemindersList> {
  final List<TimeOfDay> _list = [];

  List<TimeOfDay> get list => List.unmodifiable(_list);

  RemindersList();

  RemindersList copyWith({
    List<TimeOfDay>? schedules,
  }) {
    final newList = schedules ?? _list;
    final copiedList = RemindersList();
    copiedList.addAll(newList);
    return copiedList;
  }

  void copyAll(RemindersList other) => addAll(other._list);
  void addAll(Iterable<TimeOfDay> other) {
    for (var schedule in other) {
      _list.add(schedule);
    }
    _sortSchedules();
  }

  void add(TimeOfDay schedule) {
    if (!contains(schedule)) {
      _list.add(schedule);
      _sortSchedules();
    }
  }

  void remove(TimeOfDay schedule) {
    _list.remove(schedule);
  }

  void clear() => _list.clear();
  bool contains(TimeOfDay schedule) => _list.contains(schedule);

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  void _sortSchedules() {
    _list.sort((a, b) {
      int hourComparison = a.hour.compareTo(b.hour);
      if (hourComparison != 0) return hourComparison;
      return a.minute.compareTo(b.minute);
    });
  }

  factory RemindersList.fromJson(String jsonString) {
    final result = RemindersList();
    final jsonSchedules = json.decode(jsonString);
    for (var jsonSchedule in jsonSchedules) {
      result.add(TimeOfDayExtensions.fromJson(jsonSchedule));
    }
    return result;
  }

  String toJson() {
    final jsonSchedules = _list.map((schedule) => schedule.toJson()).toList();
    return json.encode(jsonSchedules);
  }

  // lists are always sorted
  @override
  int compareTo(RemindersList other) {

    final comparsion = _list.length.compareTo(other._list.length);
    if (comparsion != 0) {
      return comparsion;
    }

    for (int i = 0; i < _list.length; i++) {
      int hourComparison = _list[i].hour.compareTo(other._list[i].hour);
      if (hourComparison != 0) {
        return hourComparison;
      }
      int minuteComparison = _list[i].minute.compareTo(other._list[i].minute);
      if (minuteComparison != 0) {
        return minuteComparison;
      }
    }

    return 0;
  }
}
