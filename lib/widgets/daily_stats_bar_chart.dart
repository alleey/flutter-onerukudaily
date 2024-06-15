import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../common/app_color_scheme.dart';
import '../models/statistics.dart';

class DailyStatsBarChart extends StatelessWidget {

  const DailyStatsBarChart({
    super.key,
    required this.dailyStats,
    required this.colorScheme,
  });

  final List<DailyStatistics> dailyStats;
  final AppColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {

    final maxY = _calculateMaxY();

    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        BarChartData(
          backgroundColor: colorScheme.page.defaultButton.text,
          titlesData: FlTitlesData
          (
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, tile) => Text(
                  "${value.toInt()}",
                  style: TextStyle(color: colorScheme.page.text),
                ),
                interval: _calculateInterval(maxY),
                reservedSize: 25
              )
            ),
            bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(border: const Border(bottom: BorderSide(), left: BorderSide())),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipRoundedRadius: 8,
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {

              final stats = dailyStats[groupIndex];
              return BarTooltipItem(
                "${stats.reads} Ruku",
                TextStyle(
                  color: colorScheme.page.defaultButton.text,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          handleBuiltInTouches: true,
        ),
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barGroups: dailyStats.mapIndexed((index, stats) {

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                color: stats.completions > 0 ?  colorScheme.page.button.background:colorScheme.page.defaultButton.background,
                width: 3.0,
                toY: stats.reads.toDouble(),
              ),
            ],
          );
          }).toList(),

        ),
      ),
    );
  }

double _calculateInterval(double maxY) {
  var interval = maxY / 5;
  interval = (interval / 5).ceil() * 5;
  return interval;
}

  double _calculateMaxY() {
    final maxReads = dailyStats.map((e) => e.reads.toDouble()).reduce((a, b) => a > b ? a : b);
    return maxReads + 1; // Add 1 for padding
  }
}