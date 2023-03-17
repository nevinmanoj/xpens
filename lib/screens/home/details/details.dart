import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:xpens/screens/home/details/downloadPopup.dart';
import 'package:xpens/screens/home/details/today.dart';
import 'package:xpens/screens/home/details/yesterday.dart';
import 'package:xpens/services/auth.dart';
import 'package:xpens/services/other.dart';
import 'package:xpens/shared/constants.dart';

import 'month.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;
String curDate = "";
String month = DateFormat.MMM().format(DateTime.now()).toString();
String year = DateTime.now().year.toString();
String iDate = "";

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
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

          return SingleChildScrollView(
            child: Column(
              children: [
                Today(),
                Yesterday(),
                ThisMonth(),
                SizedBox(
                  height: 5,
                ),
                DOwnloadDetails(
                  data: data,
                ),
              ],
            ),
          );
        });
  }
}
