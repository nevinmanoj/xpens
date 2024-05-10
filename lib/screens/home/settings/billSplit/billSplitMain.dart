import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xpens/screens/home/settings/billSplit/billSplitGetxController.dart';

import '../../../../shared/constants.dart';
import 'billSplitFooter.dart';
import 'billItems/billItemsMain.dart';
import 'persons/personsMain.dart';

class BillSplitMain extends StatefulWidget {
  const BillSplitMain({super.key});

  @override
  State<BillSplitMain> createState() => _BillSplitMainState();
}

class _BillSplitMainState extends State<BillSplitMain> {
  final controller = Get.put(BillSplitController());

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              InkWell(
                  onTap: () => controller.discardBill(),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.fromLTRB(wt * 0.02, 0, wt * 0.02, 0),
                      alignment: Alignment.center,
                      child: Text(
                        "Discard",
                        style: TextStyle(
                            fontSize: 20,
                            color: const Color.fromARGB(255, 203, 203, 203)),
                      )))
            ],
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
                  BillItemsMain(),
                  PersonsMain(),
                ],
              ),
              GetBuilder<BillSplitController>(builder: (context) {
                return BillSplitFooter(
                  value: controller.total,
                );
              })
            ],
          ),
        ));
  }
}
