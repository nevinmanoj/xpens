import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../services/database.dart';
import '../../../../../shared/utils/toast.dart';
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

    // double ht
    void editPointSpent(I) async {
      bool res = await DatabaseService(uid: user!.uid)
          .editPointsSpent(I: I, id: widget.id);
      if (!context.mounted) return;
      showToast(
          context: context,
          msg: res ? "Points entry updated" : "Couldn't update the entry");
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text("Edit points"), backgroundColor: primaryAppColor),
      body: SingleChildScrollView(
        child: PointInputMain(
            sourceId: widget.item['sourceId'],
            cardName: widget.item['cardName'],
            costS: widget.item['points'].toString(),
            group: "none",
            date: DateTime.parse(widget.item['date']),
            location: locationList[0],
            itemName: widget.item['itemName'],
            time: TimeOfDay(
                hour: int.parse(widget.item['time'].split(":")[0]),
                minute: int.parse(widget.item['time'].split(":")[1])),
            buttonLabel: "Save",
            buttonfunc: editPointSpent),
      ),
    );
  }
}
