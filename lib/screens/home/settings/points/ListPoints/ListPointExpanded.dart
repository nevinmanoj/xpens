// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:xpens/services/database.dart';
import 'package:xpens/services/toast.dart';

import '../../../components/ActionConfirm.dart';
import '../../dev/injectData.dart';
import 'EditListPointItem.dart';

class ExpandPointItem extends StatefulWidget {
  final String id;

  final String date;

  final item;
  const ExpandPointItem(
      {super.key, required this.id, required this.date, required this.item});
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
          title: const Center(
              child: Text(
            "Point Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          content: Column(children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: wt * 0.7,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: wt * 0.3, child: const Text("Item Name")),

                  const Text(": "),
                  const Spacer(),
                  //
                  Text(
                    widget.item['itemName'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(
              width: wt * 0.7,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: wt * 0.3, child: const Text("Points used")),
                  const Text(": "),
                  const Spacer(),
                  Text(
                    "${widget.item['points']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(
              width: wt * 0.7,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: wt * 0.3, child: const Text("Item Date")),
                  const Text(": "),
                  const Spacer(),
                  Text(
                    widget.date,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(
              width: wt * 0.7,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: wt * 0.3, child: const Text("Card")),
                  const Text(": "),
                  const Spacer(),
                  Text(
                    widget.item['cardName'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const Spacer(),
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
                    icon: const Icon(Icons.edit)),
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
                              await DatabaseService(uid: user!.uid).moveToTrash(
                                id: widget.id,
                                type: 'points',
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
