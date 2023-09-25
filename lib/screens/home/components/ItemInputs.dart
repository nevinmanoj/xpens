import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/calendar.dart';
import 'package:xpens/screens/home/components/cost.dart';
import 'package:xpens/screens/home/components/itemName.dart';
import 'package:xpens/screens/home/components/location.dart';
import 'package:xpens/screens/home/components/remarks.dart';
import 'package:xpens/screens/home/components/time.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/datamodals.dart';

import 'group.dart';

class ItemInputs extends StatefulWidget {
  final String itemName;
  final DateTime date;
  final TimeOfDay time;
  final String costS;
  final String remarks;
  final String location;
  final String buttonLabel;
  final String group;
  final Function(AddItem) buttonfunc;

  const ItemInputs(
      {required this.group,
      required this.itemName,
      required this.costS,
      required this.date,
      required this.location,
      required this.remarks,
      required this.time,
      required this.buttonLabel,
      required this.buttonfunc});
  @override
  State<ItemInputs> createState() => _ItemInputsState();
}

class _ItemInputsState extends State<ItemInputs> {
  String itemName = "";
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  String location = locationList[0];
  String group = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController costController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  @override
  void initState() {
    date = widget.date;
    time = widget.time;
    itemName = widget.itemName;
    location = widget.location;
    group = widget.group;
    costController = TextEditingController(text: widget.costS);

    remarksController = TextEditingController(text: widget.remarks);
    super.initState();
  }

  void updateLocation(String newlocation) {
    setState(() {
      location = newlocation;
    });
  }

  void updateGroup(String newgrp) {
    setState(() {
      group = newgrp;
    });
  }

  void updateItemName(String newName) {
    setState(() {
      itemName = newName;
    });
  }

  void updateDate(DateTime newDate) {
    setState(() {
      date = newDate;
    });
  }

  void updatecostctrl(newcontroller) {
    setState(() {
      costController = newcontroller;
    });
  }

  void updateRemarkctrl(newcontroller) {
    setState(() {
      remarksController = newcontroller;
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
    List allItems = Provider.of<UserInfoProvider>(context).items;
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.width;
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
            const SizedBox(
              height: 15,
            ),
            ItemName(
              onNameChange: updateItemName,
              itemName: itemName,
            ),
            const SizedBox(
              height: 15,
            ),
            ItemRemark(
              // onRemarkChanged: updateRemarks,
              onctrlchange: updateRemarkctrl,
              remarks: remarksController.text,
            ),
            const SizedBox(
              height: 15,
            ),
            ItemQuantity(
              // onCostChanged: updateCost,
              costs: costController.text,
              onctrlchange: updatecostctrl,
            ),
            const SizedBox(
              height: 15,
            ),
            // Date(),
            const SizedBox(
              height: 15,
            ),

            SizedBox(
              // height: ht * 0.13,
              width: wt * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Calendar(
                    dateToDisplay: date,
                    onDateChanged: (DateTime newId) {
                      updateDate(newId);
                    },
                  ),
                  Clock(
                    selectTime: time,
                    onTimeChanged: (TimeOfDay newId) {
                      updateTIme(newId);
                    },
                  ),
                ],
              ),
            ),
            ItemGroup(
              itemGroup: group,
              onGroupChange: updateGroup,
            ),
            const SizedBox(
              height: 15,
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

                          // cost = double.parse(costS);
                          double cost = double.parse(costController.text);

                          if (itemName == "Other") {}
                          AddItem I = AddItem(
                              group: group,
                              isOther: (!allItems.contains(itemName.trim())) ||
                                  itemName == "Other",
                              location: location,
                              remarks: remarksController.text.trim(),
                              cost: cost,
                              date: date,
                              itemName: itemName.trim(),
                              time: time);

                          widget.buttonfunc(I);
                          FocusManager.instance.primaryFocus?.unfocus();
                          costController.clear();
                          remarksController.clear();
                          // updateItemName(allItems[0]);
                          // updateDate(DateTime.now());
                          // updateTIme(TimeOfDay.now());
                          // updateLocation(locationList[0]);
                          // updateGroup("none");
                          setState(() {
                            itemName = allItems[0];
                            date = DateTime.now();
                            time = TimeOfDay.now();
                            location = locationList[0];
                            group = "none";
                            loading = false;
                          });
                        }
                      },
                style: buttonDecoration,
                child: Center(
                    child: loading
                        ? const CircularProgressIndicator(
                            color: secondaryAppColor,
                          )
                        : Text(widget.buttonLabel,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16))),
              ),
            ),
          ],
        ));
  }
}
