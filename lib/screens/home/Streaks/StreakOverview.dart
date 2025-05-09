import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/dbModals/streakModal.dart';
import 'package:xpens/shared/utils/CapsFirst.dart';

class StreakOverview extends StatefulWidget {
  final int s;
  const StreakOverview({super.key, required this.s});

  @override
  State<StreakOverview> createState() => _StreakOverviewState();
}

class _StreakOverviewState extends State<StreakOverview> {
  bool markedBool = true;
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    List streaks = Provider.of<UserInfoProvider>(context).streaks;
    Streak streak = Streak.fromJson(streaks[widget.s]);
    String verb = capsFirst(streak.verb);
    List filterList = [verb, "Not $verb"];
    List<bool> selectedfilter = [];
    if (markedBool) {
      selectedfilter = [true, false];
    } else {
      selectedfilter = [false, true];
    }

    int totalDaysSinceStart =
        DateTime.now().difference(streak.addedDate).inDays + 1;
    int subTotalDaysSinceStart = streak.list.length;

    int totalDaysthisMonth = DateTime.now().day;

    int subTotalDaysthisMonth =
        streak.list.where((e) => e.month == DateTime.now().month).length;

    int totalDaysthisYear =
        DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays +
            1;
    int subTotalDaysthisYear =
        streak.list.where((e) => e.year == DateTime.now().year).length;

    if (!markedBool) {
      subTotalDaysSinceStart = totalDaysSinceStart - subTotalDaysSinceStart;
      subTotalDaysthisYear = totalDaysthisYear - subTotalDaysthisYear;
      subTotalDaysthisMonth = totalDaysthisMonth - subTotalDaysthisMonth;
    }

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToggleButtons(
          direction: Axis.horizontal,
          onPressed: (int index) {
            setState(() {
              markedBool = index == 0;
            });
          },
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          selectedBorderColor: primaryAppColor,
          selectedColor: Colors.white,
          fillColor: primaryAppColor,
          color: primaryAppColor,
          constraints: BoxConstraints(
            minHeight: ht * 0.04,
            minWidth: wt * 0.2,
          ),
          isSelected: selectedfilter,
          children: filterList.map((e) => Text(e)).toList(),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
          width: wt * 0.9,
          // height: ht * 0.4,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: const Text(
                  "Overview",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 98, 98, 98)),
                ),
              ),
              Text(
                  "Total ${markedBool ? "" : "not"} $verb since added date $subTotalDaysSinceStart/$totalDaysSinceStart"),
              Text(
                  "${markedBool ? "" : "Not "}$verb this month $subTotalDaysthisMonth/$totalDaysthisMonth"),
              Text(
                  "${markedBool ? "" : "Not "}$verb this year $subTotalDaysthisYear/$totalDaysthisYear"),
            ],
          ),
        ),
      ],
    );
  }
}
