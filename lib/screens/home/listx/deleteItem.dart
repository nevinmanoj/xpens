import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/toast.dart';
import 'package:xpens/shared/constants.dart';

class edittrial extends StatefulWidget {
  String id;
  String name;
  String cost;
  String date;
  edittrial(
      {required this.id,
      required this.name,
      required this.cost,
      required this.date});
  @override
  State<edittrial> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<edittrial> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Center(
        child: SizedBox(
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
            "Delete Item",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          content: Column(children: [
            Text("Press Confirm to delete this item."),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Item Name: "),
                Text(
                  widget.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Item Cost: "),
                Text(
                  "${widget.cost} ₹",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Item Date: "),
                Text(
                  widget.date,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: ht * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: ht * 0.06,
                  width: wt * 0.4,
                  child: ElevatedButton(
                      onPressed: () async {
                        DatabaseService(uid: user!.uid).deleteItem(widget.id);
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
                  width: wt * 0.4,
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
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.pop(context);
            //     },
            //     child: Text(
            //       'Edit',
            //       style: TextStyle(
            //           color: primaryAppColor, fontSize: 16),
            //     ),
            //     style: ButtonStyle(
            //         backgroundColor:
            //             MaterialStateProperty.all<Color>(
            //                 Color.fromARGB(236, 255, 255, 255)))),
          ])),
    ));
  }
}
