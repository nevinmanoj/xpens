import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xpens/screens/home/listx/listStream/editMain.dart';

import 'package:xpens/services/database.dart';
import 'package:xpens/services/toast.dart';
import 'package:xpens/shared/constants.dart';

class ExpandItem extends StatefulWidget {
  String id;
  // String name;
  // String cost;
  String date;
  // String remarks;
  var item;
  ExpandItem({required this.id, required this.date, required this.item});
  @override
  State<ExpandItem> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ExpandItem> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
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
            "Expense Details",
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
                  Container(width: wt * 0.3, child: Text("Item Cost")),
                  Text(": "),
                  Spacer(),
                  Text(
                    "${widget.item['cost']} ₹",
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
                  Container(width: wt * 0.3, child: Text("Item Tag")),
                  Text(": "),
                  Spacer(),
                  Text(
                    widget.item['location'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            widget.item['remarks'] != ""
                ? Container(
                    width: wt * 0.7,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: wt * 0.3, child: Text("Remarks")),
                        Text(": "),
                        Spacer(),
                        Container(
                          alignment: Alignment.centerRight,
                          // color: Colors.amber,
                          width: wt * 0.35,
                          child: Text(
                            widget.item['remarks'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
            (widget.item['group'] == "none" || widget.item['group'] == "")
                ? Container()
                : Container(
                    width: wt * 0.7,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: wt * 0.3, child: Text("Group")),
                        Text(": "),
                        Spacer(),
                        Container(
                          alignment: Alignment.centerRight,
                          // color: Colors.amber,
                          width: wt * 0.35,
                          child: Text(
                            widget.item['group'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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
                              builder: (context) => EditxDetails(
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
  String id;

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
                        DatabaseService(uid: user!.uid).deleteItem(widget.id);
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
