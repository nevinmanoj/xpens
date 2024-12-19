import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';
import 'package:intl/intl.dart';

// DateTime currentPhoneDate = DateTime.now();

typedef DateCallback = void Function(DateTime? date);

class Calendar extends StatefulWidget {
  final bool isData;
  final DateCallback onDateChanged;
  final DateTime? dateToDisplay;
  const Calendar(
      {super.key,
      required this.onDateChanged,
      required this.dateToDisplay,
      required this.isData});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime? dateToDisplay;
  @override
  void initState() {
    // TODO: implement initState
    dateToDisplay = widget.dateToDisplay;
    super.initState();
  }

  _selectDate(BuildContext context) async {
    var selectdate = await showDatePicker(
      context: context,
      initialDate: widget.dateToDisplay,
      currentDate: widget.dateToDisplay,
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
      cancelText: widget.isData ? "cancel" : "clear",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryAppColor, // <-- SEE HERE
              onPrimary: secondaryAppColor, // <-- SEE HERE
              onSurface: primaryAppColor, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    setState(() {
      if (selectdate != null || !widget.isData) {
        dateToDisplay = selectdate;
        widget.onDateChanged(dateToDisplay);
      }
    });
  }

  @override
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
        onPressed: () {
          _selectDate(context);
        },
        child: Text(
          widget.dateToDisplay == null
              ? "select date"
              : DateFormat.yMMMd().format(widget.dateToDisplay!).toString(),
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
