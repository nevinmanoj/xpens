// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:core';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:xpens/screens/home/listx/deleteItem.dart';
import 'package:xpens/screens/home/listx/editMain.dart';

import 'package:intl/intl.dart';

String curDate = "";
String iDate = "";

class listx extends StatefulWidget {
  const listx({super.key});

  @override
  State<listx> createState() => _listxState();
}

class _listxState extends State<listx> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('UserInfo/${user!.uid}/list')
            .orderBy('date', descending: true)
            .snapshots(),
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
              return item(list[i].id, data[i]);
            },
          );
        });
  }
}

Widget item(String id, var item) {
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
            Text(item['itemName']),
            Spacer(),
            Text(item['cost'].toString()),
            Spacer(),
            OpenContainer(
              closedElevation: 0,
              transitionDuration: Duration(milliseconds: 500),
              transitionType: ContainerTransitionType.fadeThrough,
              closedBuilder: (context, OpenContainer) => editx(),
              openBuilder: (context, action) => EditxDetails(
                id: id,
                item: item,
              ),
            ),
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
