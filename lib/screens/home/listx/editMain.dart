import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpens/screens/home/add/calendar.dart';
import 'package:xpens/screens/home/add/location.dart';
import 'package:xpens/screens/home/add/time.dart';
import 'package:xpens/screens/home/listx/editCost.dart';
import 'package:xpens/screens/home/listx/editName.dart';
import 'package:xpens/screens/home/listx/editRemark.dart';
import 'package:xpens/shared/constants.dart';

import 'package:intl/intl.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/toast.dart';

import 'package:xpens/shared/datamodals.dart';

class EditxDetails extends StatefulWidget {
  String id;
  var item;

  String costS = "";

  EditxDetails({
    required this.id,
    required this.item,
  });
  @override
  State<EditxDetails> createState() => _EditxDetailsState();
}

class _EditxDetailsState extends State<EditxDetails> {
  final _formKey = GlobalKey<FormState>();
  void updateLocation(String val) {
    setState(() {
      widget.item['location'] = val;
    });
  }

  void updateDate(DateTime newDate) {
    setState(() {
      widget.item['date'] = newDate.toString();
    });
  }

  void updateName(String newName) {
    setState(() {
      print("updated name $newName");
      widget.item['itemName'] = newName.toString();
    });
  }

  void updateRemark(String newRemark) {
    setState(() {
      widget.item['remarks'] = newRemark;
    });
  }

  void updateCost(String newCost) {
    setState(() {
      widget.costS = newCost;
    });
  }

  void updateTIme(TimeOfDay newTime) {
    setState(() {
      widget.item['time'] = DateFormat('HH:mm')
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
        appBar: AppBar(
            // leading: BackButton(
            //   onPressed: () {
            //     setState(() {
            //       print(widget.itembackup);
            //       widget.item = widget.itembackup;
            //     });

            //     // Navigator.pop(context);
            //   },
            // ),
            centerTitle: true,
            title: Text(
              "Update Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            backgroundColor: primaryAppColor),
        body: Form(
            key: _formKey,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Location(
                  location: widget.item['location'],
                  onLocationChanged: updateLocation,
                ),
                SizedBox(
                  height: 15,
                ),
                ItemName(
                  name: widget.item['itemName'],
                  onNameChanged: updateName,
                  // hideOther: cItems.contains(widget.item['itemName']),
                ),
                SizedBox(
                  height: 15,
                ),
                ItemRemark(
                  remark: widget.item['remarks'],
                  onRemarkChanged: (String newId) {
                    updateRemark(newId);
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                ItemQuantity(
                  cost: widget.item['cost'].toString(),
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
                      dateToDisplay: DateTime.parse(widget.item['date']),
                      onDateChanged: (DateTime newId) {
                        updateDate(newId);
                      },
                    ),
                    clock(
                      SelectTime: TimeOfDay(
                          hour: int.parse(widget.item['time'].split(":")[0]),
                          minute: int.parse(widget.item['time'].split(":")[1])),
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
                        double cost = widget.costS != ""
                            ? double.parse(widget.costS)
                            : widget.item['cost'];
                        bool res = await DatabaseService(uid: user!.uid)
                            .editItem(
                                I: AddItem(
                                    location: widget.item['location'],
                                    remarks: widget.item['remarks']
                                        .toString()
                                        .trim(),
                                    cost: cost,
                                    date: DateTime.parse(widget.item['date']),
                                    itemName: widget.item['itemName']
                                        .toString()
                                        .trim(),
                                    time: TimeOfDay(
                                        hour: int.parse(
                                            widget.item['time'].split(":")[0]),
                                        minute: int.parse(widget.item['time']
                                            .split(":")[1]))),
                                id: widget.id);
                        String msg = res ? "successfully" : "failed";
                        showToast(
                            context: context, msg: "Expense updated " + msg);
                        Navigator.pop(context);
                      }
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryAppColor)),
                    child: const Center(
                        child: Text("Update",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16))),
                  ),
                ),
              ],
            )),
      ),
    );
    ;
  }
}
