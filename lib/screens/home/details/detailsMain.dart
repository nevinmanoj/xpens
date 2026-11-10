import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/listx/listStream/listStream.dart'
    show costOf, formatRupee;
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/enums/Period.dart';

import 'analyzePeriod.dart';
import 'breakdown.dart';
import 'calendar/calendarDisp.dart';
import 'calendar/daySheet.dart';
import 'spendChart.dart';

/// Analyze tab. One period control (Day … Year, with ‹ ›) drives the
/// summary, chart and breakdown; the calendar below opens any single day.
class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String? _location; // null = all
  AnalyzePeriod _period = const AnalyzePeriod(Period.monthly, 0);

  void _setPeriod(AnalyzePeriod p) => setState(() => _period = p);

  void _openDay(DateTime day) =>
      showDaySheet(context, day, location: _location);

  @override
  Widget build(BuildContext context) {
    final docs = Provider.of<UserInfoProvider>(context).docs;
    final list = _location == null
        ? docs
        : docs.where((i) => i['location'] == _location).toList();

    final range = _period.range;
    final inPeriod = list.where((i) {
      final d = DateTime.parse(i['date']);
      return !d.isBefore(range.startDate) && !d.isAfter(range.endDate);
    }).toList();

    final dayTotals = <DateTime, double>{};
    for (final item in list) {
      final d = DateTime.parse(item['date']);
      final key = DateTime(d.year, d.month, d.day);
      dayTotals[key] = (dayTotals[key] ?? 0) + costOf(item);
    }

    return Column(
      children: [
        _Header(
          location: _location,
          onLocation: (v) => setState(() => _location = v),
        ),
        _PeriodBar(period: _period, onChanged: _setPeriod),
        Expanded(
          child: Container(
            color: Colors.grey.shade50,
            child: ListView(
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              children: [
                _SummaryCard(period: _period, list: list, inPeriod: inPeriod),
                if (_period.mode != Period.daily)
                  AnalyzeCard(
                    padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                    child: SpendChart(
                      period: _period,
                      items: inPeriod,
                      onDayTap: _openDay,
                      onMonthTap: (m) => _setPeriod(AnalyzePeriod.ofMonth(m)),
                    ),
                  ),
                ItemBreakdown(
                  title: "By item",
                  items: inPeriod,
                  trailing: _period.mode == Period.daily
                      ? TextButton(
                          onPressed: () => _openDay(range.startDate),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black87,
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                          child: const Text("See expenses"),
                        )
                      : null,
                ),
                AnalyzeCard(
                  padding: const EdgeInsets.fromLTRB(6, 12, 6, 8),
                  child: CalendarDisp(dayTotals: dayTotals, onDayTap: _openDay),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final String? location;
  final ValueChanged<String?> onLocation;
  const _Header({required this.location, required this.onLocation});

  @override
  Widget build(BuildContext context) {
    final options = <String?>[null, ...locationList];
    return Container(
      color: primaryAppColor,
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 14),
      child: Row(
        children: [
          const Expanded(
            child: Text("Analyze",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600)),
          ),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final loc in options)
                  GestureDetector(
                    onTap: () => onLocation(loc),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: loc == location
                            ? secondaryAppColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        loc == null
                            ? "All"
                            : (loc == "Personel" ? "Personal" : loc),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color:
                              loc == location ? Colors.black : Colors.white70,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodBar extends StatelessWidget {
  final AnalyzePeriod period;
  final ValueChanged<AnalyzePeriod> onChanged;
  const _PeriodBar({required this.period, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final m in AnalyzePeriod.modes)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Center(
                      child: ChoiceChip(
                        label: Text(AnalyzePeriod.modeLabel(m)),
                        selected: period.mode == m,
                        onSelected: (_) => onChanged(AnalyzePeriod(m, 0)),
                        showCheckmark: false,
                        backgroundColor: Colors.grey.shade200,
                        selectedColor: primaryAppColor,
                        labelStyle: TextStyle(
                          color: period.mode == m
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: period.mode == m
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
            child: Row(
              children: [
                IconButton(
                  tooltip: "Previous",
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => onChanged(period.previous),
                ),
                Expanded(
                  child: GestureDetector(
                    // Tap the title to jump back to the current period.
                    onTap: period.offset == 0
                        ? null
                        : () => onChanged(AnalyzePeriod(period.mode, 0)),
                    child: Text(
                      period.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: "Next",
                  icon: const Icon(Icons.chevron_right),
                  onPressed:
                      period.canGoNext ? () => onChanged(period.next) : null,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

/// Total for the period, change against the previous period and the
/// average per day (or per month for quarter and longer).
class _SummaryCard extends StatelessWidget {
  final AnalyzePeriod period;
  final List list;
  final List inPeriod;
  const _SummaryCard(
      {required this.period, required this.list, required this.inPeriod});

  @override
  Widget build(BuildContext context) {
    final total = inPeriod.fold<double>(0, (s, i) => s + costOf(i));

    // Compare like with like: if this period is still running, only count
    // the same stretch of the previous one (e.g. 1–11 Oct vs 1–11 Nov).
    final prev = period.previous.range;
    final partial = period.inProgress && period.mode != Period.daily;
    final prevEnd = partial
        ? prev.startDate
            .add(period.elapsedEnd.difference(period.range.startDate))
        : prev.endDate;
    final prevTotal = list.where((i) {
      final d = DateTime.parse(i['date']);
      return !d.isBefore(prev.startDate) && !d.isAfter(prevEnd);
    }).fold<double>(0, (s, i) => s + costOf(i));

    final avg = total / max(1, period.elapsedBuckets);
    final count = inPeriod.length;

    Widget? change;
    if (prevTotal > 0) {
      final pct = ((total - prevTotal) / prevTotal * 100).round();
      final up = pct > 0;
      final color = pct == 0
          ? Colors.grey.shade700
          : (up ? Colors.red.shade700 : Colors.green.shade700);
      change = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pct != 0)
            Icon(up ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14, color: color),
          Text(
            pct == 0 ? "Same as " : "${pct.abs()}% vs ",
            style: TextStyle(
                fontSize: 13, color: color, fontWeight: FontWeight.w600),
          ),
          Flexible(
            child: Text(
              partial
                  ? "same point in ${period.previousLabel}"
                  : period.previousLabel,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
        ],
      );
    } else if (total > 0) {
      final label = period.previousLabel;
      final relative = label == "yesterday" || label == "last week";
      change = Text("Nothing spent ${relative ? label : "in $label"}",
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600));
    }

    return AnalyzeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Spent",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(height: 2),
          Text(formatRupee(total),
              style: const TextStyle(
                  fontSize: 32, fontWeight: FontWeight.w700, height: 1.15)),
          if (change != null) ...[const SizedBox(height: 4), change],
          const SizedBox(height: 14),
          Row(
            children: [
              _Stat(
                  label: "Expenses", value: count == 0 ? "–" : "$count"),
              if (period.mode != Period.daily)
                _Stat(
                    label: "Avg per ${period.unit}",
                    value: total == 0 ? "–" : formatRupee(avg.round())),
              _Stat(
                  label: "Largest",
                  value: count == 0
                      ? "–"
                      : formatRupee(inPeriod.map((i) => costOf(i)).reduce(max))),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 2),
          Text(value,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
