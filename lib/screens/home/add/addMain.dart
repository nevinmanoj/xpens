// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/add/welcome.dart';
import 'package:xpens/screens/home/components/ItemInput/ItemInputsMain.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/utils/toast.dart';
import 'package:xpens/shared/constants.dart';

import '../../../shared/dataModals/AddItemModal.dart';
import '../../../shared/dataModals/AddPointModal.dart';
import '../components/PointInput/PointInputMain.dart';

class AddX extends StatefulWidget {
  const AddX({super.key});

  @override
  State<AddX> createState() => _AddXState();
}

class _AddXState extends State<AddX> {
  @override
  Widget build(BuildContext context) {
    var userInfo = Provider.of<UserInfoProvider>(context);
    List allItems = userInfo.items;
    List defaults = userInfo.defaults;
    List cards = userInfo.cards;
    String option = userInfo.option;
    var optionDefault = defaults
        .firstWhereOrNull((element) => element["type"] == option.toLowerCase());
    // if(defaults["expense"]!=null){

    // }

    double ht = MediaQuery.of(context).size.height;
    final user = Provider.of<User?>(context);
    void addItem(AddItem I) async {
      bool res = await DatabaseService(uid: user!.uid).addItem(I);
      String msg = res ? "successfully" : "failed";

      showToast(context: context, msg: "Expense added $msg");
    }

    void addPointSpent(AddPoint I) async {
      bool res = await DatabaseService(uid: user!.uid).addPointSpent(I);
      String msg = res ? "successfully" : "failed";

      showToast(context: context, msg: "Expense added $msg");
    }

    String notNullReturnValue(key, defaultValue) {
      return optionDefault == null || optionDefault[key] == null
          ? defaultValue.toString()
          : optionDefault[key].toString();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Welcome(),
          SizedBox(
            height: ht * 0.075,
          ),
          // AddxInputs()
          option == "Expense"
              ? ItemInputs(
                  optionDefault: optionDefault,
                  isData: true,
                  itemName: notNullReturnValue("itemName", allItems[0]),
                  costS: notNullReturnValue("cost", ""),
                  group: notNullReturnValue("group", "none"),
                  date: DateTime.parse(
                      notNullReturnValue("date", DateTime.now())),
                  location: notNullReturnValue("location", locationList[0]),
                  remarks: notNullReturnValue("remarks", ""),
                  time: TimeOfDay(
                      hour: int.parse(
                          notNullReturnValue("time", TimeOfDay.now())
                              .split(":")[0]),
                      minute: int.parse(
                          notNullReturnValue("time", TimeOfDay.now())
                              .split(":")[1])),
                  buttonLabel: "Add",
                  buttonfunc: addItem)
              : PointInputMain(
                  cardName: cards[0],
                  costS: "",
                  group: "none",
                  date: DateTime.now(),
                  location: locationList[0],
                  itemName: "",
                  time: TimeOfDay.now(),
                  buttonLabel: "Add",
                  buttonfunc: addPointSpent)
        ],
      ),
    );
  }
}
