import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ItemInput/formFields.dart'
    show fieldDecoration;
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';

import '../../../../services/database.dart';

/// Items: the categories shown as chips on the Add tab.
class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  String _query = "";

  DatabaseService get _db =>
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);

  Future<void> _add(List items) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _AddItemDialog(existing: items),
    );
    if (name == null) return;
    await _db.updateItemsArray(add: true, item: name);
  }

  Future<void> _remove(String item, int uses) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Remove $item?"),
        content: Text(uses == 0
            ? "It won't show on the Add tab any more."
            : "It won't show on the Add tab any more. Your $uses past ${uses == 1 ? "expense keeps" : "expenses keep"} the name and ${uses == 1 ? "counts" : "count"} as Other."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: Colors.black87),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
            child: const Text("Remove",
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (ok == true) await _db.updateItemsArray(add: false, item: item);
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);
    final items = userInfo.items.where((i) => i != "Other").toList();
    final uses = <String, int>{};
    for (final d in userInfo.docs) {
      final n = d['itemName'];
      uses[n] = (uses[n] ?? 0) + 1;
    }
    final q = _query.trim().toLowerCase();
    final shown = items
        .where((i) => q.isEmpty || i.toString().toLowerCase().contains(q))
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar:
          AppBar(backgroundColor: primaryAppColor, title: const Text("Items")),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryAppColor,
        onPressed: () => _add(userInfo.items),
        icon: const Icon(Icons.add, color: secondaryAppColor),
        label: const Text("Add item", style: TextStyle(color: Colors.white)),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            TextField(
              onChanged: (v) => setState(() => _query = v),
              cursorColor: primaryAppColor,
              decoration: fieldDecoration(
                hint: "Search items",
                prefix: const Icon(Icons.search, size: 20),
              ).copyWith(fillColor: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
              child: Text(
                "${items.length} items, shown as chips on the Add tab. \"Other\" is always there for anything else.",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ),
            if (shown.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                    q.isEmpty ? "No items yet" : "No items match \"$_query\"",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600)),
              )
            else
              Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    for (var i = 0; i < shown.length; i++) ...[
                      if (i > 0)
                        Divider(
                            height: 1, indent: 16, color: Colors.grey.shade200),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(shown[i],
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                    "${uses[shown[i]] ?? 0} ${(uses[shown[i]] ?? 0) == 1 ? "expense" : "expenses"}",
                                    style: TextStyle(
                                        fontSize: 12.5,
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: "Remove",
                              icon: Icon(Icons.delete_outline,
                                  color: Colors.grey.shade600),
                              onPressed: () =>
                                  _remove(shown[i], uses[shown[i]] ?? 0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AddItemDialog extends StatefulWidget {
  final List existing;
  const _AddItemDialog({required this.existing});

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final t = _ctrl.text.trim();
    Navigator.pop(context, t[0].toUpperCase() + t.substring(1));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Add item"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          cursorColor: primaryAppColor,
          onFieldSubmitted: (_) => _submit(),
          decoration: fieldDecoration(hint: "e.g. Groceries"),
          validator: (v) {
            final t = (v ?? "").trim().toLowerCase();
            if (t.isEmpty) return "Enter a name";
            if (widget.existing.any((e) => e.toString().toLowerCase() == t)) {
              return "That item already exists";
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: Colors.black87),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _submit,
          style: TextButton.styleFrom(foregroundColor: Colors.black),
          child:
              const Text("Add", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
