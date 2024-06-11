import 'package:flutter/material.dart';

extension TimeOfDayExtensions on TimeOfDay{

  TimeOfDay copyWith({int? hour, int? minute}) {
    return TimeOfDay(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  Map<String, dynamic> toJson() => {
    'hour': hour,
    'minute': minute,
  };

  static TimeOfDay fromJson(Map<String, dynamic> json) {
    return TimeOfDay(
      hour: json['hour'],
      minute: json['minute'],
    );
  }

  String to24HourFormat() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String toAmPmFormat() {
    final period = hour >= 12 ? 'PM' : 'AM';
    final adjustedHour = hour % 12 == 0 ? 12 : hour % 12;
    return '${adjustedHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  DateTime toDateTime({DateTime? baseDate}) {
    final now = baseDate ?? DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}
