// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xpens/screens/home/listx/listStream/editMain.dart';

import 'package:xpens/services/database.dart';
import 'package:xpens/services/toast.dart';
import 'package:xpens/shared/constants.dart';

import 'EditListPointItem.dart';

class ExpandPointItem extends StatefulWidget {
  final String id;

  final String date;

  final item;
  ExpandPointItem({required this.id, required this.date, required this.item});
  @override
  State<ExpandPointItem> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ExpandPointItem> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Center(
        child: SizedBox(
      width: wt * 0.9,
      height: ht * 0.5,
      child: AlertDialog(
          insetPadding: EdgeInsets.fromLTRB(
            0,
            0,
            0,
            ht * 0.1,
          ),
          title: Center(
              child: Text(
            "Point Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          content: Column(children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: wt * 0.7,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: wt * 0.3, child: Text("Item Name")),

                  Text(": "),
                  Spacer(),
                  //
                  Text(
                    widget.item['itemName'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
              width: wt * 0.7,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: wt * 0.3, child: Text("Points used")),
                  Text(": "),
                  Spacer(),
                  Text(
                    "${widget.item['points']}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
              width: wt * 0.7,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: wt * 0.3, child: Text("Item Date")),
                  Text(": "),
                  Spacer(),
                  Text(
                    widget.date,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
              width: wt * 0.7,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: wt * 0.3, child: Text("Card")),
                  Text(": "),
                  Spacer(),
                  Text(
                    widget.item['cardName'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => EditPointItem(
                                    id: widget.id,
                                    item: widget.item,
                                  )));
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.edit)),
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteConfirm(id: widget.id);
                        },
                      );
                    },
                    icon: Icon(Icons.delete))
              ],
            )
          ])),
    ));
  }
}

class DeleteConfirm extends StatefulWidget {
  final String id;

  DeleteConfirm({
    required this.id,
  });
  @override
  State<DeleteConfirm> createState() => _DeleteConfirmState();
}

class _DeleteConfirmState extends State<DeleteConfirm> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Center(
        child: SizedBox(
      height: ht * 0.4,
      width: wt * 0.9,
      child: AlertDialog(
          insetPadding: EdgeInsets.fromLTRB(
            0,
            0,
            0,
            ht * 0.1,
          ),
          title: Center(
              child: Text(
            "Delete Item",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          content: Column(children: [
            Text("Press Confirm to delete this item."),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: ht * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: ht * 0.06,
                  width: wt * 0.3,
                  child: ElevatedButton(
                      onPressed: () async {
                        DatabaseService(uid: user!.uid)
                            .deletePointSpent(widget.id);
                        Navigator.pop(context);
                        Navigator.pop(context);

                        showToast(context: context, msg: "Record deleted");
                      },
                      child: Text(
                        'Confirm',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              primaryAppColor))),
                ),
                SizedBox(
                  width: wt * 0.025,
                ),
                SizedBox(
                  height: ht * 0.06,
                  width: wt * 0.3,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: primaryAppColor, fontSize: 16),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(236, 255, 255, 255)))),
                ),
              ],
            ),
          ])),
    ));
  }
}
