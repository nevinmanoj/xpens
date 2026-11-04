import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/providers/BillSplitProvider.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/dataModals/billSplitModels.dart';

/// Opens the add/edit sheet. Pass [item] to edit, omit it to add.
Future<void> showItemEditSheet(BuildContext context, {BillItem? item}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (context) => BillItemEditSheet(item: item),
  );
}

class BillItemEditSheet extends StatefulWidget {
  final BillItem? item;
  const BillItemEditSheet({super.key, this.item});

  @override
  State<BillItemEditSheet> createState() => _BillItemEditSheetState();
}

class _BillItemEditSheetState extends State<BillItemEditSheet> {
  late BillItem draft;
  late final bool isNew = widget.item == null;
  bool priceValid = true;

  /// Bumped when the mode changes so per-person inputs are recreated with
  /// their new default values.
  int resetCount = 0;

  @override
  void initState() {
    super.initState();
    draft = widget.item ??
        BillItem(
            id: context.read<BillSplitProvider>().newId(),
            name: "",
            pricePaise: 0);
    priceValid = !isNew;
  }

  void setMode(SplitMode mode, List<String> everyone) {
    if (mode == draft.mode) return;
    setState(() {
      draft = draft.copyWith(
          mode: mode, weights: defaultWeights(draft, mode, everyone));
      resetCount++;
    });
  }

  void setWeight(String personId, num? value) {
    final weights = Map.of(draft.weights);
    if (value == null || value == 0) {
      weights.remove(personId);
    } else {
      weights[personId] = value;
    }
    setState(() => draft = draft.copyWith(weights: weights));
  }

  bool get canSave =>
      draft.name.trim().isNotEmpty &&
      priceValid &&
      draft.pricePaise != 0 &&
      (!draft.isAssigned || isValidSplit(draft));

  void save() {
    final bill = context.read<BillSplitProvider>();
    final item = draft.copyWith(name: draft.name.trim());
    isNew ? bill.addItem(item) : bill.updateItem(item);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bill = context.watch<BillSplitProvider>();
    final people = bill.people;
    final shares = splitItem(draft);
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(isNew ? "Add item" : "Edit item",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    if (!isNew)
                      IconButton(
                        tooltip: "Delete item",
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          bill.removeItem(draft.id);
                          Navigator.pop(context);
                        },
                      ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        initialValue: draft.name,
                        autofocus: isNew,
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor: primaryAppColor,
                        decoration: const InputDecoration(labelText: "Item"),
                        onChanged: (v) =>
                            setState(() => draft = draft.copyWith(name: v)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        initialValue:
                            isNew ? "" : paiseToInput(draft.pricePaise),
                        cursorColor: primaryAppColor,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        decoration: const InputDecoration(
                            labelText: "Price", prefixText: "₹ "),
                        onChanged: (v) {
                          final p = parsePaise(v);
                          setState(() {
                            priceValid = p != null;
                            if (p != null) {
                              draft = draft.copyWith(pricePaise: p);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) => ToggleButtons(
                    constraints: BoxConstraints.expand(
                        width: (constraints.maxWidth - 5) / 4, height: 40),
                    borderRadius: BorderRadius.circular(8),
                    selectedColor: Colors.white,
                    fillColor: primaryAppColor,
                    isSelected: [
                      for (final m in SplitMode.values) m == draft.mode
                    ],
                    onPressed: (i) =>
                        setMode(SplitMode.values[i], bill.personIds),
                    children: [for (final m in SplitMode.values) Text(m.label)],
                  ),
                ),
                const SizedBox(height: 8),
                if (people.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text("Add people on the main screen to split this.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey)),
                  )
                else
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (final p in people)
                          _PersonRow(
                            name: p.name,
                            share: shares?[p.id],
                            input: _input(p.id),
                          ),
                      ],
                    ),
                  ),
                _RemainingText(item: draft),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: buttonDecoration,
                  onPressed: canSave ? save : null,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text("Save",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The per-person control for the current mode.
  Widget _input(String personId) {
    final w = draft.weights[personId];
    switch (draft.mode) {
      case SplitMode.equal:
        return Checkbox(
          activeColor: primaryAppColor,
          checkColor: secondaryAppColor,
          value: w != null && w != 0,
          onChanged: (v) => setWeight(personId, v == true ? 1 : null),
        );
      case SplitMode.shares:
        final n = (w ?? 0).toInt();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: n == 0 ? null : () => setWeight(personId, n - 1),
            ),
            SizedBox(
                width: 24,
                child: Text("$n",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16))),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => setWeight(personId, n + 1),
            ),
          ],
        );
      case SplitMode.exact:
        return _NumberField(
          key: ValueKey("exact-$resetCount-$personId"),
          initial: w == null ? "" : paiseToInput(w.toInt()),
          prefix: "₹ ",
          onChanged: (v) => setWeight(personId, parsePaise(v)),
        );
      case SplitMode.percent:
        return _NumberField(
          key: ValueKey("percent-$resetCount-$personId"),
          initial: w == null ? "" : _trimNum(w),
          suffix: " %",
          onChanged: (v) => setWeight(personId, double.tryParse(v.trim())),
        );
    }
  }

  String _trimNum(num n) =>
      n == n.roundToDouble() ? n.toInt().toString() : n.toStringAsFixed(2);
}

class _PersonRow extends StatelessWidget {
  final String name;
  final int? share;
  final Widget input;
  const _PersonRow(
      {required this.name, required this.share, required this.input});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          Expanded(child: Text(name, style: const TextStyle(fontSize: 15))),
          SizedBox(
            width: 90,
            child: Text(share == null ? "" : formatPaise(share!),
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.grey)),
          ),
          const SizedBox(width: 8),
          input,
        ],
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  final String initial;
  final String? prefix;
  final String? suffix;
  final ValueChanged<String> onChanged;
  const _NumberField(
      {super.key,
      required this.initial,
      this.prefix,
      this.suffix,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: TextFormField(
        initialValue: initial,
        cursorColor: primaryAppColor,
        textAlign: TextAlign.right,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
            isDense: true, prefixText: prefix, suffixText: suffix),
        onChanged: onChanged,
      ),
    );
  }
}

/// "₹40 left" / "5% over" for exact and percent modes.
class _RemainingText extends StatelessWidget {
  final BillItem item;
  const _RemainingText({required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.mode != SplitMode.exact && item.mode != SplitMode.percent) {
      return const SizedBox.shrink();
    }
    final left = remaining(item);
    final isExact = item.mode == SplitMode.exact;
    final done = isExact ? left == 0 : left.abs() < 0.005;
    final amount = isExact
        ? formatPaise(left.abs().toInt())
        : "${left.abs().toStringAsFixed(2)}%";
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        done ? "Adds up" : "$amount ${left > 0 ? "left" : "over"}",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: done ? Colors.green[700] : secondaryAppColor),
      ),
    );
  }
}
