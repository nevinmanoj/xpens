import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpens/screens/home/add/calendar.dart';
import 'package:xpens/screens/home/add/time.dart';
import 'package:xpens/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/other.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/datamodals.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;

List<String> cItems = [
  "Breakfast",
  "Lunch",
  "Dinner",
  "Tea",
  "Petrol",
  "Other"
];
DateTime currentPhoneDate = DateTime.now();
String itemName = "";
double cost = 0;
String costS = "";
DateTime date = DateTime.now();
TimeOfDay time = TimeOfDay.now();

class editx extends StatefulWidget {
  const editx({super.key});

  @override
  State<editx> createState() => _editxState();
}

class _editxState extends State<editx> {
  @override
  Widget build(BuildContext context) {
    return Icon(
      color: primaryAppColor,
      Icons.edit,
    );
  }
}

class editxDetails extends StatefulWidget {
  String id;
  var item;
  editxDetails({required this.id, required this.item});
  @override
  State<editxDetails> createState() => _editxDetailsState();
}

class _editxDetailsState extends State<editxDetails> {
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
    itemName = widget.item['itemName'];
    costS = widget.item['cost'].toString();
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Center(
      child: Scaffold(
        appBar: AppBar(
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
                SizedBox(
                  height: 15,
                ),
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
                        cost = double.parse(costS);
                        bool res = await DatabaseService(uid: user!.uid)
                            .editItem(
                                I: Item(
                                    cost: cost,
                                    date: date,
                                    itemName: itemName,
                                    time: time),
                                id: widget.id) as bool;
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
                    child: Center(
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
              value: itemName,
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
          initialValue: costS,
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
