// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xpens/screens/home/settings/billSplit/billItems/billItemExpanded/BillItemExpandedHeader.dart';
import 'package:xpens/shared/constants.dart';

import '../../../../../../shared/dataModals/BillISplitModal.dart';
import '../../billSplitGetxController.dart';

class BillItemExpandedMain extends StatefulWidget {
  final BillItem item;
  final List<Share> shares;
  final bool isAdd;
  const BillItemExpandedMain(
      {super.key,
      required this.item,
      required this.shares,
      required this.isAdd});

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        actions: [
          InkWell(
              onTap: () {
                if ((ctrl.billItems
                        .any((ele) => ele.itemName == item.itemName)) &&
                    !widget.isAdd) {
                  ctrl.updateBillItem(item, shares);
                } else {
                  ctrl.addBillItem(item, shares);
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
        ],
      ),
    );
  }
}
