import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/listx/listStream/ListItem.dart';
import 'package:xpens/screens/home/listx/listStream/listStream.dart'
    show costOf, formatRupee;
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';

import 'addFromCalendar.dart';

/// Bottom sheet with one day's expenses, listed like the List tab, plus a
/// button to add an expense on that day. [location] narrows the list the
/// same way as the Analyze tab's filter (null = all).
void showDaySheet(BuildContext context, DateTime day, {String? location}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => _DaySheet(day: DateUtils.dateOnly(day), location: location),
  );
}

class _DaySheet extends StatelessWidget {
  final DateTime day;
  final String? location;
  const _DaySheet({required this.day, required this.location});

  @override
  Widget build(BuildContext context) {
    // Watches the provider so edits and deletes show up straight away.
    final docs = context.watch<UserInfoProvider>().docs;
    final items = docs.where((item) {
      if (location != null && item['location'] != location) return false;
      return DateUtils.isSameDay(DateTime.parse(item['date']), day);
    }).toList()
      ..sort((a, b) => (a['time'] ?? "").compareTo(b['time'] ?? ""));
    final total = items.fold<double>(0, (s, i) => s + costOf(i));
    final maxHeight = MediaQuery.of(context).size.height * 0.75;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat("EEEE, d MMMM y").format(day),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(
                          [
                            "${items.length} ${items.length == 1 ? "expense" : "expenses"}",
                            if (location != null)
                              location == "Personel" ? "Personal" : location!,
                          ].join(" · "),
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Text(formatRupee(total),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: items.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text("Nothing spent on this day",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600)),
                    )
                  : SlidableAutoCloseBehavior(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for (var i = 0; i < items.length; i++)
                            ExpenseTile(
                              item: items[i],
                              dateLabel: DateFormat.yMMMd().format(day),
                              showDivider: i < items.length - 1,
                            ),
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => AddFromCal(date: day)),
                  ),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text("Add expense on this day"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAppColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
