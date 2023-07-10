// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xpens/screens/home/listx/listStream/listStream.dart';
import 'package:xpens/screens/home/listx/listxfilter/listFilter.dart';

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
