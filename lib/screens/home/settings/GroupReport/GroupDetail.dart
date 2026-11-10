import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/details/breakdown.dart';
import 'package:xpens/screens/home/listx/listStream/ListItem.dart';
import 'package:xpens/screens/home/listx/listStream/listStream.dart'
    show costOf, formatRupee;
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';

import 'GroupReportMain.dart' show GroupStats;

/// One group's report: total, breakdown by item, and its expenses.
class GroupDetail extends StatelessWidget {
  final String group;
  const GroupDetail({super.key, required this.group});

  static String _dayLabel(DateTime d) {
    final today = DateUtils.dateOnly(DateTime.now());
    final diff = today.difference(d).inDays;
    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";
    return DateFormat(d.year == today.year ? "EEE, d MMM" : "EEE, d MMM y")
        .format(d);
  }

  @override
  Widget build(BuildContext context) {
    final docs = Provider.of<UserInfoProvider>(context).docs;
    final items = docs.where((d) => d['group'] == group).toList()
      ..sort((a, b) =>
          DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(backgroundColor: primaryAppColor, title: Text(group)),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text("No expenses left in this group",
                    style: TextStyle(color: Colors.grey.shade600)),
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              children: [
                _Summary(items: items),
                ItemBreakdown(title: "By item", items: items),
                _ExpenseList(items: items, dayLabel: _dayLabel),
              ],
            ),
    );
  }
}

class _Summary extends StatelessWidget {
  final List items;
  const _Summary({required this.items});

  @override
  Widget build(BuildContext context) {
    final stats = GroupStats("")
      ..first = DateTime.parse(items.last['date'])
      ..last = DateTime.parse(items.first['date']);
    for (final i in items) {
      stats.total += costOf(i);
      stats.count++;
    }
    final days = DateUtils.dateOnly(stats.last)
            .difference(DateUtils.dateOnly(stats.first))
            .inDays +
        1;
    final largest = items.map((i) => costOf(i)).reduce(max);

    Widget stat(String label, String value) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
        );

    return AnalyzeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(stats.span,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(height: 2),
          Text(formatRupee(stats.total),
              style: const TextStyle(
                  fontSize: 32, fontWeight: FontWeight.w700, height: 1.15)),
          const SizedBox(height: 14),
          Row(
            children: [
              stat("Expenses", "${stats.count}"),
              stat(days == 1 ? "Day" : "Per day",
                  days == 1 ? "1" : formatRupee((stats.total / days).round())),
              stat("Largest", formatRupee(largest)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExpenseList extends StatelessWidget {
  final List items;
  final String Function(DateTime) dayLabel;
  const _ExpenseList({required this.items, required this.dayLabel});

  @override
  Widget build(BuildContext context) {
    // Day header followed by that day's rows.
    final children = <Widget>[];
    DateTime? day;
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final d = DateUtils.dateOnly(DateTime.parse(item['date']));
      if (d != day) {
        day = d;
        final dayTotal = items
            .where((x) => DateUtils.isSameDay(DateTime.parse(x['date']), d))
            .fold<double>(0, (s, x) => s + costOf(x));
        final style = TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600);
        children.add(Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          color: Colors.grey.shade100,
          child: Row(children: [
            Text(dayLabel(d), style: style),
            const Spacer(),
            Text(formatRupee(dayTotal), style: style),
          ]),
        ));
      }
      final next = i + 1 < items.length ? items[i + 1] : null;
      final sameDayNext =
          next != null && DateUtils.isSameDay(DateTime.parse(next['date']), d);
      children.add(ExpenseTile(
        item: item,
        dateLabel: DateFormat.yMMMd().format(d),
        showDivider: sameDayNext,
      ));
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text("Expenses",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          SlidableAutoCloseBehavior(child: Column(children: children)),
        ],
      ),
    );
  }
}
