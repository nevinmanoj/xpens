// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';

import 'package:xpens/screens/home/add/addMain.dart';

import '../../shared/constants.dart';
import 'details/detailsMain.dart';
import 'items/itemList.dart';
import 'listx/listMain.dart';
import 'settings/settings.dart';

// var x = Icons.calendar_month;
List<String> navOptions = ["Add", "List", "Analyze", "Items", "Settings"];

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
    ItemList(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User?>(context);

    // return ChangeNotifierProvider(
    //     create: (context) => ExpenseDataProvider(user: user!),
    //     builder: (context, _) {
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
        iconSize: 26,
        showSelectedLabels: false,
        // showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: navOptions[0],
            // label: "",
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
            icon: Icon(Icons.category),
            label: navOptions[3],
            backgroundColor: primaryAppColor,
          ),
          BottomNavigationBarItem(
            // icon: Icon(Icons.settings),
            icon: Icon(Icons.person_4),
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
    // });
  }
}
