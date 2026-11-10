// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xpens/screens/home/listx/listStream/editMain.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/utils/formatCost.dart';

import 'deleteExpense.dart';
import 'listStream.dart' show addedAt, costOf, formatRupee;

/// Opens the expense detail sheet.
void showExpenseDetails(BuildContext context, dynamic item) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => ExpandItem(item: item),
  );
}

/// Expense details: amount, when, where, notes and group, with Edit and
/// Delete.
class ExpandItem extends StatelessWidget {
  final dynamic item;
  const ExpandItem({super.key, required this.item});

  static String _locationLabel(String loc) =>
      loc == "Personel" ? "Personal" : loc;

  static IconData _locationIcon(String loc) => switch (loc) {
        "Home" => Icons.home_outlined,
        "Personel" => Icons.person_outline,
        _ => Icons.receipt_long_outlined,
      };

  static String? _time(String? hhmm) {
    final parts = (hhmm ?? "").split(":");
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]), m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return DateFormat.jm().format(DateTime(0, 1, 1, h, m));
  }

  static String _stamp(DateTime d) => DateFormat("d MMM y, h:mm a").format(d);

  @override
  Widget build(BuildContext context) {
    final data = item.data() as Map;
    final String name = data['itemName'] ?? "";
    final String location = (data['location'] ?? "").toString();
    final String remarks = (data['remarks'] ?? "").toString().trim();
    final String group = (data['group'] ?? "").toString().trim();
    final hasGroup = group.isNotEmpty && group != "none";
    final date = DateTime.parse(data['date']);
    final time = _time(data['time']);
    final added = addedAt(item);
    final updated = data['updatedAt'];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            const SizedBox(height: 20),

            // Name and location
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(_locationIcon(location), color: Colors.black87),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      if (location.isNotEmpty)
                        Text(_locationLabel(location),
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Amount
            Text(
              formatRupee(costOf(item)),
              style: const TextStyle(
                  fontSize: 36, fontWeight: FontWeight.w700, height: 1.1),
            ),
            const SizedBox(height: 20),

            // Details
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: "Date",
                    value: Text(DateFormat("EEE, d MMM y").format(date)),
                  ),
                  if (time != null)
                    _DetailRow(
                        icon: Icons.schedule,
                        label: "Time",
                        value: Text(time)),
                  if (remarks.isNotEmpty)
                    _DetailRow(
                        icon: Icons.notes,
                        label: "Remarks",
                        value: Text(remarks)),
                  if (hasGroup)
                    _DetailRow(
                      icon: Icons.label_outline,
                      label: "Group",
                      value: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: secondaryAppColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(group,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFB25E00))),
                      ),
                    ),
                ],
              ),
            ),

            // Audit trail
            if (added != null) ...[
              const SizedBox(height: 10),
              Text(
                [
                  "Added ${_stamp(added)}",
                  if (updated is Timestamp)
                    "edited ${_stamp(updated.toDate())}",
                ].join(" · "),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
            const SizedBox(height: 20),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _delete(context, name, date),
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: const Text("Delete"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _edit(context),
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    label: const Text("Edit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryAppColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _edit(BuildContext context) {
    final nav = Navigator.of(context);
    nav.pop();
    nav.push(CupertinoPageRoute(
        builder: (_) => EditxDetails(id: item.id, item: item)));
  }

  Future<void> _delete(BuildContext context, String name, DateTime date) async {
    final nav = Navigator.of(context);
    final deleted = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteExpense(
        id: item.id,
        name: name,
        cost: formatDouble(costOf(item)),
        date: DateFormat.yMMMd().format(date),
      ),
    );
    if (deleted == true) nav.pop();
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget value;
  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 12),
          SizedBox(
            width: 72,
            child: Text(label,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          ),
          Expanded(
            child: DefaultTextStyle.merge(
              style: const TextStyle(fontSize: 15),
              child: Align(alignment: Alignment.centerLeft, child: value),
            ),
          ),
        ],
      ),
    );
  }
}
