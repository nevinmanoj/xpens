import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/toast.dart';
import 'package:xpens/shared/constants.dart';

class NewItemsAddwidget extends StatefulWidget {
  const NewItemsAddwidget({super.key});

  @override
  State<NewItemsAddwidget> createState() => _NewItemsAddwidgetState();
}

class _NewItemsAddwidgetState extends State<NewItemsAddwidget> {
  TextEditingController ctrl = TextEditingController();
  bool isTextFieldEmpty = true;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    ctrl.addListener(() {
      setState(() {
        isTextFieldEmpty = ctrl.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    final user = Provider.of<User?>(context);
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: ht * 0.055,
              color: primaryAppColor,
            ),
            Container(),
          ],
        ),
        Positioned(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(wt * 0.05, ht * 0.02, 0, wt * 0.05),
                height: ht * 0.065,
                width: wt * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 167, 167, 167)),
                  borderRadius: BorderRadius.circular(10),
                  // color: Colors.grey[200]?.withOpacity(0.6),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                  child: TextFormField(
                    controller: ctrl,
                    // initialValue: showClear ? filter['query'] : "",
                    cursorColor: primaryAppColor,
                    cursorWidth: 1,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      suffixIcon: !isTextFieldEmpty
                          ? IconButton(
                              icon: const Icon(Icons.done),
                              color: Colors.black.withOpacity(0.5),
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });
                                if (ctrl.text == "") {
                                  showToast(
                                      context: context,
                                      msg: "Item Name cannot be empty");
                                } else {
                                  String name = ctrl.text.trim();
                                  name = name.substring(0, 1).toUpperCase() +
                                      name.substring(1);
                                  await DatabaseService(uid: user!.uid)
                                      .updateItemsArray(
                                    add: true,
                                    item: name,
                                  );
                                  ctrl.clear();
                                }

                                FocusManager.instance.primaryFocus!.unfocus();
                                setState(() {
                                  loading = false;
                                });
                              })
                          : null,
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                      hintText: 'Enter item name to add',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
