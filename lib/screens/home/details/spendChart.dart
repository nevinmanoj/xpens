import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:xpens/screens/home/listx/listStream/listStream.dart'
    show costOf, formatRupee;
import 'package:xpens/shared/constants.dart';

import 'analyzePeriod.dart';

/// Compact rupee label for axes and calendar cells: 850, 1.2k, 3.4L, 1.1Cr.
String shortRupee(num v) {
  String trim(double x) {
    final s = x.toStringAsFixed(1);
    return s.endsWith(".0") ? s.substring(0, s.length - 2) : s;
  }

  if (v >= 1e7) return "${trim(v / 1e7)}Cr";
  if (v >= 1e5) return "${trim(v / 1e5)}L";
  if (v >= 1e3) return "${trim(v / 1e3)}k";
  return v.round().toString();
}

/// Smallest "nice" number at or above [v] that splits evenly into 4 lines.
double _niceMax(double v) {
  if (v <= 0) return 100;
  final exp = pow(10, (log(v) / ln10).floor()).toDouble();
  for (final m in const [1, 2, 4, 6, 8, 10]) {
    if (m * exp >= v) return m * exp;
  }
  return 10 * exp;
}

/// Spend per day (or per month) across [period], with a dashed line at the
/// average. The current day or month is highlighted. Tapping a day bar
/// calls [onDayTap]; tapping a month bar calls [onMonthTap].
class SpendChart extends StatelessWidget {
  final AnalyzePeriod period;
  final List items;
  final ValueChanged<DateTime> onDayTap;
  final ValueChanged<DateTime> onMonthTap;

  const SpendChart({
    super.key,
    required this.period,
    required this.items,
    required this.onDayTap,
    required this.onMonthTap,
  });

  @override
  Widget build(BuildContext context) {
    final buckets = period.buckets;
    final values = List<double>.filled(buckets.length, 0);
    for (final item in items) {
      final i = period.bucketOf(DateTime.parse(item['date']));
      if (i >= 0) values[i] += costOf(item);
    }
    final total = values.fold<double>(0, (a, b) => a + b);
    final avg = total / max(1, period.elapsedBuckets);
    final maxY = _niceMax(values.fold<double>(0, max));
    final current = period.inProgress ? period.bucketOf(DateTime.now()) : -1;
    final barWidth = buckets.length > 20 ? 6.0 : (buckets.length > 8 ? 12.0 : 22.0);

    bool showLabel(int i) {
      if (period.byMonth || buckets.length <= 7) return true;
      final day = buckets[i].day;
      return day == 1 || day % 5 == 0;
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: Colors.grey.shade200, strokeWidth: 1),
          ),
          extraLinesData: ExtraLinesData(horizontalLines: [
            if (avg > 0)
              HorizontalLine(
                y: avg,
                color: Colors.grey.shade500,
                strokeWidth: 1.2,
                dashArray: const [5, 4],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(bottom: 2),
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600),
                  labelResolver: (_) => "avg ${shortRupee(avg)}",
                ),
              ),
          ]),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                interval: maxY / 4,
                getTitlesWidget: (v, meta) => Text(
                  v == 0 ? "" : shortRupee(v),
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (v, meta) {
                  final i = v.toInt();
                  if (i < 0 || i >= buckets.length || !showLabel(i)) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4,
                    child: Text(
                      period.bucketLabel(i),
                      style: TextStyle(
                        fontSize: 10,
                        color: i == current
                            ? Colors.black
                            : Colors.grey.shade600,
                        fontWeight:
                            i == current ? FontWeight.w700 : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => primaryAppColor,
              tooltipRoundedRadius: 8,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                "${period.bucketTitle(group.x)}\n",
                const TextStyle(color: Colors.white70, fontSize: 11),
                children: [
                  TextSpan(
                    text: formatRupee(rod.toY),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            touchCallback: (event, response) {
              if (event is! FlTapUpEvent) return;
              final i = response?.spot?.touchedBarGroupIndex;
              if (i == null || i < 0 || i >= buckets.length) return;
              period.byMonth ? onMonthTap(buckets[i]) : onDayTap(buckets[i]);
            },
          ),
          barGroups: [
            for (var i = 0; i < buckets.length; i++)
              BarChartGroupData(x: i, barRods: [
                BarChartRodData(
                  toY: values[i],
                  width: barWidth,
                  color: i == current ? secondaryAppColor : primaryAppColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(3)),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: Colors.grey.shade50,
                  ),
                ),
              ]),
          ],
        ),
      ),
    );
  }
}
