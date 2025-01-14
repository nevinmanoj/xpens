import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ActionConfirm.dart';
import 'package:xpens/screens/home/components/ItemInput/dropDown.dart';
import 'package:xpens/services/streakDatabase.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/dbModals/streakModal.dart';

class StreakSettings extends StatefulWidget {
  final Streak ss;
  final Function setDefault;
  const StreakSettings({super.key, required this.ss, required this.setDefault});

  @override
  State<StreakSettings> createState() => _StreakSettingsState();
}

class _StreakSettingsState extends State<StreakSettings> {
  bool updateName = false;
  final _formKeyN = GlobalKey<FormState>();
  final FocusNode _textFieldFocusNode = FocusNode();
  late String title;
  @override
  void initState() {
    title = widget.ss.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    double wt = MediaQuery.of(context).size.width;
    return StatefulBuilder(builder: (context, snapshot) {
      return AlertDialog(
        title: const Center(child: Text("Streak Settings")),
        content: SizedBox(
          height: 300,
          // width: wt * 0.8,
          child: Column(
            children: [
              SizedBox(
                width: wt,
                child: Text('TITLE',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!updateName)
                    Text(title,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400))
                  else
                    Form(
                      key: _formKeyN,
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: addInputDecoration,
                        width: wt * 0.665,
                        child: TextFormField(
                            focusNode: _textFieldFocusNode,
                            initialValue: title,
                            validator: (value) =>
                                value!.isEmpty ? 'Title cannot be empty' : null,
                            keyboardType: TextInputType.name,
                            textAlign: TextAlign.left,
                            onChanged: (value) {
                              title = value;
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              constraints: BoxConstraints(maxWidth: 0.8 * wt),
                            )),
                      ),
                    ),
                  if (!updateName)
                    InkWell(
                        onTap: () {
                          setState(() => updateName = true);
                          FocusScope.of(context)
                              .requestFocus(_textFieldFocusNode);
                        },
                        child: const Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 188, 188, 188),
                        )),
                ],
              ),
              if (updateName)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() => updateName = false);
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                    const Color.fromARGB(236, 255, 255, 255))),
                            child: const Text(
                              'cancel',
                              style: TextStyle(color: secondaryAppColor),
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (_formKeyN.currentState!.validate()) {
                                StreakDatabaseService(uid: user!.uid).editTitle(
                                    selfId: widget.ss.selfId, title: title);
                                setState(() => updateName = false);
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        primaryAppColor)),
                            child: const Text(
                              'Update',
                              // style: TextStyle(color: secondaryAppColor),
                            )),
                      ],
                    ),
                  ],
                ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: wt,
                child: Text('MARKED DATE COLOR',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              ),
              DropDownItems(
                onValueChange: (val) {
                  StreakDatabaseService(uid: user!.uid).editColor(
                      selfId: widget.ss.selfId, selectRed: val == "red");
                },
                valueList: const ["red", "green"],
                value: widget.ss.selectRed ? "red" : "green",
                heading: 'color',
                enabled: true,
              ),
              const Spacer(),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: ((context) => ActionConfirm(
                            title: "Delete",
                            msg: "Delete current streak?",
                            cancel: () => Navigator.pop(context),
                            confirm: () {
                              widget.setDefault();
                              Navigator.pop(context);
                              Navigator.pop(context);
                              StreakDatabaseService(uid: user!.uid)
                                  .deleteStreak(selfId: widget.ss.selfId);
                            })));
                  },
                  child: const Text("Delete Streak"))
            ],
          ),
        ),
      );
    });
  }
}
