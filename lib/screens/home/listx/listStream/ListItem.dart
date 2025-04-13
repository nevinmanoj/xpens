import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xpens/shared/utils/formatCost.dart';
import '../../../../shared/constants.dart';
import 'deleteExpense.dart';
import 'editMain.dart';
import 'itemExpanded.dart';

Widget itemWidget(
    {required item, required iDate, required BuildContext context}) {
  double wt = MediaQuery.of(context).size.width;
  return Slidable(
    groupTag: 'same',

    startActionPane: ActionPane(
      dragDismissible: true,
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (BuildContext context) => showDialog(
            context: context,
            builder: (context) {
              return DeleteExpense(
                  id: item.id,
                  name: item['itemName'],
                  cost: item['cost'].toString(),
                  date: iDate);
            },
          ),
          backgroundColor: primaryAppColor,
          foregroundColor: secondaryAppColor,
          icon: Icons.delete,
          // label: 'Delete',
        ),
        const VerticalDivider(
          // color: Color.fromARGB(255, 29, 29, 29),
          color: secondaryAppColor,
          width: 1,
          thickness: 1,
        ),
        SlidableAction(
          // An action can be bigger than the others.
          flex: 2,
          onPressed: (BuildContext context) {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => EditxDetails(
                          id: item.id,
                          item: item,
                        )));
          },
          backgroundColor: primaryAppColor,
          foregroundColor: secondaryAppColor,
          icon: Icons.edit,
          // label: 'Edit',
        ),
      ],
    ),

    // The child of the Slidable is what the user sees when the
    // component is not dragged.
    child: InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return ExpandItem(item: item, id: item.id, date: iDate);
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
        child: Row(
          children: [
            SizedBox(
                width: wt * 0.43,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['itemName'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      item['remarks'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 143, 134, 134)),
                    ),
                  ],
                )),
            const Spacer(),
            item['group'] != "none"
                ? Container(
                    width: wt * 0.17,
                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                            color: const Color.fromARGB(255, 201, 201, 201))),
                    // width: 100,
                    child: Center(
                      child: Text(
                        item['group'].toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ))
                : Container(),
            const Spacer(),
            SizedBox(
                width: 100,
                child: Text(
                  "₹ ${formatDouble(item['cost'])}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 18),
                )),
          ],
        ),
      ),
    ),
  );
}
