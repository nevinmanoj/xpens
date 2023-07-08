// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// import 'package:intl/intl.dart';
import 'package:xpens/screens/home/add/cost.dart';
import 'package:xpens/screens/home/add/itemName.dart';
import 'package:xpens/screens/home/add/location.dart';
import 'package:xpens/screens/home/add/remarks.dart';
import 'package:xpens/screens/home/add/welcome.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/toast.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/datamodals.dart';

import 'calendar.dart';
import 'time.dart';

class AddX extends StatefulWidget {
  @override
  State<AddX> createState() => _AddXState();
}

class _AddXState extends State<AddX> {
  // DateTime currentPhoneDate = DateTime.now();
  String itemName = allItems[0];
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  double cost = 0;
  String costS = "";
  String remarks = "";
  String location = locationList[0];
  final _formKey = GlobalKey<FormState>();
  void updateName(String newName) {
    setState(() {
      itemName = newName;
    });
  }

  void updateLocation(String val) {
    setState(() {
      location = val;
    });
  }

  void updateCost(String val) {
    setState(() {
      costS = val;
    });
  }

  void updateDate(DateTime newDate) {
    setState(() {
      date = newDate;
    });
  }

  void updateRemarks(String newRemark) {
    setState(() {
      remarks = newRemark;
    });
  }

  void updateTIme(TimeOfDay newTime) {
    setState(() {
      time = newTime;
    });
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Welcome(),
        SizedBox(
          height: ht * 0.1,
        ),
        Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Location(
                  location: location,
                  onLocationChanged: updateLocation,
                ),
                SizedBox(
                  height: 15,
                ),
                ItemName(
                  onNameChange: updateName,
                  itemName: itemName,
                ),
                SizedBox(
                  height: 15,
                ),
                ItemRemark(
                  onRemarkChanged: updateRemarks,
                  remarks: remarks,
                ),
                SizedBox(
                  height: 15,
                ),
                ItemQuantity(onCostChanged: updateCost, costs: costS),
                SizedBox(
                  height: 15,
                ),
                // Date(),
                SizedBox(
                  height: 15,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    calendar(
                      dateToDisplay: date,
                      onDateChanged: (DateTime newId) {
                        updateDate(newId);
                      },
                    ),
                    clock(
                      selectTime: time,
                      onTimeChanged: (TimeOfDay newId) {
                        updateTIme(newId);
                      },
                    ),
                  ],
                ),

                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: loading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });

                              cost = double.parse(costS);

                              bool res = await DatabaseService(uid: user!.uid)
                                  .addItem(AddItem(
                                      isOther:
                                          !mainItems.contains(itemName.trim()),
                                      location: location,
                                      remarks: remarks.trim(),
                                      cost: cost,
                                      date: date,
                                      itemName: itemName.trim(),
                                      time: time));
                              String msg = res ? "successfully" : "failed";

                              showToast(
                                  context: context,
                                  msg: "Expense added " + msg);
                              remarks = "";
                              setState(() {
                                loading = false;
                              });
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                          },
                    style: buttonDecoration,
                    child: Center(
                        child: loading
                            ? CircularProgressIndicator(
                                color: secondaryAppColor,
                              )
                            : Text("Add",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
