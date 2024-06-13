
import 'dart:convert';

import 'ruku.dart';

class Statistics {
  final int completions;
  final int reads;
  final DateTime lastRead;

  Statistics({
    this.completions = 0,
    this.reads = 0,
    DateTime? lastRead,
  }) : lastRead = lastRead ?? DateTime.fromMicrosecondsSinceEpoch(0);

  Statistics copyWith({
    int? completions,
    int? reads,
    DateTime? lastRead,
  }) {
    return Statistics(
      completions: completions ?? this.completions,
      reads: reads ?? this.reads,
      lastRead: lastRead ?? this.lastRead,
    );
  }

  Statistics update({ required int rukuNum }) {
    return copyWith(
      completions: rukuNum >= Ruku.lastRukuIndex ?  completions + 1:completions,
      reads: reads + 1,
      lastRead: DateTime.now().toUtc(),
    );
  }

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      completions: json['completions'] ?? 0,
      reads: json['reads'] ?? 0,
      lastRead: DateTime.tryParse(json['lastRead'] ?? "") ?? DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completions': completions,
      'reads': reads,
      'lastRead': lastRead.toIso8601String(),
    };
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