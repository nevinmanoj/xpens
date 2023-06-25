import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpens/screens/home/listx/listxfilter/filterButtons.dart';
import 'package:xpens/screens/home/listx/listxfilter/locationFilter.dart';
import 'package:xpens/screens/home/listx/listxfilter/namefilter.dart';
import 'package:xpens/shared/constants.dart';

class FilterWindow extends StatefulWidget {
  final Function(dynamic) onStreamChange;
  FilterWindow({required this.onStreamChange});
  @override
  State<FilterWindow> createState() => _FilterWindowState();
}

class _FilterWindowState extends State<FilterWindow> {
  Color backdropColor = Color(0x66C4C4C4);
  bool showFilter = false;
  double _height = 0;
  String? name;
  String? location;
  void clearFilters() {
    setState(() {
      name = null;
      location = null;
      widget.onStreamChange(FirebaseFirestore.instance
          .collection('UserInfo/${FirebaseAuth.instance.currentUser!.uid}/list')
          .orderBy('date', descending: true));
    });
    toggleFilter();
  }

  void namechange(newName) {
    setState(() {
      name = newName;
    });
  }

  void locchange(newLoc) {
    setState(() {
      location = newLoc;
    });
  }

  void toggleFilter() {
    if (showFilter) {
      //hide filter
      setState(() {
        backdropColor = Colors.white;
        _height = 0;
        showFilter = false;
      });
    } else {
      //show filter
      setState(() {
        backdropColor = Color(0x66C4C4C4);
        _height = 500;
        showFilter = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;

    if (showFilter) {
      return Container(
        height: ht,
        child: Stack(
          children: [
            InkWell(
              onTap: toggleFilter,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                curve: Curves.fastOutSlowIn,
                color: backdropColor,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                // padding: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40)),
                ),
                height: _height,
                width: wt,
                duration: Duration(milliseconds: 1000),
                curve: Curves.fastOutSlowIn,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: ListView(children: [
                        NameRadioAccordion(
                          onNameChange: namechange,
                          selectedOption: name,
                        ),
                        LocRadioAccordion(
                          onLocChange: locchange,
                          selectedOption: location,
                        ),
                        FilterBtns(
                          clearFilters: clearFilters,
                          toggleFilter: toggleFilter,
                          onStreamChange: widget.onStreamChange,
                          name: name,
                          location: location,
                        )
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, ht * 0.02, wt * 0.08, 0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: toggleFilter,
                          child: Icon(Icons.close),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
    return Positioned(
      bottom: 10,
      right: 10,
      child: InkWell(
        onTap: toggleFilter,
        child: Container(
          height: 60,
          width: 60,
          decoration:
              BoxDecoration(color: primaryAppColor, shape: BoxShape.circle),
          child: Icon(
            Icons.sort,
            color: secondaryAppColor,
          ),
        ),
      ),
    );
  }
}
