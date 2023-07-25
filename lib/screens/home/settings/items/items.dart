// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xpens/screens/home/settings/items/addItem.dart';
import 'package:xpens/screens/home/settings/items/itemList.dart';
import 'package:xpens/shared/constants.dart';

class Items extends StatefulWidget {
  const Items({super.key});

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: ht,
            width: wt,
            color: primaryAppColor,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(wt * 0.01, ht * 0.02, 0, 0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    // size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(50))),
              height: ht * 0.86,
              width: wt,
              child: ItemList(),
            ),
          ),
          Positioned(top: 100, left: wt * 0.05, child: AddItem())
        ],
      ),
    );
  }
}
