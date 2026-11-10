import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/shared/constants.dart';

import '../cards/cardsPointsFunc.dart';
import 'EditListPointItem.dart';
import 'ListPointExpanded.dart';

String _time(String? hhmm) {
  final parts = (hhmm ?? "").split(":");
  if (parts.length != 2) return "";
  final h = int.tryParse(parts[0]), m = int.tryParse(parts[1]);
  if (h == null || m == null) return "";
  return DateFormat.jm().format(DateTime(0, 1, 1, h, m));
}

void editPointEntry(BuildContext context, dynamic entry) => Navigator.push(
    context,
    CupertinoPageRoute(
        builder: (_) => EditPointItem(id: entry.id, item: entry)));

/// Confirms, moves a points entry to Trash, and offers Undo.
/// Returns true when it was deleted.
Future<bool> deletePointEntry(BuildContext context, dynamic entry) async {
  final messenger = ScaffoldMessenger.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Delete this entry?"),
      content: Text(
          "${entry['itemName']} · ${formatPoints(pointsOf(entry))}\n\nIt moves to Trash, where you can restore it later."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(foregroundColor: Colors.black87),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
          child: const Text("Delete",
              style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );
  if (ok != true) return false;
  final db = DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  await db.moveToTrash(id: entry.id, type: 'points');
  messenger.showSnackBar(SnackBar(
    backgroundColor: primaryAppColor,
    content: Text("${entry['itemName']} moved to Trash"),
    action: SnackBarAction(
      label: "Undo",
      textColor: secondaryAppColor,
      onPressed: () => db.restore(id: entry.id, type: 'points'),
    ),
  ));
  return true;
}

/// One points entry. Swipe right for edit and delete, tap for details.
class PointTile extends StatelessWidget {
  final dynamic entry;
  final String cardName;
  final bool showDivider;

  const PointTile({
    super.key,
    required this.entry,
    required this.cardName,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = [cardName, _time(entry['time'])]
        .where((s) => s.isNotEmpty)
        .join("  ·  ");

    return Slidable(
      key: ValueKey(entry.id),
      groupTag: 'points',
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.45,
        children: [
          SlidableAction(
            onPressed: (context) => editPointEntry(context, entry),
            backgroundColor: primaryAppColor,
            foregroundColor: Colors.white,
            icon: Icons.edit_outlined,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) => deletePointEntry(context, entry),
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
          onTap: () => showPointDetails(context, entry),
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
                  child: const Icon(Icons.star_outline,
                      size: 20, color: Colors.black87),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry['itemName'] ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade600)),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(formatPoints(pointsOf(entry)),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
