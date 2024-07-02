import 'package:flutter/material.dart';
import 'dart:async';

import '../../../shared/constants.dart';

class StreakDetails extends StatefulWidget {
  final DateTime dateTime;

  StreakDetails({required this.dateTime});

  @override
  _StreakDetailsState createState() => _StreakDetailsState();
}

class _StreakDetailsState extends State<StreakDetails> {
  late Timer _timer;
  late Duration _difference;

  @override
  void initState() {
    super.initState();
    _updateDifference();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateDifference();
    });
  }

  void _updateDifference() {
    setState(() {
      _difference = DateTime.now().difference(widget.dateTime);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map op = _formatDuration(_difference);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getbar(limit: 24, value: op["hours"], label: "Hours"),
        const SizedBox(
          width: 10,
        ),
        getbar(limit: 60, value: op["minutes"], label: "Minutes"),
        const SizedBox(
          width: 10,
        ),
        getbar(limit: 60, value: op["seconds"], label: "Seconds")
      ],
    );
  }

  Map _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return {
      "days": days,
      "hours": hours,
      "minutes": minutes,
      "seconds": seconds
    };
  }
}

Widget getbar({required value, required limit, required label}) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Container(
        height: 100,
        width: 100,
        color: primaryAppColor,
      ),
      Container(
        height: 100 * value / limit,
        width: 100,
        color: secondaryAppColor,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            value.toString(),
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            label,
            style: TextStyle(
                color: Color.fromARGB(255, 232, 232, 232),
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
        ],
      ),
    ],
  );
}
