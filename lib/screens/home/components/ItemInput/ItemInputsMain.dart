import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ItemInput/calendar.dart';
import 'package:xpens/screens/home/components/ItemInput/cost.dart';
import 'package:xpens/screens/home/components/ItemInput/itemName.dart';
import 'package:xpens/screens/home/components/ItemInput/location.dart';
import 'package:xpens/screens/home/components/ItemInput/remarks.dart';
import 'package:xpens/screens/home/components/ItemInput/time.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/dbModals/expenseDefault.dart';

import '../../../../shared/dataModals/AddItemModal.dart';
import '../../../../shared/utils/toast.dart';
import 'group.dart';

class ItemInputs extends StatefulWidget {
  final bool isData;
  final String itemName;
  final DateTime? date;
  final TimeOfDay time;
  final String costS;
  final String remarks;
  final String location;
  final String buttonLabel;
  final String group;
  final Function buttonfunc;
  final dynamic optionDefault;

  const ItemInputs(
      {super.key,
      required this.optionDefault,
      required this.isData,
      required this.group,
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
  DateTime? date = DateTime.now();
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
    print("changed group to: $newgrp");
  }

  void updateItemName(String newName) {
    setState(() {
      itemName = newName;
    });
  }

  void updateDate(DateTime? newDate) {
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

  String notNullReturnValue(key, defaultValue) {
    return widget.optionDefault == null || widget.optionDefault[key] == null
        ? defaultValue.toString()
        : widget.optionDefault[key].toString();
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    List allItems = Provider.of<UserInfoProvider>(context).items;
    double wt = MediaQuery.of(context).size.width;
    // double ht = MediaQuery.of(context).size.width;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      enableFeedback: false,
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Form(
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
                required: false,
                // onRemarkChanged: updateRemarks,
                hint: "Remarks",
                onctrlchange: updateRemarkctrl,
                remarks: remarksController.text,
              ),
              const SizedBox(
                height: 15,
              ),
              ItemQuantity(
                hint: "Cost",
                enabled: true,
                req: widget.isData,
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
                      isData: widget.isData,
                      dateToDisplay: date,
                      onDateChanged: (DateTime? newId) {
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

                            double cost = 0;
                            bool costConvFailed = false;
                            try {
                              cost = double.parse(costController.text);
                            } catch (e) {
                              costConvFailed = true;
                              if (widget.isData) {
                                showToast(
                                    context: context,
                                    msg: "Invalid value for cost");
                                costController.clear();
                                setState(() {
                                  loading = false;
                                });
                                return;
                              }
                            }
                            if (widget.isData) {
                              AddItem I = AddItem(
                                  group: group,
                                  isOther:
                                      (!allItems.contains(itemName.trim())) ||
                                          itemName == "Other",
                                  location: location,
                                  remarks: remarksController.text.trim(),
                                  cost: cost,
                                  date: date!,
                                  itemName: itemName.trim(),
                                  time: time);

                              widget.buttonfunc(I);
                            } else {
                              ExpenseDefault I = ExpenseDefault(
                                location: location,
                                date: date,
                                cost: costConvFailed ? null : cost,
                                itemName: itemName.trim(),
                                time: time,
                                group: group,
                                remarks: remarksController.text.trim(),
                              );
                              widget.buttonfunc(I);
                            }

                            FocusManager.instance.primaryFocus?.unfocus();
                            costController.clear();
                            remarksController.clear();

                            if (widget.isData) {
                              if (widget.optionDefault == null) {
                                setState(() {
                                  itemName = allItems[0];
                                  date = DateTime.now();
                                  time = TimeOfDay.now();
                                  location = locationList[0];
                                  group = "none";
                                });
                              } else {
                                setState(() {
                                  itemName = notNullReturnValue(
                                      "itemName", allItems[0]);

                                  group = notNullReturnValue("group", "none");

                                  costController.text =
                                      notNullReturnValue("cost", "");
                                  date = DateTime.parse(notNullReturnValue(
                                      "date", DateTime.now()));
                                  location = notNullReturnValue(
                                      "location", locationList[0]);
                                  remarksController.text =
                                      notNullReturnValue("remarks", "");

                                  time = TimeOfDay(
                                      hour: int.parse(notNullReturnValue(
                                              "time", TimeOfDay.now())
                                          .split(":")[0]),
                                      minute: int.parse(notNullReturnValue(
                                              "time", TimeOfDay.now())
                                          .split(":")[1]));
                                });
                              }
                            }
                            setState(() {
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
          )),
    );
  }
}
