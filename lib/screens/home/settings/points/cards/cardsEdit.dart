// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ItemInput/cost.dart';
import 'package:xpens/screens/home/settings/dev/injectData.dart';
import 'package:xpens/screens/home/settings/points/cards/cardsPointsFunc.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/dataModals/dbModals/pointSource.dart';

import '../../../../../shared/constants.dart';

class CardEdit extends StatefulWidget {
  final PointSource card;
  final double sum;

  const CardEdit({super.key, required this.card, required this.sum});
  @override
  State<CardEdit> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CardEdit> {
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

  bool editable = false;
  double points = 0;
  double rupees = 0;
  TextEditingController pointController = TextEditingController();
  TextEditingController rupeeController = TextEditingController();
  final GlobalKey<FormState> _formKeyN = GlobalKey<FormState>();
  @override
  void initState() {
    points = widget.card.points;
    pointController.text = points.toStringAsFixed(2);
    rupees = widget.card.rupees;
    rupeeController.text = widget.card.rupees.toStringAsFixed(2);
    super.initState();
  }

  double getControllerValueasDouble(TextEditingController controller) {
    double val = 0;
    if (controller.text.isNotEmpty) {
      val = double.parse(controller.text);
    }
    return val;
  }

  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfo = Provider.of<UserInfoProvider>(context);
    final user = Provider.of<User?>(context);
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;

    return Center(
        child: SizedBox(
      width: wt * 0.95,
      height: 400,
      child: AlertDialog(
          insetPadding: EdgeInsets.fromLTRB(
            0,
            0,
            0,
            ht * 0.1,
          ),
          title: Center(
              child: Text(
            widget.card.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          content: StatefulBuilder(builder: (context, setState) {
            double pointsPerRupee;
            double newpoints = getControllerValueasDouble(pointController);
            double newrupees = getControllerValueasDouble(rupeeController);
            if (newrupees == 0) {
              pointsPerRupee = 0;
            } else {
              pointsPerRupee = newpoints / newrupees;
            }
            return Column(children: [
              editable
                  ? Form(
                      key: _formKeyN,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: wt * 0.3,
                            child: ItemQuantity(
                              costs: pointController.text,
                              req: true,
                              enabled: editable,
                              hint: 'Points',
                              onctrlchange: (val) {
                                setState(() {
                                  pointController = val;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: wt * 0.1,
                            child: const Center(
                              child: Text(
                                "≈",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: wt * 0.3,
                            child: ItemQuantity(
                              costs: rupeeController.text,
                              req: true,
                              enabled: editable,
                              hint: 'Rupees',
                              onctrlchange: (val) {
                                setState(() {
                                  rupeeController = val;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("$points Point ≈ $rupees ₹"),
                        IconButton(
                            onPressed: () => setState(() => editable = true),
                            icon: const Icon(Icons.edit))
                      ],
                    ),
              editable
                  ? Text(
                      "Points per Rupee: ${pointsPerRupee.toStringAsFixed(2)}")
                  : Container(),
              const Spacer(),
              editable
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () => setState(() => editable = false),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                    const Color.fromARGB(236, 255, 255, 255))),
                            child: const Text(
                              'cancel',
                              style: TextStyle(color: secondaryAppColor),
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (_formKeyN.currentState!.validate()) {
                                setState(() {
                                  points = newpoints;
                                  rupees = newrupees;
                                  editable = false;
                                });
                                await DatabaseService(uid: user!.uid)
                                    .updatePointSource(PointSource(
                                  name: widget.card.name,
                                  selfId: widget.card.selfId,
                                  points: points,
                                  rupees: rupees,
                                ));
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        primaryAppColor)),
                            child: const Text(
                              'Update',
                              // style: TextStyle(color: secondaryAppColor),
                            )),
                      ],
                    )
                  : Container(),
              if (!editable) ...[
                ElevatedButton(
                  style: buttonDecoration,
                  onPressed: () => _selectDateRange(context),
                  child: const Text('Change Date Range'),
                ),
                const Text(
                  'Points Spent from',
                ),
                Text(
                  '${DateFormat.yMMMd().format(_startDate).toString()} to ${DateFormat.yMMMd().format(_endDate).toString()} ',
                ),
                Text(calcCardpoints(
                        sourceId: widget.card.selfId,
                        data: userInfo.pointDocs,
                        end: _endDate,
                        start: _startDate)
                    .toInt()
                    .toString())
              ]
            ]);
          })),
    ));
  }
}
