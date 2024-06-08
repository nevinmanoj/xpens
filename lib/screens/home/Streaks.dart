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
    int highestStreak = Provider.of<UserInfoProvider>(context).highestStreak;
    bool isStart = (streakDate == null);
    final user = Provider.of<User?>(context);
    int displayDate = 0;
    if (!isStart) {
      displayDate = DateTime.now().difference(streakDate).inDays;
    }
    if (displayDate > highestStreak) {
      DatabaseService(uid: user!.uid)
          .updateUserInfo("highestStreak", displayDate);
    }

    void handleScoreReset() {
      DatabaseService(uid: user!.uid)
          .updateUserInfo("streakDate", DateTime.now().toString());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        actions: isStart
            ? null
            : [
                Row(
                  children: [
                    Text(
                      highestStreak.toString(),
                      style: TextStyle(fontSize: 24),
                    ),
                    Icon(
                      Icons.emoji_events,
                      size: 30,
                    )
                  ],
                )
              ],
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
                      displayDate.toString(),
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
                      handleScoreReset();
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
                      "Reset",
                      style: TextStyle(color: Colors.red),
                    )),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
