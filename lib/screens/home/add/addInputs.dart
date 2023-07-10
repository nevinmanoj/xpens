import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpens/screens/home/components/calendar.dart';
import 'package:xpens/screens/home/components/cost.dart';
import 'package:xpens/screens/home/components/itemName.dart';
import 'package:xpens/screens/home/components/location.dart';
import 'package:xpens/screens/home/components/remarks.dart';
import 'package:xpens/screens/home/components/time.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/toast.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/datamodals.dart';

class AddxInputs extends StatefulWidget {
  const AddxInputs({super.key});

  @override
  State<AddxInputs> createState() => _AddxInputsState();
}

class _AddxInputsState extends State<AddxInputs> {
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
    return Form(
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
                                  isOther: !mainItems.contains(itemName.trim()),
                                  location: location,
                                  remarks: remarks.trim(),
                                  cost: cost,
                                  date: date,
                                  itemName: itemName.trim(),
                                  time: time));
                          String msg = res ? "successfully" : "failed";

                          showToast(
                              context: context, msg: "Expense added " + msg);
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
        ));
  }
}
