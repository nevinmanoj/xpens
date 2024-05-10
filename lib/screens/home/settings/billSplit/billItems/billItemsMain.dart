import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xpens/screens/home/settings/billSplit/billSplitGetxController.dart';
import 'package:xpens/shared/dataModals/BillISplitModal.dart';

import '../../../../../shared/constants.dart';

import 'billItemExpanded/BillItemExpandedMain.dart';

class BillItemsMain extends StatefulWidget {
  const BillItemsMain({super.key});

  @override
  State<BillItemsMain> createState() => _BillItemsMainState();
}

class _BillItemsMainState extends State<BillItemsMain> {
  final ctrl = Get.put(BillSplitController());
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        GetBuilder<BillSplitController>(builder: (context) {
          return ListView.builder(
              itemCount: ctrl.billItems.length,
              itemBuilder: ((context, index) => InkWell(
                    onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => BillItemExpandedMain(
                                  index: index,
                                  isAdd: false,
                                  shares: ctrl.shareList
                                      .where((shr) =>
                                          shr.itemName ==
                                          ctrl.billItems[index].itemName)
                                      .toList(),
                                  item: ctrl.billItems[index],
                                ))),
                    child: Container(
                      child: Row(
                        children: [
                          Text(ctrl.billItems[index].itemName),
                          Text(ctrl.billItems[index].cost.toString())
                        ],
                      ),
                    ),
                  )));
        }),
        Positioned(
          bottom: ht * 0.09,
          right: 10,
          child: InkWell(
            onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => BillItemExpandedMain(
                          index: ctrl.billItems.length,
                          isAdd: true,
                          shares: [],
                          item: BillItem(
                              cost: 0,
                              splitType: SplitType.equal,
                              itemName: ""),
                        ))),
            child: Container(
              height: 56,
              width: 56,
              decoration: const BoxDecoration(
                  color: primaryAppColor, shape: BoxShape.circle),
              child: const Icon(
                Icons.add,
                color: secondaryAppColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
