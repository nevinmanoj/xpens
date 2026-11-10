import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../services/database.dart';
import '../../../../services/providers/UserInfoProvider.dart';
import '../../../../shared/constants.dart';
import 'TrashItem.dart';

/// Trashed entries of one [type] ("Expense" or "Points"), grouped by the
/// day they were deleted, newest first.
class TrashBody extends StatelessWidget {
  final String type;
  const TrashBody({super.key, required this.type});

  static DateTime _deletedAt(dynamic item) {
    final data = item.data() as Map;
    return DateTime.tryParse((data['deleteDate'] ?? "").toString()) ??
        DateTime.parse(data['date']);
  }

  static String _dayLabel(DateTime d) {
    final today = DateUtils.dateOnly(DateTime.now());
    final diff = today.difference(d).inDays;
    if (diff == 0) return "Deleted today";
    if (diff == 1) return "Deleted yesterday";
    return "Deleted ${DateFormat(d.year == today.year ? "d MMM" : "d MMM y").format(d)}";
  }

  Future<void> _emptyTrash(BuildContext context, int count) async {
    final noun = type == "Expense"
        ? (count == 1 ? "expense" : "expenses")
        : (count == 1 ? "points entry" : "points entries");
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(Icons.warning_amber_rounded,
            color: Colors.red.shade700, size: 32),
        title:
            Text("Empty ${type == "Expense" ? "expenses" : "points"} trash?"),
        content: Text(
          "All $count $noun in the trash will be deleted forever. "
          "This can't be undone, and they can't be restored afterwards.",
          textAlign: TextAlign.center,
        ),
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
    if (ok != true) return;
    final deleted =
        await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .emptyTrash(type: type);
    messenger.showSnackBar(SnackBar(
      backgroundColor: primaryAppColor,
      content: Text(deleted == null
          ? "Couldn't empty the trash"
          : "Deleted $deleted $noun forever"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);
    final items = List.of(type == "Expense" ? userInfo.eTrash : userInfo.pTrash)
      ..sort((a, b) => _deletedAt(b).compareTo(_deletedAt(a)));

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_outline, size: 56, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              const Text("Trash is empty",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                  "Deleted ${type == "Expense" ? "expenses" : "points entries"} show up here.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
      );
    }

    final rows = <Object>[];
    DateTime? day;
    for (final item in items) {
      final d = DateUtils.dateOnly(_deletedAt(item));
      if (d != day) {
        day = d;
        rows.add(d);
      }
      rows.add(item);
    }

    return SlidableAutoCloseBehavior(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: rows.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${items.length} in trash · swipe right to restore or delete",
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _emptyTrash(context, items.length),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade700),
                    icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                    label: const Text("Empty trash"),
                  ),
                ],
              ),
            );
          }
          final row = rows[i - 1];
          if (row is DateTime) {
            return Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              color: Colors.grey.shade100,
              child: Text(_dayLabel(row),
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600)),
            );
          }
          final next = i < rows.length ? rows[i] : null;
          return TrashTile(
            item: row,
            type: type,
            showDivider: next != null && next is! DateTime,
          );
        },
      ),
    );
  }
}
