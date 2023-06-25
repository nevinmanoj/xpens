// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:xpens/screens/home/listx/deleteItem.dart';
import 'package:xpens/screens/home/listx/editMain.dart';

import 'package:intl/intl.dart';
import 'package:xpens/screens/home/listx/listxfilter/listFilter.dart';
import 'package:xpens/shared/constants.dart';

String curDate = "";
String iDate = "";

class listx extends StatefulWidget {
  const listx({super.key});

  @override
  State<listx> createState() => _listxState();
}

class _listxState extends State<listx> {
  var curstream = FirebaseFirestore.instance
      .collection('UserInfo/${FirebaseAuth.instance.currentUser!.uid}/list')
      .orderBy('date', descending: true)
      .limit(50);

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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.curstream.snapshots(),
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
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              return item(list[i].id, data[i], context);
              // return itemBuild(id: list[i].id, item: data[i]);
            },
          );
        });
  }
}

Widget item(String id, var item, BuildContext context) {
  iDate = DateFormat.yMMMd().format(DateTime.parse(item['date'])).toString();
  bool dispDate = false;

  if (iDate != curDate) {
    curDate = iDate;
    dispDate = true;
  }
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dispDate ? Divider() : Container(),
        dispDate
            ? Text(
                iDate,
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            : Container(),
        Row(
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
            DeleteItem(
              id: id,
              name: item['itemName'],
              cost: item['cost'].toString(),
              date: iDate,
            )
          ],
        ),
      ],
    ),
  );
}
