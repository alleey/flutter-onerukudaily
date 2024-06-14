
import 'dart:convert';

import '../../common/constants.dart';
import '../../utils/conversion.dart';

import 'ruku.dart';

class DailyStatistics {
  final int completions;
  final int reads;
  final DateTime dateTime;

  DailyStatistics({
    this.completions = 0,
    this.reads = 0,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now().toUtc();

  DailyStatistics copyWith({
    int? completions,
    int? reads,
    DateTime? dateTime,
  }) {
    return DailyStatistics(
      completions: completions ?? this.completions,
      reads: reads ?? this.reads,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  factory DailyStatistics.fromJson(Map<String, dynamic> json) {
    return DailyStatistics(
      completions: json['completions'] ?? 0,
      reads: json['reads'] ?? 0,
      dateTime: DateTime.tryParse(json['dateTime'] ?? "") ?? DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completions': completions,
      'reads': reads,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}

extension DailyStatisticsExtensions on DailyStatistics {

  String toJsonStriing() {
    return jsonEncode(toJson());
  }

  static Statistics fromJsonString(String json) {
    final Map<String, dynamic> jsonMap = json.isEmpty ? {} : jsonDecode(json);
    return Statistics.fromJson(jsonMap);
  }
}

class Statistics {
  final int completions;
  final int reads;
  final DateTime intervalStart;
  final DateTime intervalEnd;
  final List<DailyStatistics> dailyStats;

  Statistics({
    this.completions = 0,
    this.reads = 0,
    DateTime? intervalStart,
    DateTime? intervalEnd,
    List<DailyStatistics>? dailyStats,
  }) : intervalStart = intervalStart ?? DateTime.now().toUtc(),
       intervalEnd = intervalEnd ?? DateTime.fromMicrosecondsSinceEpoch(0),
       dailyStats = dailyStats ?? [];

  Statistics copyWith({
    int? completions,
    int? reads,
    DateTime? intervalStart,
    DateTime? intervalEnd,
    List<DailyStatistics>? dailyStats,
  }) {
    return Statistics(
      completions: completions ?? this.completions,
      reads: reads ?? this.reads,
      intervalStart: intervalStart ?? this.intervalStart,
      intervalEnd: intervalEnd ?? this.intervalEnd,
      dailyStats: dailyStats ?? this.dailyStats,
    );
  }

  Statistics update({required int rukuNum}) {

    final now = DateTime.now().toUtc().dateOnly();

    final oldestDate = now.subtract(const Duration(days: Constants.maxDailyStatsDays - 1));

    final statsMap = { for (var stat in dailyStats) stat.dateTime.dateOnly() : stat };
    for (int i = 0; i < Constants.maxDailyStatsDays; i++) {
      final day = oldestDate.add(Duration(days: i));
      if (!statsMap.containsKey(day)) {
        statsMap[day] = DailyStatistics(dateTime: day);
      }
    }

    var newDailyStats = statsMap.values.toList();
    newDailyStats.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    if (newDailyStats.length > Constants.maxDailyStatsDays) {
      newDailyStats = newDailyStats.sublist(0, Constants.maxDailyStatsDays);
    }

    final isCompletion = rukuNum >= Ruku.lastRukuIndex;
    final todayStats = newDailyStats.first.copyWith(
      completions: isCompletion ? newDailyStats.last.completions + 1 : newDailyStats.first.completions,
      reads: newDailyStats.first.reads + 1,
    );

    newDailyStats[0] = todayStats;

    return copyWith(
      completions: isCompletion ? completions + 1 : completions,
      reads: reads + 1,
      intervalEnd: now,
      dailyStats: newDailyStats,
    );
  }

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      completions: json['completions'] ?? 0,
      reads: json['reads'] ?? 0,
      intervalStart: DateTime.tryParse(json['intervalStart'] ?? "") ?? DateTime.now().toUtc(),
      intervalEnd: DateTime.tryParse(json['intervalEnd'] ?? "") ?? DateTime.now().toUtc(),
      dailyStats: (json['dailyStats'] as List<dynamic>?)
          ?.map((e) => DailyStatistics.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completions': completions,
      'reads': reads,
      'intervalStart': intervalStart.toIso8601String(),
      'intervalEnd': intervalEnd.toIso8601String(),
      'dailyStats': dailyStats.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Statistics(completions: $completions, reads: $reads, '
           'intervalStart: ${intervalStart.toIso8601String()}, '
           'intervalEnd: ${intervalEnd.toIso8601String()}, '
           'dailyStats: $dailyStats)';
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