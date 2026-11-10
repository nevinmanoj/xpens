import 'package:flutter/material.dart';
import '../../../../shared/constants.dart';
import 'TrashBody.dart';

/// Trash: deleted expenses and points, which can be restored or deleted
/// for good.
class TrashMain extends StatelessWidget {
  const TrashMain({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryAppColor,
          title: const Text("Trash"),
          bottom: const TabBar(
            indicatorColor: secondaryAppColor,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: secondaryAppColor,
            unselectedLabelColor: Colors.white70,
            tabs: [Tab(text: "Expenses"), Tab(text: "Points")],
          ),
        ),
        body: const TabBarView(
          children: [TrashBody(type: "Expense"), TrashBody(type: "Points")],
        ),
      ),
    );
  }
}
