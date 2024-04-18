import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../shared/constants.dart';
import '../../../../../../shared/dataModals/BillISplitModal.dart';
import '../../../../../../shared/utils/safeParse.dart';

class BillItemExpandedHeader extends StatelessWidget {
  final Function(BillItem) updateItem;
  final BillItem item;
  const BillItemExpandedHeader(
      {super.key, required this.updateItem, required this.item});

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Container(
      width: wt,
      color: primaryAppColor,
      height: ht * 0.2,
      // height: 500,
      child: Column(
        children: [
          TextFormField(
            cursorColor: Colors.white,
            cursorWidth: 1,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
              hintText: 'Click to add Cost',
            ),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 35),
            onChanged: (value) => updateItem(BillItem(
                cost: safeDoubleParse(value),
                itemName: item.itemName,
                splitType: item.splitType)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
            // decoration: BoxDecoration(color: Colors.amber),
            child: TextFormField(
              cursorColor: Colors.white,
              cursorWidth: 1,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                hintText: 'Click to add Item Name',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: secondaryAppColor
                        .withOpacity(0.4), // Change border color here
                    width: 2.0, // Adjust border width if needed
                  ),
                ),
              ),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
              onChanged: (value) => updateItem(BillItem(
                  cost: item.cost, itemName: value, splitType: item.splitType)),
            ),
          ),
        ],
      ),
    );
  }
}
