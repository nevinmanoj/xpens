import 'package:flutter/material.dart';

import '../../../../shared/constants.dart';

typedef TimeCallback = void Function(TimeOfDay time);

class Clock extends StatefulWidget {
  final TimeCallback onTimeChanged;
  final TimeOfDay selectTime;
  const Clock(
      {super.key, required this.onTimeChanged, required this.selectTime});
  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  TimeOfDay timeOfDay = TimeOfDay.now();
  late TimeOfDay selectTime;
  @override
  void initState() {
    selectTime = widget.selectTime;
    super.initState();
  }

  @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     // padding: const EdgeInsets.all(8.0),
  //     child: buildUI(context),
  //   );
  // }

  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 130,
      child: OutlinedButton(
          style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll<Color>(primaryAppColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
          ),
          onPressed: () => displayTimePicker(context),
          child: Text(selectTime.format(context))),
    );
  }

  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(
        context: context,
        initialTime: selectTime,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
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
        selectTime = time;
      });
    }
    widget.onTimeChanged(selectTime);
  }
}
