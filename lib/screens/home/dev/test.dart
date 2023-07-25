// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class Test extends StatefulWidget {
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  double count = 0;
  bool l = false;
  void updatecount(x) {
    setState(() {
      count = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            // color: Colors.amber,
            border: Border.all(
              width: 1,
              color: primaryAppColor,
            ),
          ),
          height: ht * 0.02,
          width: wt * 0.7,
          child: Row(
            children: [
              Container(
                width: wt * 0.6947 * count / 100,
                height: ht * 0.02,
                color: Colors.green,
              ),
            ],
          ),
        ),
        ElevatedButton(
            onPressed: l
                ? null
                : () async {
                    print(2 / wt);
                    setState(() {
                      l = true;
                      count = 0;
                    });
                    await test(updatecount);
                    setState(() {
                      l = false;
                    });
                  },
            child: Text(count.toString())),
      ],
    );
  }
}

Future<void> test(Function(double) x) async {
  for (double i = 0; i < 101; i++) {
    await Future.delayed(
      Duration(milliseconds: 10),
    );
    x(i);
  }
}
