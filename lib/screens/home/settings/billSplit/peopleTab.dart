import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/providers/BillSplitProvider.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/dataModals/billSplitModels.dart';
import 'personWidgets.dart';

/// Everyone on the bill with their total and the items that make it up.
class PeopleTab extends StatelessWidget {
  const PeopleTab({super.key});

  @override
  Widget build(BuildContext context) {
    final bill = context.watch<BillSplitProvider>();
    final totals = bill.totals;
    final problems = bill.problemItems;

    return ListView(
      key: const PageStorageKey("billSplitPeople"),
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        if (problems.isNotEmpty)
          Container(
            color: Colors.orange[50],
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.warning_amber, color: secondaryAppColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                      "${problems.length} item${problems.length == 1 ? " isn't" : "s aren't"} "
                      "split yet (${formatPaise(bill.unsettledTotal)}) and "
                      "${problems.length == 1 ? "is" : "are"} left out of the totals below."),
                ),
              ],
            ),
          ),
        if (bill.people.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Text("No people added yet. Tap + to add someone.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey)),
          ),
        for (final p in bill.people)
          _PersonCard(
            key: PageStorageKey("billSplitPerson${p.id}"),
            person: p,
            total: totals[p.id] ?? 0,
            shares: bill.breakdown(p.id),
          ),
      ],
    );
  }
}

class _PersonCard extends StatelessWidget {
  final Person person;
  final int total;
  final List<(BillItem, int)> shares;
  const _PersonCard(
      {super.key,
      required this.person,
      required this.total,
      required this.shares});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.fromLTRB(12, 6, 0, 6),
        leading: PersonAvatar(person: person, radius: 24),
        title: Text(person.name,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        subtitle: Text(shares.isEmpty
            ? "No items yet"
            : "${shares.length} item${shares.length == 1 ? "" : "s"}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(formatPaise(total),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              tooltip: "Edit ${person.name}",
              icon: const Icon(Icons.more_vert),
              onPressed: () => editPerson(context, person),
            ),
          ],
        ),
        iconColor: primaryAppColor,
        textColor: primaryAppColor,
        children: [
          for (final (item, paise) in shares)
            ListTile(
              dense: true,
              title: Text(item.name),
              subtitle: Text("of ${formatPaise(item.pricePaise)}"),
              trailing: Text(formatPaise(paise)),
            ),
        ],
      ),
    );
  }
}
