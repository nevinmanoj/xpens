import 'package:flutter/material.dart';

import '../../../../shared/constants.dart';
import '../../components/addItem.dart';
import 'billSplitFooter.dart';
import 'items/itemsMain.dart';
import 'persons/personsMain.dart';

class BillSplitMain extends StatefulWidget {
  const BillSplitMain({super.key});

  @override
  State<BillSplitMain> createState() => _BillSplitMainState();
}

class _BillSplitMainState extends State<BillSplitMain> {
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
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              indicatorColor: secondaryAppColor,
              labelColor: secondaryAppColor,
              unselectedLabelColor: const Color(0xff778585),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Items",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        width: wt * 0.02,
                      ),
                      const Icon(Icons.list)
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Persons",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        width: wt * 0.02,
                      ),
                      const Icon(Icons.group)
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              const TabBarView(
                physics: BouncingScrollPhysics(),
                children: [
                  ItemsMain(),
                  PersonsMain(),
                ],
              ),
              BillSplitFooter(
                value: wt,
              )
            ],
          ),
        ));
  }
}
