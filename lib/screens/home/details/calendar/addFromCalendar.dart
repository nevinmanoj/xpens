import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ItemInputs.dart';

import 'package:xpens/services/database.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/services/toast.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/datamodals.dart';

class AddFromCal extends StatefulWidget {
  final DateTime date;
  const AddFromCal({super.key, required this.date});

  @override
  State<AddFromCal> createState() => _AddFromCalState();
}

class _AddFromCalState extends State<AddFromCal> {
  @override
  Widget build(BuildContext context) {
    print(widget.date);
    final user = Provider.of<User?>(context);
    dynamic addItem(AddItem item) async {
      bool res = await DatabaseService(uid: user!.uid).addItem(item);
      String msg = res ? "successfully" : "failed";

      showToast(context: context, msg: "Expense added $msg");
    }

    List allItems = Provider.of<UserInfoProvider>(context).items;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(backgroundColor: primaryAppColor),
      body: Center(
        child: ItemInputs(
            group: "none",
            itemName: allItems[0],
            costS: "",
            date: widget.date,
            location: locationList[0],
            remarks: "",
            time: TimeOfDay.now(),
            buttonLabel: "Add",
            buttonfunc: addItem),
      ),
    );
  }
}
