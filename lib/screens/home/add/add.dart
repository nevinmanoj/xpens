import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/other.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/datamodals.dart';

import 'calendar.dart';
import 'time.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;
List<String> cItems = [
  "Breakfast",
  "Lunch",
  "Dinner",
  "Tea and Snacks",
  "Petrol",
  "Other"
];
DateTime currentPhoneDate = DateTime.now();
String itemName = cItems[0];
double cost = 0;
String costS = "";
DateTime date = DateTime.now();
TimeOfDay time = TimeOfDay.now();

class AddX extends StatefulWidget {
  @override
  State<AddX> createState() => _AddXState();
}

class _AddXState extends State<AddX> {
  final _formKey = GlobalKey<FormState>();
  void updateDate(DateTime newDate) {
    setState(() {
      date = newDate;
    });
  }

  void updateTIme(TimeOfDay newTime) {
    setState(() {
      time = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Center(
      child: Form(
          key: _formKey,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ItemName(),
              SizedBox(
                height: 15,
              ),
              ItemQuantity(),
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
                    SelectTime: time,
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      cost = double.parse(costS);
                      bool res = await DatabaseService(uid: user!.uid).addItem(
                          Item(
                              cost: cost,
                              date: date,
                              itemName: itemName,
                              time: time)) as bool;
                      String msg = res ? "successfully" : "failed";
                      showToast(context: context, msg: "Expense added " + msg);
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(primaryAppColor)),
                  child: Center(
                      child: Text("Add ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16))),
                ),
              ),
            ],
          )),
    );
    ;
  }
}

class ItemName extends StatefulWidget {
  const ItemName({Key? key}) : super(key: key);

  @override
  State<ItemName> createState() => _ItemNameState();
}

class _ItemNameState extends State<ItemName> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200]?.withOpacity(0.6),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
                // spreadRadius: 4, blurRadius: 4,
                // offset: Offset(6, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: DropdownButtonFormField<String>(
              value: cItems[0],
              validator: (value) =>
                  value!.isEmpty ? ' Must select a category for item' : null,
              decoration: InputDecoration(border: InputBorder.none),
              hint: Text(
                "Category of Item",
                style: TextStyle(color: Colors.grey.withOpacity(0.8)),
              ),
              onChanged: (Value) {
                setState(() {
                  itemName = Value!;
                });
              },
              items: cItems.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 10),
        itemName == "Other"
            ? Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]?.withOpacity(0.6),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
                      // spreadRadius: 4, blurRadius: 4,
                      // offset: Offset(6, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: TextFormField(
                    onChanged: (value) {
                      itemName = value;
                    },
                    validator: (value) =>
                        value!.isEmpty ? ' Name cannot be empty' : null,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                      hintText: 'Item Name',
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

class ItemQuantity extends StatefulWidget {
  const ItemQuantity({Key? key}) : super(key: key);

  @override
  State<ItemQuantity> createState() => _ItemQuantityState();
}

class _ItemQuantityState extends State<ItemQuantity> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200]?.withOpacity(0.6),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
            // spreadRadius: 4, blurRadius: 4,
            // offset: Offset(6, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: TextFormField(
          cursorColor: primaryAppColor,
          cursorWidth: 1,
          onChanged: (value) {
            costS = value;
          },
          validator: (value) => value!.isEmpty ? 'Cost must not be null' : null,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
            hintText: 'Cost',
          ),
        ),
      ),
    );
  }
}
