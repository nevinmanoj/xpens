// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:xpens/screens/home/listx/editMain.dart';

import 'package:intl/intl.dart';
import 'package:xpens/screens/home/listx/itemExpanded.dart';
import 'package:xpens/screens/home/listx/listxfilter/listFilter.dart';
import 'package:xpens/screens/home/listx/deleteItem.dart';
import 'package:xpens/shared/constants.dart';

String curDate = "";
String iDate = "";
bool flag = true;

class listx extends StatefulWidget {
  const listx({super.key});

  @override
  State<listx> createState() => _listxState();
}

class _listxState extends State<listx> {
  var curstream = FirebaseFirestore.instance
      .collection('UserInfo/${FirebaseAuth.instance.currentUser!.uid}/list')
      .orderBy('date', descending: true);

  void onStreamChange(var newStream) {
    setState(() {
      curstream = newStream;
    });
  }

  @override
  Widget build(BuildContext context) {
    // double ht = MediaQuery.of(context).size.height;
    // double wt = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        StreamBodyState(
          curstream: curstream,
        ),
        FilterWindow(
          onStreamChange: onStreamChange,
        ),
      ],
    );
  }
}

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
          curDate = "";
          flag = true;
          return ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (context, i) {
              if (i < data.length)
                return item(list[i].id, data[i], context);
              else
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

Widget item(String id, var item, BuildContext context) {
  iDate = DateFormat.yMMMd().format(DateTime.parse(item['date'])).toString();
  double wt = MediaQuery.of(context).size.width;
  bool dispDate = false;
  flag = !flag;
  if (iDate != curDate) {
    curDate = iDate;
    dispDate = true;
  }
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
        // Specify a key if the Slidable is dismissible.

        // The start action pane is the one at the left or the top side.
        // startActionPane: ActionPane(
        //   // A motion is a widget used to control how the pane animates.
        //   motion: ScrollMotion(),
        //   dragDismissible: false,
        //   // A pane can dismiss the Slidable.

        //   // All actions are defined in the children parameter.
        //   children: [
        //     // A SlidableAction can have an icon and/or a label.
        //     SlidableAction(
        //       onPressed: (BuildContext context) {},
        //       backgroundColor: primaryAppColor,
        //       foregroundColor: secondaryAppColor,
        //       icon: Icons.delete,
        //       // label: 'Delete',
        //     ),
        //   ],
        // ),

        // The end action pane is the one at the right or the bottom side.
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
