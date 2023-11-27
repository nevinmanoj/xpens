// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  List<PopupMenuEntry<String>> options = [
    getwidget("Expenses"),
    getwidget("Points")
  ];
  String selecteditem = "Expenses";
  @override
  Widget build(BuildContext context) {
    // var userInfo = Provider.of<UserInfoProvider>(context);
    var userInfo = context.watch<UserInfoProvider>();
    // final user = Provider.of<User?>(context);
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.fromLTRB(wt * 0.03, ht * 0.009, 0, 0),
      width: wt,
      height: ht * 0.11,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                userInfo.userName,
                style: TextStyle(fontSize: 25),
              )
            ],
          ),
          PopupMenuButton<String>(
            child: Container(
              alignment: Alignment.center,
              height: ht * 0.07,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
                  ),
                ],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    topLeft: Radius.circular(40)),
              ),
              width: wt * 0.4,
              child: ListTile(
                leading: Icon(geticon(userInfo.option)),
                title: Text(userInfo.option),
              ),
            ),
            onSelected: (value) {
              userInfo.setOption(value);
            },
            itemBuilder: (BuildContext context) => options,
          ),
        ],
      ),
    );
  }
}

PopupMenuItem<String> getwidget(value) {
  return PopupMenuItem<String>(
    value: '$value',
    child: ListTile(
      leading: Icon(geticon(value)),
      title: Text('$value'),
    ),
  );
}

IconData geticon(value) {
  switch (value) {
    case "Expenses":
      return Icons.currency_rupee;

    case "Points":
      return Icons.star;

    default:
      return Icons.currency_rupee;
  }
}
