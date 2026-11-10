import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/shared/constants.dart';

/// Confirms moving an expense to Trash, then offers Undo.
/// Pops with `true` when the expense was deleted.
class DeleteExpense extends StatelessWidget {
  final String id;
  final String name;
  final String cost;
  final String date;

  const DeleteExpense({
    super.key,
    required this.id,
    required this.name,
    required this.cost,
    required this.date,
  });

  Future<void> _delete(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final messenger = ScaffoldMessenger.of(context);
    final db = DatabaseService(uid: uid);
    Navigator.pop(context, true);
    await db.moveToTrash(id: id, type: 'expense');
    messenger.showSnackBar(SnackBar(
      backgroundColor: primaryAppColor,
      content: Text("$name moved to Trash"),
      action: SnackBarAction(
        label: "Undo",
        textColor: secondaryAppColor,
        onPressed: () => db.restore(id: id, type: 'expense'),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Delete this expense?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(date,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text("₹$cost",
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "It moves to Trash, where you can restore it later.",
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(foregroundColor: Colors.black87),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => _delete(context),
          style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
          child: const Text("Delete",
              style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
