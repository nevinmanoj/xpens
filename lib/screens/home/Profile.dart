import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../services/database.dart';
import '../../shared/constants.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

bool updateName = false;
bool updatePhone = false;

// String email ="";

final _formKeyN = GlobalKey<FormState>();
final _formKeyP = GlobalKey<FormState>();

class Profile extends StatefulWidget {
  String name = "";
  String phoneNumber = "";
  Profile({required this.name, required this.phoneNumber});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKeyN = GlobalKey<FormState>();
  final _formKeyP = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    final User? user = _auth.currentUser;
    String? email123 = user?.email;

    // name= DatabaseService(uid: user!.uid).getName().toString();

    return Scaffold(
      appBar: AppBar(backgroundColor: primaryAppColor),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 12, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Text('NAME',
                style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!updateName)
                  Text(widget.name,
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.w400))
                else
                  Form(
                    key: _formKeyN,
                    child: TextFormField(
                        initialValue: widget.name,
                        validator: (value) =>
                            value!.isEmpty ? 'Name cannot be empty' : null,
                        keyboardType: TextInputType.name,
                        textAlign: TextAlign.left,
                        onChanged: (value) {
                          widget.name = value;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          constraints: BoxConstraints(maxWidth: 0.8 * wt),
                        )),
                  ),
                if (!updateName)
                  InkWell(
                      onTap: () {
                        setState(() => updateName = true);
                      },
                      child: Text('EDIT',
                          style: TextStyle(
                              color: secondaryAppColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold))),
              ],
            ),
            if (updateName)
              Container(
                  child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 45,
                        width: wt * 0.463,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_formKeyN.currentState!.validate()) {
                                await DatabaseService(uid: user!.uid)
                                    .updateUserName(widget.name);
                                setState(() => updateName = false);
                              }
                            },
                            child: Text(
                              'UPDATE',
                              // style: TextStyle(color: secondaryAppColor),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        primaryAppColor))),
                      ),
                      SizedBox(
                        height: 45,
                        width: wt * 0.463,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() => updateName = false);
                            },
                            child: Text(
                              'CANCEL',
                              style: TextStyle(color: secondaryAppColor),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(236, 255, 255, 255)))),
                      ),
                    ],
                  ),
                ],
              )),
            SizedBox(
              height: 3,
            ),
            Divider(
              color: Colors.grey[400],
            ),
            SizedBox(
              height: 15,
            ),
            Text('PHONE NUMBER',
                style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!updatePhone)
                  Text(widget.phoneNumber,
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.w400))
                else
                  Form(
                    key: _formKeyP,
                    child: TextFormField(
                        initialValue: widget.phoneNumber,
                        validator: (value) => value!.isEmpty
                            ? 'Phone Number cannot be empty'
                            : null,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.left,
                        onChanged: (value) {
                          widget.phoneNumber = value;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          constraints: BoxConstraints(maxWidth: 0.8 * wt),
                        )),
                  ),
                if (!updatePhone)
                  InkWell(
                      onTap: () {
                        setState(() => updatePhone = true);
                      },
                      child: Text('EDIT',
                          style: TextStyle(
                              color: secondaryAppColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold))),
              ],
            ),
            if (updatePhone)
              Container(
                  child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 45,
                        width: wt * 0.463,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (_formKeyP.currentState!.validate()) {
                                await DatabaseService(uid: user!.uid)
                                    .updateUserPhone(widget.phoneNumber);
                                setState(() => updatePhone = false);
                              }
                            },
                            child: Text(
                              'UPDATE',
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        primaryAppColor))),
                      ),
                      SizedBox(
                        height: 45,
                        width: wt * 0.463,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() => updatePhone = false);
                            },
                            child: Text(
                              'CANCEL',
                              style: TextStyle(color: secondaryAppColor),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(236, 255, 255, 255)))),
                      ),
                    ],
                  ),
                ],
              )),
            SizedBox(
              height: 3,
            ),
            Divider(
              color: Colors.grey[400],
            ),
            SizedBox(
              height: 15,
            ),
            Text('EMAIL',
                style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            SizedBox(
              height: 5,
            ),
            Text(email123!,
                style: TextStyle(
                    color: Colors.grey[600], fontWeight: FontWeight.w400)),
            SizedBox(
              height: 3,
            ),
            Divider(
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
