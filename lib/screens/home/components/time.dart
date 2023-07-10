import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../shared/constants.dart';

typedef void TimeCallback(TimeOfDay time);

class clock extends StatefulWidget {
  final TimeCallback onTimeChanged;
  TimeOfDay selectTime;
  clock({required this.onTimeChanged, required this.selectTime});
  @override
  State<clock> createState() => _clockState();
}

class _clockState extends State<clock> {
  TimeOfDay timeOfDay = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: buildUI(context),
    );
  }

  Widget buildUI(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 130,
      child: OutlinedButton(
          style: ButtonStyle(
              foregroundColor:
                  MaterialStatePropertyAll<Color>(primaryAppColor)),
          onPressed: () => displayTimePicker(context),
          child: Text(widget.selectTime.format(context))),
    );
  }

  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(
        context: context,
        initialTime: widget.selectTime,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primaryAppColor, // <-- SEE HERE
                onPrimary: secondaryAppColor, // <-- SEE HERE
                onSurface: primaryAppColor,

                // <-- SEE HERE
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: secondaryAppColor, // button text color
                ),
              ),
            ),
            child: child!,
          );
        });

    if (time != null) {
      setState(() {
        widget.selectTime = time;
      });
    }
    widget.onTimeChanged(widget.selectTime);
  }
}
