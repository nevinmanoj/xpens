// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xpens/screens/home/listx/listStream/editMain.dart';

import 'package:xpens/services/database.dart';
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
          title: const Center(
              child: Text(
            "Expense Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          content: Column(children: [
            const SizedBox(
              height: 10,
            ),
            buildDetail(
                key: "Item Name", value: widget.item['itemName'], wt: wt),
            buildDetail(
                key: "Item Cost", value: "${widget.item['cost']} ₹", wt: wt),
            buildDetail(key: "Item Date", value: widget.date, wt: wt),
            buildDetail(
                key: "Item Tag", value: widget.item['location'], wt: wt),
            widget.item['remarks'] != ""
                ? buildDetail(
                    key: "Remarks", value: widget.item['remarks'], wt: wt)
                : Container(),
            (widget.item['group'] == "none" || widget.item['group'] == "")
                ? Container()
                : buildDetail(
                    key: "Group", value: widget.item['group'], wt: wt),
            const Spacer(),
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
                            delete: () async {
                              await DatabaseService(uid: user!.uid).moveToTrash(
                                id: widget.id,
                                type: 'expense',
                              );
                              Navigator.pop(context);
                              Navigator.pop(context);

                              showToast(
                                  context: context, msg: "Record deleted");
                            },
                            title: "Delete Expense",
                            msg: "Press Confirm to delete this Expense record.",
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete))
              ],
            )
          ])),
    ));
  }
}

Widget buildDetail({required key, required value, required wt}) {
  return SizedBox(
    width: wt * 0.7,
    child: Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(child: SizedBox(width: wt * 0.3, child: Text(key))),
        const Text(": "),
        const Spacer(),
        Container(
          alignment: Alignment.centerRight,
          width: wt * 0.35,
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    ),
  );
}
