import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ItemInput/calendar.dart';
import 'package:xpens/screens/home/components/ItemInput/cost.dart';
import 'package:xpens/screens/home/components/ItemInput/inputAutofill.dart';

import 'package:xpens/screens/home/components/ItemInput/time.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';

import '../../../../shared/dataModals/AddPointModal.dart';
import 'cardName.dart';

class PointInputMain extends StatefulWidget {
  final String cardName;
  final DateTime date;
  final TimeOfDay time;
  final String costS;
  final String itemName;
  final String location;
  final String buttonLabel;
  final String group;
  final Function(AddPoint) buttonfunc;

  const PointInputMain(
      {super.key,
      required this.group,
      required this.cardName,
      required this.costS,
      required this.date,
      required this.location,
      required this.itemName,
      required this.time,
      required this.buttonLabel,
      required this.buttonfunc});
  @override
  State<PointInputMain> createState() => _PointInputMainState();
}

class _PointInputMainState extends State<PointInputMain> {
  String cardName = "";
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  String location = locationList[0];
  String group = "";
  String itemName = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController costController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  @override
  void initState() {
    date = widget.date;

    time = widget.time;
    cardName = widget.cardName;
    location = widget.location;
    group = widget.group;
    costController = TextEditingController(text: widget.costS);
    itemName = widget.itemName;
    super.initState();
  }

  void updateCardName(String newName) {
    setState(() {
      cardName = newName;
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

  void updateTIme(TimeOfDay newTime) {
    setState(() {
      time = newTime;
    });
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    print(itemName);
    var userInfo = Provider.of<UserInfoProvider>(context);
    List cards = userInfo.cards;
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
              CardName(
                onNameChange: updateCardName,
                itemName: cardName,
              ),
              InputAutoFill(
                onValueChange: updateItemName,
                docs: userInfo.pointDocs,
                tag: 'itemName',
                value: itemName,
              ),
              ItemQuantity(
                req: true,
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
                            widget.buttonfunc(AddPoint(
                                card: cardName,
                                time: time,
                                date: date,
                                point: cost,
                                itemName: itemName));

                            FocusManager.instance.primaryFocus?.unfocus();
                            costController.clear();

                            setState(() {
                              cardName = cards[0];
                              date = DateTime.now();
                              time = TimeOfDay.now();
                              loading = false;
                              date = widget.date;
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
