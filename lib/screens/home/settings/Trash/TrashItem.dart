import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:xpens/screens/home/listx/listStream/listStream.dart'
    show costOf, formatRupee;
import 'package:xpens/services/database.dart';
import '../../../../shared/constants.dart';

import '../points/cards/cardsPointsFunc.dart' show formatPoints, pointsOf;
import 'TrashItemExapanded.dart';

DatabaseService _db() =>
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);

/// "₹250" for an expense, "1,200 pts" for points.
String trashAmount(dynamic item, String type) => type == "Expense"
    ? formatRupee(costOf(item))
    : formatPoints(pointsOf(item));

/// Restores [item] straight away, with Undo.
Future<void> restoreTrashItem(
    BuildContext context, dynamic item, String type) async {
  final messenger = ScaffoldMessenger.of(context);
  await _db().restore(id: item.id, type: type);
  messenger.showSnackBar(SnackBar(
    backgroundColor: primaryAppColor,
    content: Text("${item['itemName']} restored"),
    action: SnackBarAction(
      label: "Undo",
      textColor: secondaryAppColor,
      onPressed: () => _db().moveToTrash(
          id: item.id, type: type == "Expense" ? "expense" : "points"),
    ),
  ));
}

/// Asks, then deletes [item] for good. Returns true when deleted.
Future<bool> deleteTrashItemForever(
    BuildContext context, dynamic item, String type) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Delete forever?"),
      content: Text(
          "${item['itemName']} · ${trashAmount(item, type)}\n\nThis can't be undone."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(foregroundColor: Colors.black87),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
          child: const Text("Delete forever",
              style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );
  if (ok != true) return false;
  await _db().permaDelete(id: item.id, type: type);
  return true;
}

/// One trashed entry. Swipe right to restore or delete forever.
class TrashTile extends StatelessWidget {
  final dynamic item;
  final String type;
  final bool showDivider;
  const TrashTile(
      {super.key,
      required this.item,
      required this.type,
      this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(item['date']);
    final detail = type == "Expense"
        ? (item['remarks'] ?? "").toString().trim()
        : (item['cardName'] ?? "").toString();
    final subtitle = [
      DateFormat(date.year == DateTime.now().year ? "d MMM" : "d MMM y")
          .format(date),
      if (detail.isNotEmpty) detail,
    ].join("  ·  ");

    return Slidable(
      key: ValueKey(item.id),
      groupTag: 'trash',
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.5,
        children: [
          SlidableAction(
            onPressed: (context) => restoreTrashItem(context, item, type),
            backgroundColor: primaryAppColor,
            foregroundColor: Colors.white,
            icon: Icons.restore,
            label: 'Restore',
          ),
          SlidableAction(
            onPressed: (context) => deleteTrashItemForever(context, item, type),
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
            icon: Icons.delete_forever_outlined,
            label: 'Delete',
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => showTrashItemDetails(context, item, type),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: showDivider
                ? BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey.shade200)))
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
                  child: Icon(
                      type == "Expense"
                          ? Icons.receipt_long_outlined
                          : Icons.star_outline,
                      size: 20,
                      color: Colors.black45),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['itemName'] ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(trashAmount(item, type),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
