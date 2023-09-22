// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:xpens/screens/home/add/addMain.dart';

import 'package:xpens/screens/home/listx/listMain.dart';
import 'package:xpens/services/providers.dart';

import '../../shared/constants.dart';
import 'details/detailsMain.dart';
import 'settings/settings.dart';

// var x = Icons.calendar_month;
List<String> navOptions = ["Addx", "Listx", "Analyze", "Settings"];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    AddX(),
    listx(),
    Details(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        toolbarHeight: 0,
      ),
      // appBar: _selectedIndex == 1
      //     ? AppBar(
      //         centerTitle: true,
      //         title: Text(userInfo.userName),
      //         // title: StreamBuilder<QuerySnapshot>(
      //         //     stream: FirebaseFirestore.instance
      //         //         .collection('UserInfo/${user!.uid}/list')
      //         //         .snapshots(),
      //         //     builder: (context, snap) {
      //         //       if (snap.connectionState == ConnectionState.waiting) {
      //         //         return Container();
      //         //       }
      //         //       return Text(
      //         //         "Total Expenses Count: ${snap.data?.docs.length}",
      //         //         style: TextStyle(
      //         //             fontSize: 22,
      //         //             fontWeight: FontWeight.w400,
      //         //             color: Color.fromARGB(255, 168, 168, 168)),
      //         //       );
      //         //     }),
      //         backgroundColor: Colors.black,
      //       )
      //     : AppBar(
      //         backgroundColor: primaryAppColor,
      //         toolbarHeight: 0,
      //       ),
      body: SafeArea(
        child: Container(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: navOptions[0],
            backgroundColor: primaryAppColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: navOptions[1],
            backgroundColor: primaryAppColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: navOptions[2],
            backgroundColor: primaryAppColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: navOptions[3],
            backgroundColor: primaryAppColor,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: secondaryAppColor,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
