import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';

import 'ListItem.dart';
import '../../../../shared/utils/filterFunction.dart';

final _rupee = NumberFormat.decimalPattern('en_IN')..maximumFractionDigits = 2;
String formatRupee(num v) => "₹${_rupee.format(v)}";

double costOf(item) => (item['cost'] as num?)?.toDouble() ?? 0;

/// When the expense was added: its `createdAt` field, or for older docs
/// without one, the doc key (which used to be `DateTime.now().toString()`).
DateTime? addedAt(item) {
  final data = item.data();
  if (data is Map && data.containsKey('createdAt')) {
    final created = data['createdAt'];
    // A null server timestamp means the write isn't confirmed yet, i.e. the
    // expense was added moments ago.
    return created is Timestamp ? created.toDate() : DateTime.now();
  }
  return DateTime.tryParse(item.id);
}

/// Filtered, date-grouped expense list with month and day totals.
class ExpenseList extends StatelessWidget {
  final Map filter;
  final bool hasFilters;
  final VoidCallback onClearFilters;
  final ScrollController controller;

  const ExpenseList({
    super.key,
    required this.filter,
    required this.hasFilters,
    required this.onClearFilters,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final docs = Provider.of<UserInfoProvider>(context).docs;

    // Copy so sorting never mutates the provider's list, then drop the
    // duplicates the search can return and keep strict date order.
    final seen = <String>{};
    final list = applyFilter(data: List.of(docs), filter: filter)
        .where((item) => seen.add(item.id))
        .toList();
    final byAdded = filter['order'] == 'added';
    if (byAdded) {
      // Most recently added first; docs with no readable added time go last.
      final epoch = DateTime.fromMillisecondsSinceEpoch(0);
      list.sort((a, b) =>
          (addedAt(b) ?? epoch).compareTo(addedAt(a) ?? epoch));
    } else {
      final newestFirst = filter['order'] != 'old';
      list.sort((a, b) {
        final c =
            DateTime.parse(a['date']).compareTo(DateTime.parse(b['date']));
        return newestFirst ? -c : c;
      });
    }

    if (list.isEmpty) {
      return docs.isEmpty
          ? const _EmptyState(
              icon: Icons.receipt_long_outlined,
              title: "No expenses yet",
              message: "Expenses you add will show up here.",
            )
          : _EmptyState(
              icon: Icons.search_off,
              title: "No matching expenses",
              message: "Try a different search or filter.",
              action: TextButton(
                onPressed: onClearFilters,
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                child: const Text("Clear filters"),
              ),
            );
    }

    // Date headers would fragment an added-order list, so it stays flat
    // and each row shows its own expense date instead.
    final rows = byAdded ? _flatRows(list) : _buildRows(list);
    final total = list.fold<double>(0, (s, i) => s + costOf(i));

    return SlidableAutoCloseBehavior(
      child: ListView.builder(
        controller: controller,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: rows.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return _SummaryLine(
                count: list.length, total: total, filtered: hasFilters);
          }
          final row = rows[i - 1];
          return switch (row) {
            _MonthRow() => _MonthHeader(row: row),
            _DayRow() => _DayHeader(row: row),
            _ItemRow() => ExpenseTile(
                item: row.item,
                dateLabel: DateFormat.yMMMd().format(row.date),
                showDivider: !row.lastOfDay,
                showDate: byAdded,
              ),
          };
        },
      ),
    );
  }

  static List<_Row> _flatRows(List list) => [
        for (final item in list)
          _ItemRow(item, DateUtils.dateOnly(DateTime.parse(item['date'])))
      ];

  static List<_Row> _buildRows(List list) {
    final rows = <_Row>[];
    _MonthRow? month;
    _DayRow? day;
    _ItemRow? last;

    for (final item in list) {
      final date = DateTime.parse(item['date']);
      final cost = costOf(item);

      if (month == null ||
          month.date.year != date.year ||
          month.date.month != date.month) {
        month = _MonthRow(DateTime(date.year, date.month));
        rows.add(month);
      }
      if (day == null || !DateUtils.isSameDay(day.date, date)) {
        last?.lastOfDay = true;
        day = _DayRow(DateUtils.dateOnly(date));
        rows.add(day);
      }
      month.total += cost;
      month.count++;
      day.total += cost;
      last = _ItemRow(item, day.date);
      rows.add(last);
    }
    last?.lastOfDay = true;
    return rows;
  }
}

sealed class _Row {}

class _MonthRow extends _Row {
  final DateTime date;
  double total = 0;
  int count = 0;
  _MonthRow(this.date);
}

class _DayRow extends _Row {
  final DateTime date;
  double total = 0;
  _DayRow(this.date);
}

class _ItemRow extends _Row {
  final dynamic item;
  final DateTime date;
  bool lastOfDay = false;
  _ItemRow(this.item, this.date);
}

class _SummaryLine extends StatelessWidget {
  final int count;
  final double total;
  final bool filtered;
  const _SummaryLine(
      {required this.count, required this.total, required this.filtered});

  @override
  Widget build(BuildContext context) {
    final noun = count == 1 ? "expense" : "expenses";
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Text(
            filtered ? "$count matching $noun" : "$count $noun",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const Spacer(),
          Text(
            formatRupee(total),
            style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  final _MonthRow row;
  const _MonthHeader({required this.row});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            DateFormat.yMMMM().format(row.date),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Text(
            formatRupee(row.total),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  final _DayRow row;
  const _DayHeader({required this.row});

  static String _label(DateTime d) {
    final today = DateUtils.dateOnly(DateTime.now());
    final diff = today.difference(d).inDays;
    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";
    if (d.year == today.year) return DateFormat("EEE, d MMM").format(d);
    return DateFormat("EEE, d MMM y").format(d);
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
        fontSize: 13,
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w600);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Text(_label(row.date), style: style),
          const Spacer(),
          Text(formatRupee(row.total), style: style),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(title,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600)),
            if (action != null) ...[const SizedBox(height: 8), action!],
          ],
        ),
      ),
    );
  }
}
