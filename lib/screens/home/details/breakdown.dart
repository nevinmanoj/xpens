import 'package:flutter/material.dart';
import 'package:xpens/screens/home/listx/listStream/listStream.dart'
    show costOf, formatRupee;
import 'package:xpens/shared/constants.dart';

/// Rounded white card used for each section of the Analyze tab.
class AnalyzeCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const AnalyzeCard(
      {super.key, required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }
}

/// Spend per item name for [items], largest first, with each item's share
/// of the total. Shows the top five until expanded.
class ItemBreakdown extends StatefulWidget {
  final String title;
  final List items;
  final Widget? trailing;
  const ItemBreakdown(
      {super.key, required this.title, required this.items, this.trailing});

  @override
  State<ItemBreakdown> createState() => _ItemBreakdownState();
}

class _ItemBreakdownState extends State<ItemBreakdown> {
  static const _collapsed = 5;
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final totals = <String, double>{};
    final counts = <String, int>{};
    double total = 0;
    for (final item in widget.items) {
      final name = (item['itemName'] ?? "").toString();
      final cost = costOf(item);
      total += cost;
      totals[name] = (totals[name] ?? 0) + cost;
      counts[name] = (counts[name] ?? 0) + 1;
    }
    final ranked = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = ranked.isEmpty ? 0.0 : ranked.first.value;
    final shown = _showAll ? ranked : ranked.take(_collapsed).toList();

    return AnalyzeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(widget.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const Spacer(),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
          const SizedBox(height: 12),
          if (ranked.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text("No expenses in this period",
                  style: TextStyle(color: Colors.grey.shade600)),
            ),
          for (final e in shown)
            _BreakdownRow(
              name: e.key,
              amount: e.value,
              count: counts[e.key]!,
              share: total == 0 ? 0 : e.value / total,
              fill: top == 0 ? 0 : e.value / top,
            ),
          if (ranked.length > _collapsed)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => setState(() => _showAll = !_showAll),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                  padding: EdgeInsets.zero,
                ),
                child: Text(_showAll
                    ? "Show less"
                    : "Show all ${ranked.length} items"),
              ),
            ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String name;
  final double amount;
  final int count;
  final double share;
  final double fill;

  const _BreakdownRow({
    required this.name,
    required this.amount,
    required this.count,
    required this.share,
    required this.fill,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: name,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    TextSpan(
                        text: "  ×$count",
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500)),
                  ]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(formatRupee(amount),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(
                width: 44,
                child: Text("${(share * 100).round()}%",
                    textAlign: TextAlign.right,
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: fill,
              minHeight: 6,
              backgroundColor: Colors.grey.shade100,
              valueColor: const AlwaysStoppedAnimation(primaryAppColor),
            ),
          ),
        ],
      ),
    );
  }
}
