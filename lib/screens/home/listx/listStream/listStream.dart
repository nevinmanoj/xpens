// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:xpens/screens/home/listx/listStream/deleteItem.dart';
import 'package:xpens/screens/home/listx/listStream/editMain.dart';
import 'package:xpens/screens/home/listx/listStream/itemExpanded.dart';
import 'package:xpens/screens/home/listx/listStream/listHeader.dart';
import 'package:xpens/shared/constants.dart';

class StreamBodyState extends StatefulWidget {
  final curstream;
  StreamBodyState({required this.curstream});

  @override
  State<StreamBodyState> createState() => _StreamBodyStateState();
}

class _StreamBodyStateState extends State<StreamBodyState> {
  int count = 20;
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
        stream: widget.curstream.limit(count).snapshots(),
        builder: (context, listSnapshot) {
          var list = listSnapshot.data?.docs;

          if (listSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Map<String, dynamic>> data = list!
              .map((document) => document.data() as Map<String, dynamic>)
              .toList();
          String curDate = "";
          bool flag = true;
          return ListView.builder(
            itemCount: data.length + 2,
            itemBuilder: (context, i) {
              if (i == 0) return ListHeader();
              if (i - 1 < data.length) {
                bool dispDate = false;
                String iDate = DateFormat.yMMMd()
                    .format(DateTime.parse(data[i - 1]['date']))
                    .toString();
                if (iDate != curDate) {
                  curDate = iDate;
                  dispDate = true;
                }
                flag = !flag;
                return item(
                    list[i - 1].id, data[i - 1], context, dispDate, flag);
              } else
                return Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    width: wt,
                    // alignment: Alignment.center,
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(255, 145, 0, 0.212)),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 58, 58, 58)),
                      ),
                      onPressed: () {
                        setState(() {
                          count += 10;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: wt,
                        child: Text(
                          "Show More",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ));
            },
          );
        });
  }
}

Widget item(
    String id, var item, BuildContext context, bool dispDate, bool flag) {
  String iDate =
      DateFormat.yMMMd().format(DateTime.parse(item['date'])).toString();
  double wt = MediaQuery.of(context).size.width;

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      dispDate
          ? Container(
              width: wt,
              color: flag
                  ? const Color.fromARGB(255, 206, 206, 206)
                  : const Color.fromARGB(255, 232, 232, 232),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Text(
                  iDate,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          : Container(),
      Slidable(
        groupTag: 'same',

        startActionPane: ActionPane(
          dragDismissible: true,
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) => showDialog(
                context: context,
                builder: (context) {
                  return DeleteItem(
                      id: id,
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
            VerticalDivider(
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
                              id: id,
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
                return ExpandItem(item: item, id: id, date: iDate);
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
              color: flag
                  ? const Color.fromARGB(255, 206, 206, 206)
                  : const Color.fromARGB(255, 232, 232, 232),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                children: [
                  Container(
                      width: 150,
                      child: Text(
                        item['itemName'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      )),
                  Container(
                      width: 100,
                      child: Text(
                        "₹ ${item['cost'].toString()}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      )),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => EditxDetails(
                                      id: id,
                                      item: item,
                                    )));
                      },
                      icon: Icon(
                        color: primaryAppColor,
                        Icons.edit,
                      )),
                  IconButton(
                      onPressed: () => showDialog(
                            context: context,
                            builder: (context) {
                              return DeleteItem(
                                  id: id,
                                  name: item['itemName'],
                                  cost: item['cost'].toString(),
                                  date: iDate);
                            },
                          ),
                      icon: Icon(
                        color: primaryAppColor,
                        Icons.delete,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
