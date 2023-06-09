import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:xpens/screens/home/dev/devDash.dart';

import 'package:xpens/services/auth.dart';

import 'Profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    return Column(
      children: [
        InkWell(
          onTap: () async {
            final curUser = await FirebaseFirestore.instance
                .collection('UserInfo')
                .doc(user!.uid)
                .get();
            String name = curUser.data()!['Name'];
            String phoneNumber = curUser.data()!['PhoneNumber'];

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(
                          name: name,
                          phoneNumber: phoneNumber,
                        )));
          },
          child: Container(
            color: Colors.grey[300],
            width: wt,
            height: ht * 0.06,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(wt * 0.03, 0, 0, 0),
                  child: Text(
                    "Profile",
                    style: TextStyle(fontSize: 18),
                  ),
                )),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(wt * 0.01, ht * 0.005, wt * 0.01, 0),
          child: InkWell(
            onTap: () async {
              var email = user!.email;
              if (email != null) AuthSerivice().Passwordreset(email, context);
            },
            child: Container(
              // decoration: ,
              color: Colors.grey[300],
              width: wt,
              height: ht * 0.06,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(wt * 0.03, 0, 0, 0),
                    child: Text(
                      "Send reset password link ",
                      style: TextStyle(fontSize: 18),
                    ),
                  )),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(wt * 0.01, ht * 0.005, wt * 0.01, 0),
          child: InkWell(
            onTap: () async => AuthSerivice().signOut(),
            child: Container(
              // decoration: ,
              color: Colors.grey[300],
              width: wt,
              height: ht * 0.06,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(wt * 0.03, 0, 0, 0),
                    child: Text(
                      "Log Out",
                      style: TextStyle(fontSize: 18),
                    ),
                  )),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(wt * 0.01, ht * 0.005, wt * 0.01, 0),
          child: InkWell(
            onTap: () async => Navigator.push(
                context, CupertinoPageRoute(builder: (context) => DevDash())),
            child: Container(
              // decoration: ,
              color: Colors.grey[300],
              width: wt,
              height: ht * 0.06,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(wt * 0.03, 0, 0, 0),
                    child: Text(
                      "Dev Center",
                      style: TextStyle(fontSize: 18),
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
