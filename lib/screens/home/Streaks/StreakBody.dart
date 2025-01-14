import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/Streaks/StreakCalendar.dart';
import 'package:xpens/screens/home/Streaks/StreakSettings.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/services/streakDatabase.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/dbModals/streakModal.dart';
import 'package:xpens/shared/utils/onlyDate.dart';

class StreakBody extends StatelessWidget {
  final int s;
  final Function setDefault;
  const StreakBody({super.key, required this.s, required this.setDefault});

  @override
  Widget build(BuildContext context) {
    List streaks = Provider.of<UserInfoProvider>(context).streaks;
    Streak ss = Streak.fromJson(streaks[s]);
    bool markedToday = ss.list.contains(onlyDate(date: DateTime.now()));
    final user = Provider.of<User?>(context);
    return Column(
      children: [
        Stack(
          children: [
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryAppColor),
                ),
                onPressed: () async {
                  if (markedToday) {
                    await StreakDatabaseService(uid: user!.uid)
                        .unmarkDate(selfId: ss.selfId, day: DateTime.now());
                  } else {
                    await StreakDatabaseService(uid: user!.uid)
                        .markDate(selfId: ss.selfId, day: DateTime.now());
                  }
                },
                child: Text("${markedToday ? "Unmark" : "Mark"} Today"),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StreakSettings(
                        ss: ss,
                        setDefault: setDefault,
                      );
                    },
                  );
                },
                icon: Icon(Icons.settings),
              ),
            ),
          ],
        ),
        StreakCalendar(
          selfId: ss.selfId,
          list: ss.list,
          addedDate: ss.addedDate,
          selectRed: ss.selectRed,
        ),
      ],
    );
  }
}
