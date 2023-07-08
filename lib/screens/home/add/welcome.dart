// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.fromLTRB(wt * 0.03, ht * 0.01, 0, 0),
      width: wt,
      height: ht * 0.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('UserInfo')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Container();
                }
                var x = snap.data!.data() as Map;

                return Text(
                  x['Name'],
                  style: TextStyle(fontSize: 25),
                );
              })
        ],
      ),
    );
  }
}
