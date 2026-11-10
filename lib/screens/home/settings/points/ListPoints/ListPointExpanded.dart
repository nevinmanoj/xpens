// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/listx/listStream/listStream.dart'
    show formatRupee;
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/dbModals/card.dart';

import '../cards/cardSheets.dart';
import '../cards/cardsPointsFunc.dart';
import 'ListPointItem.dart';

/// Opens the points entry detail sheet.
void showPointDetails(BuildContext context, dynamic entry) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => _PointDetails(entry: entry),
  );
}

class _PointDetails extends StatelessWidget {
  final dynamic entry;
  const _PointDetails({required this.entry});

  @override
  Widget build(BuildContext context) {
    final cards = context
        .read<UserInfoProvider>()
        .cards
        .map((e) => PointSource.fromJson(e))
        .toList();
    final card = cardOf(entry, cards);
    final points = pointsOf(entry);
    final date = DateTime.parse(entry['date']);
    final parts = (entry['time'] ?? "").toString().split(":");
    final time = parts.length == 2
        ? DateFormat.jm().format(DateTime(
            0, 1, 1, int.tryParse(parts[0]) ?? 0, int.tryParse(parts[1]) ?? 0))
        : null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const CardIcon(size: 48),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry['itemName'] ?? "",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      Text(card?.name ?? "${entry['cardName']} (removed)",
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(formatPoints(points),
                style: const TextStyle(
                    fontSize: 36, fontWeight: FontWeight.w700, height: 1.1)),
            if (card != null && rupeesPerPoint(card) > 0)
              Text("≈ ${formatRupee((points * rupeesPerPoint(card)).round())}",
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _Row(
                      icon: Icons.calendar_today_outlined,
                      label: "Date",
                      value: DateFormat("EEE, d MMM y").format(date)),
                  if (time != null)
                    _Row(icon: Icons.schedule, label: "Time", value: time),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final nav = Navigator.of(context);
                      if (await deletePointEntry(context, entry)) nav.pop();
                    },
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: const Text("Delete"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final nav = Navigator.of(context);
                      nav.pop();
                      editPointEntry(nav.context, entry);
                    },
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    label: const Text("Edit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryAppColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Row({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 12),
          SizedBox(
            width: 72,
            child: Text(label,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
