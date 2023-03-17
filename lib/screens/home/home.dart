import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:xpens/screens/home/add/add.dart';
import 'package:xpens/screens/home/listx/list.dart';

import '../../shared/constants.dart';
import 'details/details.dart';
import 'settings/settings.dart';

List<String> navOptions = ["addx", "Listx", "Details", "Settings"];
final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(navOptions[_selectedIndex]),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
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
