import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../services/database.dart';
import '../../../../../services/providers/UserInfoProvider.dart';
import '../../../../../services/toast.dart';
import '../../../../../shared/constants.dart';
import '../../../components/PointInput/PointInputMain.dart';

class EditPointItem extends StatefulWidget {
  const EditPointItem({super.key, required this.id, this.item});
  final String id;
  final dynamic item;

  @override
  State<EditPointItem> createState() => _EditPointItemState();
}

class _EditPointItemState extends State<EditPointItem> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    var userInfo = Provider.of<UserInfoProvider>(context);

    List cards = userInfo.cards;
    // double ht
    void editPointSpent(I) async {
      bool res = await DatabaseService(uid: user!.uid)
          .editPointsSpent(I: I, id: widget.id);
      String msg = res ? "successfully" : "failed";
      showToast(context: context, msg: "Point record updated " + msg);
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
        body: Center(
          child: SingleChildScrollView(
            child: PointInputMain(
                cardName: widget.item['cardName'],
                costS: widget.item['points'].toString(),
                group: "none",
                date: DateTime.parse(widget.item['date']),
                location: locationList[0],
                itemName: widget.item['itemName'],
                time: TimeOfDay(
                    hour: int.parse(widget.item['time'].split(":")[0]),
                    minute: int.parse(widget.item['time'].split(":")[1])),
                buttonLabel: "Add",
                buttonfunc: editPointSpent),
          ),
        ),
      ),
    );
  }
}
