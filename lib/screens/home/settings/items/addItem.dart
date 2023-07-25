import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/toast.dart';
import 'package:xpens/shared/constants.dart';

class AddItem extends StatefulWidget {
  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  double per = 0;
  bool loading = false;
  TextEditingController itemController = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    final user = Provider.of<User?>(context);
    return Container(
      width: wt * 0.9,
      height: ht * 0.05,
      child: Row(
        children: [
          Container(
            height: ht * 0.05,
            width: wt * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.grey[200]?.withOpacity(0.6),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: TextField(
                controller: itemController,
                // initialValue: remarks,
                cursorColor: primaryAppColor,
                cursorWidth: 1,

                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                  hintText: 'Item Name',
                ),
              ),
            ),
          ),
          SizedBox(
            width: wt * 0.02,
          ),
          SizedBox(
              width: wt * 0.18,
              height: ht * 0.05,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(primaryAppColor)),
                  onPressed: loading
                      ? null
                      : () async {
                          setState(() {
                            loading = true;
                            per = 0;
                          });
                          if (itemController.text == "") {
                            showToast(
                                context: context,
                                msg: "Item Name cannot be empty");
                          } else {
                            String name = itemController.text.trim();
                            name = name.substring(0, 1).toUpperCase() +
                                name.substring(1);
                            await DatabaseService(uid: user!.uid)
                                .updateItemsArray(
                                    add: true,
                                    item: name,
                                    progress: (x) {
                                      setState(() {
                                        per = x;
                                      });
                                    });
                            itemController.clear();
                          }

                          FocusManager.instance.primaryFocus!.unfocus();
                          setState(() {
                            loading = false;
                          });
                        },
                  child: Text(
                    loading ? per.toString() : "Add",
                    style:
                        TextStyle(color: loading ? Colors.red : Colors.white),
                  )))
        ],
      ),
    );
  }
}
