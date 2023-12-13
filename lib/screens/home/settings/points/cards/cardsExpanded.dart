// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../services/providers/UserInfoProvider.dart';
import '../../../../../shared/constants.dart';
import 'cardsPointsFunc.dart';

class ExpandCard extends StatefulWidget {
  final String card;
  final double sum;

  const ExpandCard({super.key, required this.card, required this.sum});
  @override
  State<ExpandCard> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ExpandCard> {
  DateTime _startDate = DateTime(
      DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
  DateTime _endDate = DateTime.now();

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
        firstDate: DateTime(2022),
        lastDate: DateTime(2030),
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
        });

    if (picked != null &&
        picked != DateTimeRange(start: _startDate, end: _endDate)) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    UserInfoProvider userInfo = Provider.of<UserInfoProvider>(context);
    return Center(
        child: SizedBox(
      width: wt * 0.95,
      height: ht * 0.5,
      child: AlertDialog(
          insetPadding: EdgeInsets.fromLTRB(
            0,
            0,
            0,
            ht * 0.1,
          ),
          title: Center(
              child: Text(
            widget.card,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          content: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Lifetime Points Spent:"),
                Text(widget.sum.toInt().toString())
              ],
            ),
            Spacer(),
            ElevatedButton(
              style: buttonDecoration,
              onPressed: () => _selectDateRange(context),
              child: Text('Change Date Range'),
            ),
            const Text(
              'Points Spent from',
            ),
            Text(
              '${DateFormat.yMMMd().format(_startDate).toString()} to ${DateFormat.yMMMd().format(_endDate).toString()} ',
            ),
            Text(calcCardpoints(
                    card: widget.card,
                    data: userInfo.pointDocs,
                    end: _endDate,
                    start: _startDate)
                .toInt()
                .toString())
          ])),
    ));
  }
}
