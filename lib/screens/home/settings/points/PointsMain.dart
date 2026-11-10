import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

import 'ListPoints/ListPointsMain.dart';
import 'cards/cardsMain.dart';

/// Points: your cards and the history of points used.
class PointsMain extends StatelessWidget {
  const PointsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryAppColor,
          title: const Text("Points"),
          bottom: const TabBar(
            indicatorColor: secondaryAppColor,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: secondaryAppColor,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Cards"),
              Tab(text: "History"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [CardsMain(), ListPointsMain()],
        ),
      ),
    );
  }
}
