import 'package:flutter/material.dart';

import '../../details/breakdown.dart';

/// Spend per item within one group, shown on the Group report.
class GroupSummary extends StatelessWidget {
  final List data;
  final String group;

  const GroupSummary({super.key, required this.group, required this.data});

  @override
  Widget build(BuildContext context) {
    return ItemBreakdown(title: "Summary", items: data);
  }
}
