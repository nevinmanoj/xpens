import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ActionConfirm.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';

class StreakPage extends StatefulWidget {
  const StreakPage({super.key});

  @override
  State<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends State<StreakPage> {
  @override
  Widget build(BuildContext context) {
    DateTime? streakDate = Provider.of<UserInfoProvider>(context).streakDate;
    var isStart = streakDate == null;
    final user = Provider.of<User?>(context);
    String displayDate = "";
    if (!isStart) {
      displayDate = DateTime.now().difference(streakDate).inDays.toString();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isStart
                  ? Container()
                  : Text(
                      displayDate,
                      style: TextStyle(fontSize: 60),
                    ),
              Icon(
                Bootstrap.fire,
                size: 60,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 45,
            width: 80,
            child: isStart
                ? ElevatedButton(
                    style: buttonDecoration,
                    onPressed: () {
                      DatabaseService(uid: user!.uid).updateUserInfo(
                          "streakDate", DateTime.now().toString());
                    },
                    child: Text(
                      "Start",
                      style: TextStyle(fontSize: 20),
                    ))
                : OutlinedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => ActionConfirm(
                                title: 'Lost',
                                msg: 'Click confirm to reset streak',
                                cancel: () {
                                  Navigator.pop(context);
                                },
                                confirm: () async {
                                  await DatabaseService(uid: user!.uid)
                                      .updateUserInfo("streakDate",
                                          DateTime.now().toString());
                                  Navigator.pop(context);
                                },
                              ));
                    },
                    child: Text(
                      "Lost",
                      style: TextStyle(color: Colors.red),
                    )),
          )
        ],
      ),
    );
  }
}
