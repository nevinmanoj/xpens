import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/Streaks/StreakBars.dart';
import 'package:xpens/screens/home/components/ActionConfirm.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';

class StreakDefault extends StatefulWidget {
  const StreakDefault({super.key});

  @override
  State<StreakDefault> createState() => _StreakDefaultState();
}

class _StreakDefaultState extends State<StreakDefault> {
  bool streakDeatilsVisible = false;

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

    void handleStreakDetailVisibility(bool val) {
      setState(() {
        streakDeatilsVisible = val;
      });
    }

    return Column(
      children: [
        isStart
            ? Container()
            : Visibility(
                visible: streakDeatilsVisible,
                child: StreakBars(
                  dateTime: streakDate,
                )),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isStart
                ? Container()
                : Text(
                    displayDate.toString(),
                    style: TextStyle(fontSize: 60),
                  ),
            GestureDetector(
              onTap: () => handleStreakDetailVisibility(!streakDeatilsVisible),
              child: const Icon(
                Bootstrap.fire,
                size: 60,
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          height: 45,
          width: 80,
          child: isStart
              ? ElevatedButton(
                  style: buttonDecoration,
                  onPressed: () {
                    handleScoreReset();
                  },
                  child: const Text(
                    "Start",
                    style: TextStyle(fontSize: 20),
                  ))
              : OutlinedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                  child: const Text(
                    "Reset",
                    style: TextStyle(color: Colors.red),
                  )),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
