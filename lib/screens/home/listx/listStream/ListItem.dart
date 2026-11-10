import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/utils/formatCost.dart';
import 'deleteExpense.dart';
import 'editMain.dart';
import 'itemExpanded.dart';
import 'listStream.dart';

/// One expense row. Swipe right for edit and delete, tap for details.
class ExpenseTile extends StatelessWidget {
  final dynamic item;
  final String dateLabel;
  final bool showDivider;

  /// Show the expense date in the subtitle (when rows aren't under a
  /// date header).
  final bool showDate;

  const ExpenseTile({
    super.key,
    required this.item,
    required this.dateLabel,
    this.showDivider = true,
    this.showDate = false,
  });

  static IconData _iconFor(String? location) => switch (location) {
        "Home" => Icons.home_outlined,
        "Personel" => Icons.person_outline,
        _ => Icons.receipt_long_outlined,
      };

  static String _time(String? hhmm) {
    if (hhmm == null || !hhmm.contains(":")) return "";
    final parts = hhmm.split(":");
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return "";
    return DateFormat.jm().format(DateTime(0, 1, 1, h, m));
  }

  static String _shortDate(DateTime d) => d.year == DateTime.now().year
      ? DateFormat("d MMM").format(d)
      : DateFormat("d MMM y").format(d);

  @override
  Widget build(BuildContext context) {
    final String name = item['itemName'] ?? "";
    final String remarks = (item['remarks'] ?? "").toString().trim();
    final String group = (item['group'] ?? "").toString().trim();
    final hasGroup = group.isNotEmpty && group != "none";
    final time = _time(item['time']);
    final subtitle = [
      if (showDate) _shortDate(DateTime.parse(item['date'])),
      time,
      if (remarks.isNotEmpty) remarks,
    ].where((s) => s.isNotEmpty).join("  ·  ");

    return Slidable(
      key: ValueKey(item.id),
      groupTag: 'expenses',
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.45,
        children: [
          SlidableAction(
            onPressed: (context) => Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => EditxDetails(id: item.id, item: item)),
            ),
            backgroundColor: primaryAppColor,
            foregroundColor: Colors.white,
            icon: Icons.edit_outlined,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) => showDialog(
              context: context,
              builder: (context) => DeleteExpense(
                id: item.id,
                name: name,
                cost: formatDouble(costOf(item)),
                date: dateLabel,
              ),
            ),
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Delete',
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => showExpenseDetails(context, item),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: showDivider
                ? BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200)))
                : null,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_iconFor(item['location']),
                      size: 20, color: Colors.black87),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatRupee(costOf(item)),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    if (hasGroup) ...[
                      const SizedBox(height: 4),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 110),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: secondaryAppColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          group,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFB25E00)),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
