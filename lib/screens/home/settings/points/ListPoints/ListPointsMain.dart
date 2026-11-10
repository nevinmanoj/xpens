import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/listx/listStream/listStream.dart'
    show formatRupee;
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/dbModals/card.dart';

import '../cards/cardsPointsFunc.dart';
import 'ListPointItem.dart';

/// History tab: points entries grouped by day, filterable by card.
class ListPointsMain extends StatefulWidget {
  const ListPointsMain({super.key});

  @override
  State<ListPointsMain> createState() => _ListPointsMainState();
}

/// Filter value for entries whose card has been deleted.
const _removed = "__removed__";

class _ListPointsMainState extends State<ListPointsMain> {
  String? _card; // card id, _removed, or null for all

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
    final userInfo = Provider.of<UserInfoProvider>(context);
    final cards = userInfo.cards.map((e) => PointSource.fromJson(e)).toList();
    final all = userInfo.pointDocs;
    final hasRemoved = all.any((e) => cardOf(e, cards) == null);
    if (_card == _removed && !hasRemoved) _card = null;
    if (_card != null &&
        _card != _removed &&
        !cards.any((c) => c.selfId == _card)) {
      _card = null;
    }

    final entries = all.where((e) {
      final c = cardOf(e, cards);
      if (_card == null) return true;
      if (_card == _removed) return c == null;
      return c?.selfId == _card;
    }).toList();

    double points = 0, worth = 0;
    for (final e in entries) {
      final c = cardOf(e, cards);
      points += pointsOf(e);
      if (c != null) worth += pointsOf(e) * rupeesPerPoint(c);
    }

    // Group by day (entries arrive newest first).
    final rows = <Object>[];
    DateTime? day;
    for (final e in entries) {
      final d = DateUtils.dateOnly(DateTime.parse(e['date']));
      if (day == null || d != day) {
        day = d;
        rows.add(d);
      }
      rows.add(e);
    }

    final chips = <(String?, String)>[
      (null, "All"),
      for (final c in cards) (c.selfId, c.name),
      if (hasRemoved) (_removed, "Removed cards"),
    ];

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final (id, label) in chips)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Center(
                      child: ChoiceChip(
                        label: Text(label),
                        selected: _card == id,
                        onSelected: (_) => setState(() => _card = id),
                        showCheckmark: false,
                        backgroundColor: Colors.grey.shade200,
                        selectedColor: primaryAppColor,
                        labelStyle: TextStyle(
                          color: _card == id ? Colors.white : Colors.black87,
                          fontWeight:
                              _card == id ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: entries.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_outline,
                              size: 56, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text("No points used yet",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(
                              "Log points from the Add tab by switching to Points.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  )
                : SlidableAutoCloseBehavior(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: rows.length + 1,
                      itemBuilder: (context, i) {
                        if (i == 0) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                            child: Row(
                              children: [
                                Text(
                                  "${entries.length} ${entries.length == 1 ? "entry" : "entries"}",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600),
                                ),
                                const Spacer(),
                                Text(
                                  "${formatPoints(points)}"
                                  "${worth > 0 ? " ≈ ${formatRupee(worth.round())}" : ""}",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800),
                                ),
                              ],
                            ),
                          );
                        }
                        final row = rows[i - 1];
                        if (row is DateTime) {
                          final dayPts = entries
                              .where((e) => DateUtils.isSameDay(
                                  DateTime.parse(e['date']), row))
                              .fold<double>(0, (s, e) => s + pointsOf(e));
                          final style = TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600);
                          return Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            color: Colors.grey.shade100,
                            child: Row(children: [
                              Text(_dayLabel(row), style: style),
                              const Spacer(),
                              Text(formatPoints(dayPts), style: style),
                            ]),
                          );
                        }
                        final next = i < rows.length ? rows[i] : null;
                        return PointTile(
                          entry: row,
                          cardName: cardOf(row, cards)?.name ??
                              (row as dynamic)['cardName'] ??
                              "",
                          showDivider: next != null && next is! DateTime,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
