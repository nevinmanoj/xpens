// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:xpens/services/database.dart';
import 'package:xpens/services/toast.dart';
import 'package:xpens/shared/constants.dart';

import '../../../components/deleteConfirm.dart';
import '../../dev/injectData.dart';
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
                          // return DeleteConfirm(id: widget.id);
                          return DeleteConfirm(
                            cancel: () {
                              Navigator.pop(context);
                            },
                            delete: () async {
                              await DatabaseService(uid: user!.uid)
                                  .deletePointSpent(widget.id);
                              Navigator.pop(context);
                              Navigator.pop(context);

                              showToast(
                                  context: context, msg: "Record deleted");
                            },
                            title: "Delete Item",
                            msg: "Press Confirm to delete this item.",
                          );
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
