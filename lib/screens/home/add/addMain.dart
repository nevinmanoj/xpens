// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/add/welcome.dart';
import 'package:xpens/screens/home/components/ItemInputs.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/providers.dart';
import 'package:xpens/services/toast.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/datamodals.dart';

class AddX extends StatefulWidget {
  @override
  State<AddX> createState() => _AddXState();
}

class _AddXState extends State<AddX> {
  @override
  Widget build(BuildContext context) {
    List allItems = Provider.of<UserInfoProvider>(context).items;
    double ht = MediaQuery.of(context).size.height;
    final user = Provider.of<User?>(context);
    void addItem(AddItem I) async {
      bool res = await DatabaseService(uid: user!.uid).addItem(I);
      String msg = res ? "successfully" : "failed";

      showToast(context: context, msg: "Expense added $msg");
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Welcome(),
          SizedBox(
            height: ht * 0.1,
          ),
          // AddxInputs()
          ItemInputs(
              itemName: allItems[0],
              costS: "",
              date: DateTime.now(),
              location: locationList[0],
              remarks: "",
              time: TimeOfDay.now(),
              buttonLabel: "Add",
              buttonfunc: addItem)
        ],
      ),
    );
  }
}
