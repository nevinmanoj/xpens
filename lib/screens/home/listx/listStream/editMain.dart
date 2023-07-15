import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpens/screens/home/components/calendar.dart';
import 'package:xpens/screens/home/components/cost.dart';
import 'package:xpens/screens/home/components/itemName.dart';
import 'package:xpens/screens/home/components/location.dart';
import 'package:xpens/screens/home/components/remarks.dart';
import 'package:xpens/screens/home/components/time.dart';
import 'package:xpens/shared/constants.dart';

import 'package:intl/intl.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/toast.dart';

import 'package:xpens/shared/datamodals.dart';

class EditxDetails extends StatefulWidget {
  String id;
  final dynamic item;

  EditxDetails({
    required this.id,
    required this.item,
  });
  @override
  State<EditxDetails> createState() => _EditxDetailsState();
}

class _EditxDetailsState extends State<EditxDetails> {
  final _formKey = GlobalKey<FormState>();

  String itemName = "";
  String remarks = "";
  String location = "";
  String date = "";
  String time = "";
  String costS = "";
  @override
  void initState() {
    super.initState();
    location = widget.item['location'];
    itemName = widget.item['itemName'];
    remarks = widget.item['remarks'];
    date = widget.item['date'];
    time = widget.item['time'];
    costS = widget.item['cost'].toString();
  }

  void updateLocation(String val) {
    setState(() {
      // widget.item['location'] = val;
      location = val;
    });
  }

  void updateDate(DateTime newDate) {
    setState(() {
      // widget.item['date'] = newDate.toString();
      date = newDate.toString();
    });
  }

  void updateName(String newName) {
    setState(() {
      // widget.item['itemName'] = newName.toString();
      itemName = newName;
    });
  }

  void updateRemark(String newRemark) {
    setState(() {
      // widget.item['remarks'] = newRemark;
      remarks = newRemark;
    });
  }

  void updateCost(String newCost) {
    setState(() {
      // widget.costS = newCost;
      costS = newCost;
    });
  }

  void updateTIme(TimeOfDay newTime) {
    setState(() {
      // widget.item['time'] = DateFormat('HH:mm')
      //     .format(DateTime(0, 0, 0, newTime.hour, newTime.minute));
      time = DateFormat('HH:mm')
          .format(DateTime(0, 0, 0, newTime.hour, newTime.minute));
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Center(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            // leading: BackButton(
            //   onPressed: () {
            //     setState(() {
            //       widget.item = widget.item;
            //     });

            //     Navigator.pop(context);
            //   },
            // ),
            centerTitle: true,
            title: Text(
              "Update Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            backgroundColor: primaryAppColor),
        body: Center(
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Location(
                      // location: widget.item['location'],
                      location: location,
                      onLocationChanged: updateLocation,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ItemName(
                      itemName: itemName,
                      onNameChange: updateName,
                      // hideOther: cItems.contains(widget.item['itemName']),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ItemRemark(
                      remarks: remarks,
                      onRemarkChanged: (String newId) {
                        updateRemark(newId);
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ItemQuantity(
                      costs: costS,
                      onCostChanged: (String newId) {
                        updateCost(newId);
                      },
                    ),
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
                          dateToDisplay: DateTime.parse(date),
                          onDateChanged: (DateTime newId) {
                            updateDate(newId);
                          },
                        ),
                        clock(
                          selectTime: TimeOfDay(
                              hour: int.parse(time.split(":")[0]),
                              minute: int.parse(time.split(":")[1])),
                          onTimeChanged: (TimeOfDay newId) {
                            updateTIme(newId);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // double cost = widget.costS != ""
                            //     ? double.parse(widget.costS)
                            //     : widget.item['cost'];
                            double cost = double.parse(costS);

                            bool res = await DatabaseService(uid: user!.uid)
                                .editItem(
                                    I: AddItem(
                                        isOther: !mainItems.contains(
                                            itemName.toString().trim()),
                                        location: location,
                                        remarks: remarks.toString().trim(),
                                        cost: cost,
                                        date: DateTime.parse(date),
                                        itemName: itemName.toString().trim(),
                                        time: TimeOfDay(
                                            hour: int.parse(time.split(":")[0]),
                                            minute:
                                                int.parse(time.split(":")[1]))),
                                    id: widget.id);
                            String msg = res ? "successfully" : "failed";
                            showToast(
                                context: context,
                                msg: "Expense updated " + msg);
                            Navigator.pop(context);
                          }
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                primaryAppColor)),
                        child: const Center(
                            child: Text("Update",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16))),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
    ;
  }
}
