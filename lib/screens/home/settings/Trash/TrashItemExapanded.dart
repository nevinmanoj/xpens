import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xpens/shared/constants.dart';

import 'TrashItem.dart';

/// Sheet with a trashed entry's details, plus Restore / Delete forever.
void showTrashItemDetails(BuildContext context, dynamic item, String type) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => _TrashDetails(item: item, type: type),
  );
}

class _TrashDetails extends StatelessWidget {
  final dynamic item;
  final String type;
  const _TrashDetails({required this.item, required this.type});

  @override
  Widget build(BuildContext context) {
    final data = item.data() as Map;
    final isExpense = type == "Expense";
    String text(dynamic v) => (v ?? "").toString().trim();
    final remarks = text(data['remarks']);
    final group = text(data['group']);
    final deleted = DateTime.tryParse(text(data['deleteDate']));

    final details = <(IconData, String, String)>[
      (
        Icons.calendar_today_outlined,
        "Date",
        DateFormat("EEE, d MMM y").format(DateTime.parse(data['date']))
      ),
      if (!isExpense) (Icons.credit_card, "Card", text(data['cardName'])),
      if (isExpense && text(data['location']).isNotEmpty)
        (
          Icons.place_outlined,
          "Location",
          data['location'] == "Personel" ? "Personal" : text(data['location'])
        ),
      if (isExpense && remarks.isNotEmpty) (Icons.notes, "Remarks", remarks),
      if (isExpense && group.isNotEmpty && group != "none")
        (Icons.label_outline, "Group", group),
    ];

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
            Text(text(data['itemName']),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            if (deleted != null)
              Text("Deleted ${DateFormat("d MMM y, h:mm a").format(deleted)}",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            Text(trashAmount(item, type),
                style: const TextStyle(
                    fontSize: 32, fontWeight: FontWeight.w700, height: 1.1)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  for (final (icon, label, value) in details)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(icon, size: 18, color: Colors.black54),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 72,
                            child: Text(label,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey.shade600)),
                          ),
                          Expanded(
                              child: Text(value,
                                  style: const TextStyle(fontSize: 15))),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final nav = Navigator.of(context);
                      if (await deleteTrashItemForever(context, item, type)) {
                        nav.pop();
                      }
                    },
                    icon: const Icon(Icons.delete_forever_outlined, size: 20),
                    label: const Text("Delete forever"),
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
                    onPressed: () {
                      Navigator.pop(context);
                      restoreTrashItem(context, item, type);
                    },
                    icon: const Icon(Icons.restore, size: 20),
                    label: const Text("Restore"),
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
}
