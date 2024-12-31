// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:xpens/screens/home/settings/billSplit/billItems/billItemExpanded/BillItemExpandedHeader.dart';
import 'package:xpens/screens/home/settings/billSplit/billItems/billItemExpanded/splitEven.dart';
import 'package:xpens/shared/constants.dart';

import '../../../../../../shared/dataModals/BillISplitModal.dart';
import '../../billSplitGetxController.dart';

class BillItemExpandedMain extends StatefulWidget {
  final BillItem item;
  final List<Share> shares;
  final bool isAdd;
  final int index;
  const BillItemExpandedMain(
      {super.key,
      required this.item,
      required this.shares,
      required this.isAdd,
      required this.index});

  @override
  State<BillItemExpandedMain> createState() => _BillItemExpandedMainState();
}

class _BillItemExpandedMainState extends State<BillItemExpandedMain> {
  late BillItem item;
  late List<Share> shares;

  final ctrl = Get.put(BillSplitController());

  @override
  void initState() {
    item = widget.item;
    shares = widget.shares;
    super.initState();
  }

  void updateItem(BillItem newItem) {
    setState(() {
      item = newItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryAppColor,
          actions: [
            InkWell(
                onTap: () {
                  if (!(ctrl.billItems
                          .any((ele) => ele.itemName == item.itemName)) &&
                      widget.isAdd) {
                    ctrl.addBillItem(item, shares);
                  } else {
                    if (!widget.isAdd) {
                      ctrl.updateBillItem(item, shares, widget.index);
                    } else {
                      //display same name not allowed
                      print("same name no myre");
                    }
                  }
                  Navigator.pop(context);
                },
                child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.fromLTRB(wt * 0.02, 0, wt * 0.02, 0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Save",
                      style: TextStyle(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 203, 203, 203)),
                    )))
          ],
        ),
        body: Column(
          children: [
            BillItemExpandedHeader(
              item: item,
              updateItem: updateItem,
            ),
            Container(
              height: ht * 0.06,
              color: primaryAppColor,
              child: TabBar(
                // indicator: BoxDecoration(
                //   color: Colors.blue, // Change background color here
                // ),
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                indicatorColor: secondaryAppColor,
                labelColor: secondaryAppColor,
                unselectedLabelColor: Colors.white,
                tabs: [
                  Tab(
                    child: const Icon(Icons.balance),
                  ),
                  Tab(
                    child: const Icon(Bootstrap.number_123),
                  ),
                  Tab(
                    child: const Icon(Icons.pie_chart),
                  ),
                  Tab(
                    child: const Icon(Icons.percent),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: ht * 0.64,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    SplitEven(
                      itemName: item.itemName,
                      cost: widget.item.cost,
                      updateShares: (shrs) {
                        setState(() {
                          shares = shrs;
                        });
                      },
                      shares: shares
                          .where((element) => element.itemName == item.itemName)
                          .toList(),
                    ),
                    Center(child: Text("coming soon")),
                    Center(child: Text("coming soon")),
                    Center(child: Text("coming soon")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
