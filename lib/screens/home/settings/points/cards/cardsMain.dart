import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/listx/listStream/listStream.dart'
    show formatRupee;
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/dbModals/card.dart';

import '../../../../../services/providers/UserInfoProvider.dart';
import 'cardSheets.dart';
import 'cardsPointsFunc.dart';

/// Cards tab: each card with its rate and points used. Tap for details.
class CardsMain extends StatelessWidget {
  const CardsMain({super.key});

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);
    final cards = userInfo.cards.map((e) => PointSource.fromJson(e)).toList();
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryAppColor,
        onPressed: () => showCardEditor(context),
        icon: const Icon(Icons.add_card, color: secondaryAppColor),
        label: const Text("Add card", style: TextStyle(color: Colors.white)),
      ),
      body: cards.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.credit_card,
                        size: 56, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    const Text("No cards yet",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                        "Add a card with its points-to-rupee rate to start tracking points.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                for (final card in cards)
                  _CardTile(
                    card: card,
                    entries: userInfo.pointDocs
                        .where((e) => cardOf(e, cards)?.selfId == card.selfId)
                        .toList(),
                    now: now,
                  ),
              ],
            ),
    );
  }
}

class _CardTile extends StatelessWidget {
  final PointSource card;
  final List entries;
  final DateTime now;
  const _CardTile(
      {required this.card, required this.entries, required this.now});

  @override
  Widget build(BuildContext context) {
    double all = 0, month = 0;
    for (final e in entries) {
      final pts = pointsOf(e);
      all += pts;
      final d = DateTime.parse(e['date']);
      if (d.year == now.year && d.month == now.month) month += pts;
    }
    final rate = rupeesPerPoint(card);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => showCardDetails(context, card),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CardIcon(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(card.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          Text(
                            rate == 0
                                ? "No rate set"
                                : "1 pt ≈ ₹${rate.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey.shade400),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _Stat(label: "Used", value: formatPoints(all)),
                    _Stat(
                        label: "Worth",
                        value: formatRupee((all * rate).round())),
                    _Stat(label: "This month", value: formatPoints(month)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 2),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
