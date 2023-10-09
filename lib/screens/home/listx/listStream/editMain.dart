import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpens/screens/home/components/ItemInput/ItemInputsMain.dart';

import 'package:xpens/services/database.dart';
import 'package:xpens/services/toast.dart';
import 'package:xpens/shared/constants.dart';

class EditxDetails extends StatefulWidget {
  final String id;
  final dynamic item;

  EditxDetails({
    required this.id,
    required this.item,
  });
  @override
  State<EditxDetails> createState() => _EditxDetailsState();
}

class _EditxDetailsState extends State<EditxDetails> {
  @override
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    // double ht
    void editItem(I) async {
      bool res =
          await DatabaseService(uid: user!.uid).editItem(I: I, id: widget.id);
      String msg = res ? "successfully" : "failed";
      showToast(context: context, msg: "Expense updated " + msg);
      Navigator.pop(context);
    }

    return Center(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Update Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            backgroundColor: primaryAppColor),
        body: SingleChildScrollView(
          child: ItemInputs(
              group: widget.item['group'],
              itemName: widget.item['itemName'],
              costS: widget.item['cost'].toString(),
              date: DateTime.parse(widget.item['date']),
              location: widget.item['location'],
              remarks: widget.item['remarks'],
              time: TimeOfDay(
                  hour: int.parse(widget.item['time'].split(":")[0]),
                  minute: int.parse(widget.item['time'].split(":")[1])),
              buttonLabel: "Update",
              buttonfunc: editItem),
        ),
      ),
    );
  }
}
