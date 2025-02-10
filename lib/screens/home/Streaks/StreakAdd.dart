import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ItemInput/dropDown.dart';
import 'package:xpens/services/streakDatabase.dart';

import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/dbModals/streakModal.dart';
import 'package:xpens/shared/utils/CapsFirst.dart';

class StreakAdd extends StatefulWidget {
  const StreakAdd({super.key});

  @override
  State<StreakAdd> createState() => _StreakAddState();
}

class _StreakAddState extends State<StreakAdd> {
  String title = "";
  String verb = "";
  bool selectRed = false;
  final _formKeyN = GlobalKey<FormState>();
  @override
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    double wt = MediaQuery.of(context).size.width;
    return StatefulBuilder(builder: (context, snapshot) {
      return AlertDialog(
        title: const Center(child: Text("Add new streak")),
        content: SizedBox(
          height: 300,
          // width: wt * 0.8,
          child: SingleChildScrollView(
            child: Form(
              key: _formKeyN,
              child: Column(
                children: [
                  ...textBoxInput(
                    onChange: (str) {
                      title = str;
                    },
                    wt: wt,
                    title: 'TITLE',
                    value: title,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ...textBoxInput(
                    onChange: (str) {
                      title = str;
                    },
                    wt: wt,
                    title: 'VERB',
                    value: verb,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: wt,
                    child: Text('MARKED DATE COLOR',
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 12)),
                  ),
                  DropDownItems(
                    onValueChange: (val) {
                      selectRed = val == "red";
                    },
                    valueList: const ["red", "green"],
                    value: selectRed ? "red" : "green",
                    heading: 'color',
                    enabled: true,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "cancel",
                style: TextStyle(color: secondaryAppColor),
              )),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(primaryAppColor),
              ),
              onPressed: () {
                if (_formKeyN.currentState!.validate()) {
                  StreakDatabaseService(uid: user!.uid).addStreak(
                      s: Streak(
                          verb: verb,
                          addedDate: DateTime.now(),
                          selectRed: selectRed,
                          list: [],
                          selfId: "placeholder",
                          title: title));
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"))
        ],
      );
    });
  }
}

List<Widget> textBoxInput(
    {required double wt,
    required String title,
    required Function(String) onChange,
    required String value}) {
  return [
    SizedBox(
      width: wt,
      child:
          Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
    ),
    const SizedBox(
      height: 5,
    ),
    Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: addInputDecoration,
      width: wt * 0.665,
      child: TextFormField(
          initialValue: value,
          validator: (value) =>
              value!.isEmpty ? '$title cannot be empty' : null,
          keyboardType: TextInputType.name,
          textAlign: TextAlign.left,
          onChanged: (v) {
            onChange(v);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            constraints: BoxConstraints(maxWidth: 0.8 * wt),
          )),
    ),
  ];
}
