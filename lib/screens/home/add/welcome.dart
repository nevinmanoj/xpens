import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/Streaks/StreaksMain.dart';
import 'package:xpens/screens/home/listx/listStream/listStream.dart'
    show formatRupee, costOf;
import 'package:xpens/services/providers/UserInfoProvider.dart';

import '../../../shared/constants.dart';

/// Black header on the Add tab: greeting, Expense/Points switch, and
/// what has been spent today and this month.
class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final userInfo = context.watch<UserInfoProvider>();
    final firstName = userInfo.userName.trim().split(" ").first;
    final now = DateTime.now();

    double today = 0, month = 0;
    for (final item in userInfo.docs) {
      final d = DateTime.tryParse(item['date'] ?? "");
      if (d == null || d.year != now.year || d.month != now.month) continue;
      month += costOf(item);
      if (d.day == now.day) today += costOf(item);
    }

    return Container(
      color: primaryAppColor,
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const StreakPage())),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstName.isEmpty ? "Hi" : "Hi, $firstName",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat("EEEE, d MMMM").format(now),
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              _ModeSwitch(
                value: userInfo.option,
                onChanged: userInfo.setOption,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _Stat(label: "Today", value: formatRupee(today)),
              Container(
                width: 1,
                height: 30,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white24,
              ),
              _Stat(label: "This month", value: formatRupee(month)),
            ],
          ),
        ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

/// Segmented Expense / Points switch.
class _ModeSwitch extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _ModeSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final type in inputTypes)
            GestureDetector(
              onTap: () => onChanged(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: type == value ? secondaryAppColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      type == "Points" ? Icons.star_outline : Icons.currency_rupee,
                      size: 15,
                      color: type == value ? Colors.black : Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: type == value ? Colors.black : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
