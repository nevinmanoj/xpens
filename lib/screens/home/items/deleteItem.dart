import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/shared/constants.dart';

class DeleteItem extends StatefulWidget {
  final String itemName;
  DeleteItem({required this.itemName});

  @override
  State<DeleteItem> createState() => _DeleteItemState();
}

class _DeleteItemState extends State<DeleteItem> {
  @override
  Widget build(BuildContext context) {
    double per = 0;
    final user = Provider.of<User?>(context);
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
            Row(
              children: [
                Text("Press Confirm to delete "),
                Text(
                  "Dinner ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text("from the List."),
              ],
            ),
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
                  width: wt * 0.4,
                  child: ElevatedButton(
                      onPressed: () async {
                        await DatabaseService(uid: user!.uid).updateItemsArray(
                          add: false,
                          item: widget.itemName,
                        );
                        Navigator.pop(context);
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
            SizedBox(
              height: ht * 0.05,
            ),
            Container(
              decoration: BoxDecoration(
                // color: Colors.amber,
                border: Border.all(
                  color: primaryAppColor,
                ),
              ),
              height: ht * 0.05,
              width: wt * 0.7,
              child: Row(
                children: [
                  Container(
                    width: wt * 0.5 * per,
                    height: ht * 0.05,
                    color: Colors.green,
                    child: Text(per.toString()),
                  ),
                  // Text(per.toString())
                ],
              ),
            ),
            Text(per.toString())
          ])),
    ));
  }
}
