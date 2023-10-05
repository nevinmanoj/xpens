import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:xpens/shared/constants.dart';
import 'package:intl/intl.dart';

// DateTime currentPhoneDate = DateTime.now();

typedef void DateCallback(DateTime date);

class Calendar extends StatefulWidget {
  final DateCallback onDateChanged;
  final DateTime dateToDisplay;
  Calendar({required this.onDateChanged, required this.dateToDisplay});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime dateToDisplay;
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
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
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
      selectdate == null
          ? dateToDisplay = DateTime.now()
          : dateToDisplay = selectdate;
    });
    widget.onDateChanged(dateToDisplay);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 130,
      child: OutlinedButton(
        style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll<Color>(primaryAppColor)),
        onPressed: () {
          _selectDate(context);
        },
        child: Text(
          DateFormat.yMMMd().format(widget.dateToDisplay).toString(),
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
