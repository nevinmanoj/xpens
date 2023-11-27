import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

import 'ListPoints/ListPointsMain.dart';
import 'cards/cardsMain.dart';

class PointsMain extends StatefulWidget {
  const PointsMain({super.key});

  @override
  State<PointsMain> createState() => _PointsMainState();
}

class _PointsMainState extends State<PointsMain> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: primaryAppColor,
            bottom: TabBar(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              indicatorColor: secondaryAppColor,
              labelColor: secondaryAppColor,
              unselectedLabelColor: Color(0xff778585),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "List",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        width: wt * 0.02,
                      ),
                      Icon(Icons.list)
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Cards",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        width: wt * 0.02,
                      ),
                      Icon(Icons.credit_card)
                    ],
                  ),
                ),
                // Tab(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         "Cards",
                //         style: TextStyle(
                //             fontSize: 14, fontWeight: FontWeight.w800),
                //       ),
                //       SizedBox(
                //         width: wt * 0.02,
                //       ),
                //       Icon(Icons.credit_card)
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          body: const TabBarView(
            physics: BouncingScrollPhysics(),
            children: [
              ListPointsMain(),
              CardsMain(),
            ],
          ),
        ));
  }
}
