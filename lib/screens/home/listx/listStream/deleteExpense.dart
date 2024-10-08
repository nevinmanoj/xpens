import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/shared/utils/toast.dart';
import 'package:xpens/shared/constants.dart';

class DeleteExpense extends StatefulWidget {
  final String id;
  final String name;
  final String cost;
  final String date;
  const DeleteExpense(
      {super.key,
      required this.id,
      required this.name,
      required this.cost,
      required this.date});
  @override
  State<DeleteExpense> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DeleteExpense> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
          title: const Center(
              child: Text(
            "Delete Expense",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          content: Column(children: [
            const Text("Press Confirm to delete this item."),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Item Name: "),
                Text(
                  widget.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Item Cost: "),
                Text(
                  "${widget.cost} ₹",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Item Date: "),
                Text(
                  widget.date,
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
                        DatabaseService(uid: user!.uid).moveToTrash(
                          id: widget.id,
                          type: 'expense',
                        );
                        Navigator.pop(context);
                        showToast(context: context, msg: "Record deleted");
                      },
                      style: buttonDecoration,
                      child: const Text(
                        'Confirm',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      )),
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
                      style: secBtnDecoration,
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: primaryAppColor, fontSize: 16),
                      )),
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
