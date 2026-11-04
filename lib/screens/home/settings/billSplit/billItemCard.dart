import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/providers/BillSplitProvider.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/dataModals/billSplitModels.dart';
import 'billItemEditSheet.dart';

/// One bill line. In equal mode the person chips toggle who shares it
/// (quick tap assignment); other modes show each person's amount and are
/// edited in the sheet.
class BillItemCard extends StatelessWidget {
  final BillItem item;
  const BillItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bill = context.watch<BillSplitProvider>();
    final people = bill.people;
    final shares = splitItem(item);
    final problem = shares == null;
    final isEqual = item.mode == SplitMode.equal;

    String? hint;
    if (people.isEmpty) {
      hint = "Add people in the People tab to split this item";
    } else if (!item.isAssigned) {
      hint = isEqual ? "Tap people to split this item" : "Tap to split";
    } else if (problem) {
      hint = "Split doesn't add up, tap to fix";
    } else if (isEqual) {
      hint = "${formatPaise(shares.values.first)} each";
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: problem
            ? const BorderSide(color: secondaryAppColor, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => showItemEditSheet(context, item: item),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(item.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  if (!isEqual)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: primaryAppColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(item.mode.label,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11)),
                    ),
                  Text(formatPaise(item.pricePaise),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
              if (people.isNotEmpty)
                Wrap(
                  spacing: 6,
                  children: [
                    for (final p in people)
                      if (isEqual)
                        FilterChip(
                          label: Text(p.name),
                          selected: item.weights.containsKey(p.id),
                          selectedColor: secondaryAppColor.withOpacity(0.3),
                          checkmarkColor: primaryAppColor,
                          onSelected: (_) =>
                              bill.togglePersonOnItem(item.id, p.id),
                        )
                      else
                        Chip(
                          label: Text(shares?[p.id] != null
                              ? "${p.name} ${formatPaise(shares![p.id]!)}"
                              : p.name),
                          backgroundColor: (item.weights[p.id] ?? 0) != 0
                              ? secondaryAppColor.withOpacity(0.3)
                              : null,
                        ),
                    if (isEqual &&
                        people.length > 1 &&
                        item.participants.length < people.length)
                      ActionChip(
                        avatar: const Icon(Icons.group, size: 18),
                        label: const Text("All"),
                        onPressed: () => bill.assignEveryone(item.id),
                      ),
                  ],
                ),
              if (hint != null)
                Text(hint,
                    style: TextStyle(
                        fontSize: 12,
                        color: problem ? secondaryAppColor : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
