import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/Streaks/StreakAdd.dart';
import 'package:xpens/screens/home/Streaks/StreakBody.dart';
import 'package:xpens/screens/home/Streaks/StreakDefault.dart';
import 'package:xpens/screens/home/Streaks/StreakOverview.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/dbModals/streakModal.dart';

class StreakPage extends StatefulWidget {
  const StreakPage({super.key});

  @override
  State<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends State<StreakPage> {
  bool isDefault = true;
  int streakindex = 0;
  @override
  Widget build(BuildContext context) {
    DateTime? streakDate = Provider.of<UserInfoProvider>(context).streakDate;
    int highestStreak = Provider.of<UserInfoProvider>(context).highestStreak;
    List streaks = Provider.of<UserInfoProvider>(context).streaks;
    bool isStart = (streakDate == null);

    void setDefault() {
      setState(() {
        isDefault = true;
      });
    }

    double wt = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        actions: (isStart || !isDefault)
            ? null
            : [
                Row(
                  children: [
                    Text(
                      highestStreak.toString(),
                      style: const TextStyle(fontSize: 24),
                    ),
                    const Icon(
                      Icons.emoji_events,
                      size: 30,
                    )
                  ],
                )
              ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
            width: wt,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // for (int i = 0; i < 10; i++)
                  InkWell(
                    onTap: () => setState(
                      () => isDefault = true,
                    ),
                    child: getPill("Default", false, -1),
                  ),
                  for (int i = 0; i < streaks.length; i++)
                    InkWell(
                        onLongPress: () => print("sdasdas"),
                        onTap: () => setState(() {
                              streakindex = i;
                              isDefault = false;
                            }),
                        child: getPill(
                            Streak.fromJson(streaks[i]).title, false, i)),
                  InkWell(
                      onTap: () => showDialog(
                          context: context, builder: (context) => StreakAdd()),
                      child: getPill("Add New", true, -2))
                ],
              ),
            ),
          ),
          isDefault ? const Spacer() : Container(),
          isDefault
              ? const StreakDefault()
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        StreakBody(
                          // s: streak!,
                          s: streakindex,
                          setDefault: setDefault,
                        ),
                        StreakOverview(
                          s: streakindex,
                        ),
                      ],
                    ),
                  ),
                ),
          isDefault ? const Spacer() : Container(),
        ],
      ),
    );
  }

  Widget getPill(title, isAdd, index) {
    bool isSelected = false;
    if (isDefault && index == -1) {
      isSelected = true;
    } else if (index == streakindex && !isDefault) {
      isSelected = true;
    }
    return Container(
      alignment: Alignment.center,
      // height: 25,
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: isSelected ? primaryAppColor : null,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
                color: isAdd
                    ? Colors.green
                    : isSelected
                        ? Colors.white
                        : primaryAppColor,
                fontWeight: isAdd || isSelected ? FontWeight.bold : null),
          ),
          if (isAdd)
            const Icon(
              Icons.add,
              size: 15,
              color: Colors.green,
            )
        ],
      ),
    );
  }
}
