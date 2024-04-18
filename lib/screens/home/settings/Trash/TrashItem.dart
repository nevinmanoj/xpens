import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/database.dart';
import '../../../../shared/utils/toast.dart';
import '../../../../shared/constants.dart';

import 'package:intl/intl.dart';

import '../../components/ActionConfirm.dart';
import 'TrashItemExapanded.dart';

Widget trashItemWidget(
    {required item,
    required iDate,
    required BuildContext context,
    required type}) {
  String display1 = item['itemName'];
  String display2 = "";
  String display3 = "";
  String display4 = "";
  final user = Provider.of<User?>(context);
  switch (type) {
    case "Expense":
      display2 = item['remarks'];
      display3 = DateFormat.yMMMd().format(DateTime.parse(item['date']));
      display4 = item['cost'].toString();
      break;
    case "Points":
      display2 = item['cardName'];
      display3 = DateFormat.yMMMd().format(DateTime.parse(item['date']));
      display4 = item['points'].toString();
      break;
  }
  return Slidable(
    groupTag: 'same',
    startActionPane: ActionPane(
      dragDismissible: true,
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (BuildContext context) {
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

                    showToast(context: context, msg: "Record deleted");
                  },
                  title: "Delete Item",
                  msg: "Press Confirm to delete this item.",
                );
              },
            );
          },
          backgroundColor: primaryAppColor,
          foregroundColor: secondaryAppColor,
          icon: Icons.delete,
        ),
        const VerticalDivider(
          color: secondaryAppColor,
          width: 1,
          thickness: 1,
        ),
        SlidableAction(
          // An action can be bigger than the others.
          flex: 2,
          onPressed: (BuildContext context) {
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

                    showToast(context: context, msg: "Record Restored");
                  },
                  title: "Restore Item",
                  msg: "Press Confirm to restore this item.",
                );
              },
            );
          },
          backgroundColor: primaryAppColor,
          foregroundColor: secondaryAppColor,
          icon: Icons.replay,
          // label: 'Edit',
        ),
      ],
    ),
    child: InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return TrashItemExpanded(
              item: item,
              type: type,
            );
          },
        );
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 10, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        display1,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        display2,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 143, 134, 134)),
                      ),
                    ],
                  )),
              // Spacer(),
              Column(
                children: [
                  Container(
                      alignment: Alignment.centerRight,
                      width: 120,
                      child: Text(
                        display3,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 144, 144, 144)),
                      )),
                  Container(
                      alignment: Alignment.centerRight,
                      width: 120,
                      child: Text(
                        display4,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 18),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
