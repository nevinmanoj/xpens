import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../shared/constants.dart';
import 'deleteExpense.dart';
import 'editMain.dart';
import 'itemExpanded.dart';

Widget itemWidget(
    {required item, required iDate, required BuildContext context}) {
  return Slidable(
    groupTag: 'same',

    startActionPane: ActionPane(
      dragDismissible: true,
      motion: ScrollMotion(),
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
      child: Container(
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(5),
            // boxShadow: [
            //   BoxShadow(
            //       blurRadius: 2.5, color: Colors.grey, offset: Offset(0.0, 1))
            // ],
            // color: const Color.fromARGB(255, 232, 232, 232),
            ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
          child: Row(
            children: [
              Container(
                  width: 150,
                  child: Text(
                    item['itemName'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(fontSize: 18),
                  )),
              Spacer(),
              Container(
                  width: 100,
                  child: Text(
                    "₹ ${item['cost'].toString()}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(fontSize: 18),
                  )),
            ],
          ),
        ),
      ),
    ),
  );
}

// Widget item(String id, var item, BuildContext context, bool dispDate) {
//   String iDate =
//       DateFormat.yMMMd().format(DateTime.parse(item['date'])).toString();
//   double wt = MediaQuery.of(context).size.width;

//   return Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     children: [
//       dispDate
//           ? Container(
//               width: wt,
//               color: const Color.fromARGB(255, 232, 232, 232),
//               // color: flag
//               //     ? const Color.fromARGB(255, 206, 206, 206)
//               //     : const Color.fromARGB(255, 232, 232, 232),
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
//                 child: Text(
//                   iDate,
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//               ),
//             )
//           : Container(),
//       Slidable(
//         groupTag: 'same',

//         startActionPane: ActionPane(
//           dragDismissible: true,
//           motion: ScrollMotion(),
//           children: [
//             SlidableAction(
//               onPressed: (BuildContext context) => showDialog(
//                 context: context,
//                 builder: (context) {
//                   return DeleteExpense(
//                       id: id,
//                       name: item['itemName'],
//                       cost: item['cost'].toString(),
//                       date: iDate);
//                 },
//               ),
//               backgroundColor: primaryAppColor,
//               foregroundColor: secondaryAppColor,
//               icon: Icons.delete,
//               // label: 'Delete',
//             ),
//             const VerticalDivider(
//               // color: Color.fromARGB(255, 29, 29, 29),
//               color: secondaryAppColor,
//               width: 1,
//               thickness: 1,
//             ),
//             SlidableAction(
//               // An action can be bigger than the others.
//               flex: 2,
//               onPressed: (BuildContext context) {
//                 Navigator.push(
//                     context,
//                     CupertinoPageRoute(
//                         builder: (context) => EditxDetails(
//                               id: id,
//                               item: item,
//                             )));
//               },
//               backgroundColor: primaryAppColor,
//               foregroundColor: secondaryAppColor,
//               icon: Icons.edit,
//               // label: 'Edit',
//             ),
//           ],
//         ),

//         // The child of the Slidable is what the user sees when the
//         // component is not dragged.
//         child: InkWell(
//           onTap: () {
//             showDialog(
//               context: context,
//               builder: (context) {
//                 return ExpandItem(item: item, id: id, date: iDate);
//               },
//             );
//           },
//           child: Container(
//             decoration: BoxDecoration(
//                 // borderRadius: BorderRadius.circular(5),
//                 // boxShadow: [
//                 //   BoxShadow(
//                 //       blurRadius: 2.5, color: Colors.grey, offset: Offset(0.0, 1))
//                 // ],
//                 // color: const Color.fromARGB(255, 232, 232, 232),
//                 ),
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
//               child: Row(
//                 children: [
//                   Container(
//                       width: 150,
//                       child: Text(
//                         item['itemName'],
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 3,
//                         style: TextStyle(fontSize: 18),
//                       )),
//                   Spacer(),
//                   Container(
//                       width: 100,
//                       child: Text(
//                         "₹ ${item['cost'].toString()}",
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 3,
//                         style: TextStyle(fontSize: 18),
//                       )),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }
