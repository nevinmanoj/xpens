import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/providers/BillSplitProvider.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/dataModals/billSplitModels.dart';

/// Asks for a name and adds that person to the bill.
Future<void> promptAddPerson(BuildContext context) async {
  final bill = context.read<BillSplitProvider>();
  final name = await askName(context,
      title: "Add person", validate: (n) => _validateName(bill, n));
  if (name != null) bill.addPerson(name);
}

/// Opens the rename/remove options for [p].
Future<void> editPerson(BuildContext context, Person p) async {
  final bill = context.read<BillSplitProvider>();
  final action = await showModalBottomSheet<String>(
    context: context,
    builder: (context) => SafeArea(
      child: Wrap(children: [
        ListTile(
          leading: const Icon(Icons.edit),
          title: Text("Rename ${p.name}"),
          onTap: () => Navigator.pop(context, "rename"),
        ),
        ListTile(
          leading: const Icon(Icons.person_remove),
          title: Text("Remove ${p.name}"),
          onTap: () => Navigator.pop(context, "remove"),
        ),
      ]),
    ),
  );
  if (!context.mounted) return;

  if (action == "rename") {
    final name = await askName(context,
        title: "Rename",
        initial: p.name,
        validate: (n) => _validateName(bill, n, exceptId: p.id));
    if (name != null) bill.renamePerson(p.id, name);
  } else if (action == "remove") {
    final onItems = bill.items.where((i) => i.weights.containsKey(p.id)).length;
    if (onItems > 0) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Remove ${p.name}?"),
          content: Text(
              "They'll be taken off $onItems item${onItems == 1 ? "" : "s"}. "
              "Items left with nobody will need to be split again."),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel")),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Remove")),
          ],
        ),
      );
      if (ok != true) return;
    }
    bill.removePerson(p.id);
  }
}

String? _validateName(BillSplitProvider bill, String name, {String? exceptId}) {
  if (name.trim().isEmpty) return "Name can't be empty";
  if (bill.nameTaken(name, exceptId: exceptId)) return "Name already added";
  return null;
}

class PersonAvatar extends StatelessWidget {
  final Person person;

  /// Leave null to fill the space given, such as a chip's avatar slot.
  final double? radius;
  const PersonAvatar({super.key, required this.person, this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: person.isMe ? secondaryAppColor : primaryAppColor,
      child: Text(
        person.name.isEmpty ? "?" : person.name[0].toUpperCase(),
        style: TextStyle(
            color: Colors.white, fontSize: radius == null ? 12 : radius! * 0.8),
      ),
    );
  }
}

/// Text input dialog. Returns the trimmed name, or null if cancelled.
Future<String?> askName(BuildContext context,
    {required String title,
    String initial = "",
    required String? Function(String) validate}) {
  return showDialog<String>(
    context: context,
    builder: (context) =>
        _NameDialog(title: title, initial: initial, validate: validate),
  );
}

class _NameDialog extends StatefulWidget {
  final String title;
  final String initial;
  final String? Function(String) validate;
  const _NameDialog(
      {required this.title, required this.initial, required this.validate});

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final controller = TextEditingController(text: widget.initial);
  String? error;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() {
    final e = widget.validate(controller.text);
    if (e != null) {
      setState(() => error = e);
      return;
    }
    Navigator.pop(context, controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        cursorColor: primaryAppColor,
        decoration: InputDecoration(hintText: "Name", errorText: error),
        onSubmitted: (_) => submit(),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        TextButton(onPressed: submit, child: const Text("Save")),
      ],
    );
  }
}
