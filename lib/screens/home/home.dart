import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:xpens/screens/home/add/add.dart';
import 'package:xpens/screens/home/dev/devDash.dart';
import 'package:xpens/screens/home/listx/list.dart';

import '../../shared/constants.dart';
import 'details/details.dart';
import 'settings/settings.dart';

var x = Icons.calendar_month;
List<String> navOptions = ["Addx", "Listx", "Details", "Settings"];

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
    double wt = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,

      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           Navigator.push(context,CupertinoPageRoute(builder: (context) => DevDash()));
      //         },
      //         icon: Icon(Icons.logo_dev))
      //   ],
      //   centerTitle: true,
      //   title: Text(navOptions[_selectedIndex]),
      //   backgroundColor: Colors.black,
      // ),
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
