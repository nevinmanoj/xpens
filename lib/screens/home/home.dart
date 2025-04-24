// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:xpens/screens/home/add/addMain.dart';
import 'package:xpens/screens/home/milestone/MilestoneGetx.dart';
import 'package:xpens/screens/home/milestone/MilestoneMain.dart';

import '../../shared/constants.dart';
import 'details/detailsMain.dart';
import 'listx/listMain.dart';
import 'settings/settings.dart';

// var x = Icons.calendar_month;

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    o,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  // List<String> navOptions = ["Add", "List", "Analyze", "Items", "Settings"];

  List navItems = [];
  final popupController = Get.put(MilestonePopupController());
  List<Widget> _widgetOptions = <Widget>[
    AddX(),
    listx(),
    Details(),
    MilestonesMain(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    popupController.setMS(null);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    navItems = [
      {
        "icon": Icon(Icons.add),
        "label": "Add",
      },
      {
        "icon": Icon(Icons.list),
        "label": "List",
      },
      {
        "icon": Icon(Icons.analytics),
        "label": "Analyze",
      },
      {
        // "icon": Icon(FontAwesome.calendar_check),
        "icon": Icon(Icons.checklist),
        "label": "Milestones",
      },
      {
        "icon": Icon(Icons.person_4),
        "label": "Settings",
      }
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Container(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 26,
        showSelectedLabels: false,
        // showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
          for (var x in navItems)
            BottomNavigationBarItem(
              icon: x['icon'],
              label: x['label'],
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
    // });
  }
}
