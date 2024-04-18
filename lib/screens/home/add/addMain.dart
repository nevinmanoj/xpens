// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/add/welcome.dart';
import 'package:xpens/screens/home/components/ItemInput/ItemInputsMain.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/utils/toast.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/ExpenseModal.dart';

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
    List cards = userInfo.cards;
    String option = userInfo.option;
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

    return SingleChildScrollView(
      child: Column(
        children: [
          Welcome(),
          SizedBox(
            height: ht * 0.075,
          ),
          // AddxInputs()
          option == "Expenses"
              ? ItemInputs(
                  itemName: allItems[0],
                  costS: "",
                  group: "none",
                  date: DateTime.now(),
                  location: locationList[0],
                  remarks: "",
                  time: TimeOfDay.now(),
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
