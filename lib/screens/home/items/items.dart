// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xpens/screens/home/items/addItem.dart';
import 'package:xpens/screens/home/items/itemList.dart';
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
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(50))),
            height: ht * 0.86,
            width: wt,
            child: ItemList(),
          ),
        ),
        Positioned(top: 100, left: wt * 0.05, child: AddItem())
      ],
    );
  }
}
