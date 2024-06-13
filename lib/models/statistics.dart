
import 'dart:convert';

import 'ruku.dart';

class Statistics {
  final int completions;
  final int reads;
  final DateTime intervalStart;
  final DateTime intervalEnd;

  Statistics({
    this.completions = 0,
    this.reads = 0,
    DateTime? intervalStart,
    DateTime? intervalEnd,
  }) : intervalStart = intervalStart ?? DateTime.now().toUtc(),
       intervalEnd = intervalEnd ?? DateTime.fromMicrosecondsSinceEpoch(0);

  Statistics copyWith({
    int? completions,
    int? reads,
    DateTime? intervalStart,
    DateTime? intervalEnd,
  }) {
    return Statistics(
      completions: completions ?? this.completions,
      reads: reads ?? this.reads,
      intervalStart: intervalStart ?? this.intervalStart,
      intervalEnd: intervalEnd ?? this.intervalEnd,
    );
  }

  Statistics update({ required int rukuNum }) {
    return copyWith(
      completions: rukuNum >= Ruku.lastRukuIndex ?  completions+1:completions,
      reads: reads + 1,
      intervalEnd: DateTime.now().toUtc(),
    );
  }

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      completions: json['completions'] ?? 0,
      reads: json['reads'] ?? 0,
      intervalStart: DateTime.tryParse(json['intervalStart'] ?? "") ?? DateTime.now().toUtc(),
      intervalEnd: DateTime.tryParse(json['intervalEnd'] ?? "") ?? DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completions': completions,
      'reads': reads,
      'lastRintervalStartead': intervalStart.toIso8601String(),
      'intervalEnd': intervalEnd.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Statistics(completions: $completions, reads: $reads, '
           'intervalStart: ${intervalStart.toIso8601String()}, '
           'intervalEnd: ${intervalEnd.toIso8601String()})';
  }
}

extension StatisticsExtensions on Statistics {

  String toJsonStriing() {
    return jsonEncode(toJson());
  }

  static Statistics fromJsonString(String json) {
    final Map<String, dynamic> jsonMap = json.isEmpty ? {} : jsonDecode(json);
    return Statistics.fromJson(jsonMap);
  }
}