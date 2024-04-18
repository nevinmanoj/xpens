import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ActionConfirm.dart';

import 'package:intl/intl.dart';
import '../../../../services/database.dart';
import '../../../../shared/utils/toast.dart';

class TrashItemExpanded extends StatelessWidget {
  final item;
  final String type;
  const TrashItemExpanded({super.key, required this.item, required this.type});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
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
            type,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          content: Column(children: [
            const SizedBox(
              height: 10,
            ),
            buildDetail(key: "Item Name", value: item['itemName'], wt: wt),
            buildDetail(
                key: type == "Expense" ? "Cost" : "Points",
                value: item[type == "Expense" ? "cost" : "points"].toString(),
                wt: wt),
            buildDetail(
                key: "Date",
                value: DateFormat.yMMMd().format(DateTime.parse(item['date'])),
                wt: wt),
            type != "Expense"
                ? buildDetail(key: "Card", value: item['cardName'], wt: wt)
                : Container(),
            type == "Expense"
                ? (item['remarks'] != ""
                    ? buildDetail(
                        key: "Remarks", value: item['remarks'], wt: wt)
                    : Container())
                : Container(),
            type == "Expense"
                ? (item['group'] != "none"
                    ? buildDetail(key: "Group", value: item['group'], wt: wt)
                    : Container())
                : Container(),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ActionConfirm(
                            cancel: () {
                              Navigator.pop(context);
                            },
                            delete: () async {
                              await DatabaseService(uid: user!.uid).restore(
                                id: item.id,
                                type: type,
                              );
                              Navigator.pop(context);
                              Navigator.pop(context);

                              showToast(
                                  context: context, msg: "Record Restored");
                            },
                            title: "Restore Item",
                            msg: "Press Confirm to restore this item.",
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.replay)),
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          // return DeleteConfirm(id: widget.id);
                          return ActionConfirm(
                            cancel: () {
                              Navigator.pop(context);
                            },
                            delete: () async {
                              await DatabaseService(uid: user!.uid).permaDelete(
                                id: item.id,
                                type: type,
                              );
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
