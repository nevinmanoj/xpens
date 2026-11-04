import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/providers/BillSplitProvider.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/dataModals/billSplitModels.dart';
import '../../../../shared/utils/receiptParser.dart';

class _ReviewLine {
  static int _nextKey = 0;
  final int key = _nextKey++;
  String name;
  int? pricePaise;
  bool include;
  final ReceiptLineKind kind;
  _ReviewLine(this.name, this.pricePaise, this.include, this.kind);
}

/// Lets me fix what OCR read before it goes into the bill.
class ReceiptReview extends StatefulWidget {
  final ParsedReceipt receipt;
  const ReceiptReview({super.key, required this.receipt});

  @override
  State<ReceiptReview> createState() => _ReceiptReviewState();
}

class _ReceiptReviewState extends State<ReceiptReview> {
  late final List<_ReviewLine> lines = [
    for (final l in widget.receipt.lines)
      _ReviewLine(l.name, l.pricePaise, l.suggested, l.kind)
  ];

  Iterable<_ReviewLine> get selected => lines
      .where((l) => l.include && l.pricePaise != null && l.pricePaise != 0);

  void addToBill() {
    final bill = context.read<BillSplitProvider>();
    bill.addItems([
      for (final l in selected)
        BillItem(
          id: bill.newId(),
          name: l.name.trim().isEmpty ? "Item" : l.name.trim(),
          pricePaise: l.pricePaise!,
          // Tax, service charge and discounts are shared by everyone;
          // dishes start unassigned so I tap who had them.
          weights: l.kind == ReceiptLineKind.item
              ? const {}
              : {for (final id in bill.personIds) id: 1},
        )
    ]);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final count = selected.length;
    final sum = selected.fold<int>(0, (a, l) => a + l.pricePaise!);
    final target = widget.receipt.totalPaise ?? widget.receipt.subtotalPaise;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        title: const Text("Review receipt"),
      ),
      body: Column(
        children: [
          _TotalBanner(selected: sum, target: target),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                for (final l in lines) _row(l),
                TextButton.icon(
                  onPressed: () => setState(() => lines
                      .add(_ReviewLine("", null, true, ReceiptLineKind.item))),
                  icon: const Icon(Icons.add, color: primaryAppColor),
                  label: const Text("Add a missing line",
                      style: TextStyle(color: primaryAppColor)),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton(
            style: buttonDecoration,
            onPressed: count == 0 ? null : addToBill,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text("Add $count line${count == 1 ? "" : "s"} to bill",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(_ReviewLine l) {
    final tag = switch (l.kind) {
      ReceiptLineKind.charge => "Charge",
      ReceiptLineKind.discount => "Discount",
      ReceiptLineKind.item => null,
    };
    return Padding(
      key: ValueKey(l.key),
      padding: const EdgeInsets.fromLTRB(4, 0, 12, 0),
      child: Row(
        children: [
          Checkbox(
            activeColor: primaryAppColor,
            checkColor: secondaryAppColor,
            value: l.include,
            onChanged: (v) => setState(() => l.include = v ?? false),
          ),
          Expanded(
            child: TextFormField(
              initialValue: l.name,
              cursorColor: primaryAppColor,
              decoration: InputDecoration(
                isDense: true,
                hintText: "Item",
                helperText: tag,
              ),
              onChanged: (v) => l.name = v,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: TextFormField(
              initialValue:
                  l.pricePaise == null ? "" : paiseToInput(l.pricePaise!),
              cursorColor: primaryAppColor,
              textAlign: TextAlign.right,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              decoration: InputDecoration(
                isDense: true,
                prefixText: "₹ ",
                helperText: tag == null ? null : " ",
              ),
              onChanged: (v) => setState(() => l.pricePaise = parsePaise(v)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalBanner extends StatelessWidget {
  final int selected;
  final int? target;
  const _TotalBanner({required this.selected, required this.target});

  @override
  Widget build(BuildContext context) {
    final String text;
    final bool ok;
    if (target == null) {
      ok = false;
      text =
          "No total found on the receipt. Selected: ${formatPaise(selected)}";
    } else {
      final diff = target! - selected;
      ok = diff == 0;
      text = ok
          ? "Selected lines match the receipt total ${formatPaise(target!)}"
          : "Selected ${formatPaise(selected)} vs receipt ${formatPaise(target!)}: "
              "${formatPaise(diff.abs())} ${diff > 0 ? "missing" : "extra"}";
    }
    return Container(
      width: double.infinity,
      color: ok ? Colors.green[50] : Colors.orange[50],
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(ok ? Icons.check_circle : Icons.info_outline,
              color: ok ? Colors.green[700] : secondaryAppColor),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
