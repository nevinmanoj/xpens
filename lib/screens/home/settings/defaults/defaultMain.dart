import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/database.dart';
import '../../../../services/providers/UserInfoProvider.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/dataModals/AddItemModal.dart';
import '../../../../shared/utils/CapsFirst.dart';
import '../../../../shared/utils/toast.dart';
import '../../components/ItemInput/ItemInputsMain.dart';

class Defaults extends StatefulWidget {
  const Defaults({super.key});

  @override
  State<Defaults> createState() => _DefaultsState();
}

class _DefaultsState extends State<Defaults> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    double ht = MediaQuery.of(context).size.height;
    var userInfo = Provider.of<UserInfoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        centerTitle: true,
        title: Text("Default Views"),
      ),
      body: ListView.builder(
          itemCount: userInfo.defaults.length,
          itemBuilder: (c, i) {
            return InkWell(
              onTap: () => Navigator.push(context,
                  CupertinoPageRoute(builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: primaryAppColor,
                    centerTitle: true,
                    title: Text(
                        "Default ${capsFirst(userInfo.defaults[i].id)} View"),
                  ),
                  body: Center(
                    child: ItemInputs(
                        optionDefault: null,
                        isData: false,
                        itemName: userInfo.defaults[i]["itemName"],
                        costS: userInfo.defaults[i]["cost"] == null
                            ? ""
                            : "${userInfo.defaults[i]["cost"]}",
                        group: userInfo.defaults[i]["group"],
                        date: DateTime.parse(userInfo.defaults[i]["date"]),
                        location: userInfo.defaults[i]["location"],
                        remarks: "",
                        time: TimeOfDay(
                            hour: int.parse(
                                userInfo.defaults[i]["time"].split(":")[0]),
                            minute: int.parse(
                                userInfo.defaults[i]["time"].split(":")[1])),
                        buttonLabel: "Save",
                        buttonfunc: (AddItem I) async {
                          bool res = await DatabaseService(uid: user!.uid)
                              .updateDefaults(
                                  type: userInfo.defaults[i].id, I: I);
                          String msg = res ? "successfully" : "failed";

                          showToast(
                              context: context,
                              msg:
                                  " ${capsFirst(userInfo.defaults[i].id)} Default view modified $msg");
                        }),
                  ),
                );
              })),
              child: Container(
                height: ht * 0.06,
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  capsFirst(userInfo.defaults[i].id),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }),
    );
  }
}
