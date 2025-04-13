// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xpens/screens/home/listx/listStream/editMain.dart';

import 'package:xpens/services/database.dart';
import 'package:xpens/shared/utils/formatCost.dart';
import 'package:xpens/shared/utils/toast.dart';

import '../../components/ActionConfirm.dart';

class ExpandItem extends StatefulWidget {
  final String id;

  final String date;

  final item;
  const ExpandItem(
      {super.key, required this.id, required this.date, required this.item});
  @override
  State<ExpandItem> createState() => _MyWidgetState();
}

// /new Function

class _MyWidgetState extends State<ExpandItem> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
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
          // title: const Center(
          //     child: Text(
          //   "Expense Detailss",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // )),
          actions: [
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
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ActionConfirm(
                        cancel: () {
                          Navigator.pop(context);
                        },
                        confirm: () async {
                          await DatabaseService(uid: user!.uid).moveToTrash(
                            id: widget.id,
                            type: 'expense',
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);

                          showToast(context: context, msg: "Record deleted");
                        },
                        title: "Delete Expense",
                        msg: "Press Confirm to delete this Expense record.",
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete))
          ],
          content:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.date,
                  style: const TextStyle(fontSize: 20),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color.fromARGB(255, 229, 229, 229)),
                  child: Text(widget.item['location']),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: wt * 0.5,
                  child: buildDetail(
                      title: "Item Name",
                      value: widget.item['itemName'],
                      alginRightEnd: false),
                ),
                SizedBox(
                  width: wt * 0.25,
                  child: buildDetail(
                      title: "Cost",
                      value: formatDouble(widget.item['cost']),
                      alginRightEnd: true),
                ),
              ],
            ),
            if (widget.item['remarks'] != "")
              buildDetail(
                  title: "Remarks",
                  value: widget.item['remarks'],
                  alginRightEnd: false),
            if (widget.item['group'] != "none" && widget.item['group'] != "")
              buildDetail(
                  title: "Group",
                  value: widget.item['group'],
                  alginRightEnd: false),
          ])),
    ));
  }
}

Widget buildDetail(
    {required String title,
    required String value,
    required bool alginRightEnd}) {
  return Container(
    margin: const EdgeInsets.only(top: 15),
    child: Column(
      crossAxisAlignment:
          alginRightEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: Color.fromARGB(255, 177, 177, 177)),
        ),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 20,
          ),
        )
      ],
    ),
  );
}
