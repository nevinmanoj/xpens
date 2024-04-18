// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class BillSplitFooter extends StatelessWidget {
  final double value;
  const BillSplitFooter({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: wt,
        height: ht * 0.08,
        decoration: BoxDecoration(color: primaryAppColor, boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            // color: Colors.amber,
            spreadRadius: 10,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(wt * 0.04, 0, 0, 0),
              child: Text(
                "Total",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, wt * 0.04, 0),
              child: Text(
                "₹ ${value.toString()}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 208, 208, 208)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
