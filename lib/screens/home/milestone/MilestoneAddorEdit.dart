import 'package:flutter/material.dart';
import 'package:xpens/screens/home/components/ItemInput/cost.dart';
import 'package:xpens/screens/home/components/ItemInput/dropDown.dart';
import 'package:xpens/screens/home/components/ItemInput/remarks.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/enums/Period.dart';
import 'package:xpens/shared/utils/safeParse.dart';

class MilestoneAddorEdit extends StatefulWidget {
  final String title;
  final double? curVal;
  final Period period;
  final double? endVal;
  final bool skipFirst;
  final bool isAdd;

  final Function(
      {required String title,
      required double? curVal,
      required Period period,
      required double? endVal,
      required bool skipFirst,
      required BuildContext bc}) submit;
  const MilestoneAddorEdit(
      {super.key,
      required this.isAdd,
      required this.submit,
      required this.title,
      required this.curVal,
      required this.period,
      this.endVal,
      required this.skipFirst});

  @override
  State<MilestoneAddorEdit> createState() => _MilestoneAddorEditState();
}

class _MilestoneAddorEditState extends State<MilestoneAddorEdit> {
  final _msformKey = GlobalKey<FormState>();
  late String title;
  late Period period;
  late double? endVal;
  late bool skipFirst;
  late double? curVal;

  @override
  void initState() {
    title = widget.title;
    period = widget.period;
    curVal = widget.curVal;
    endVal = widget.endVal;
    skipFirst = widget.skipFirst;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
      ),
      body: Form(
        key: _msformKey,
        child: SizedBox(
          width: wt,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ItemRemark(
                    required: true,
                    onctrlchange: (TextEditingController t) {
                      title = t.text;
                    },
                    remarks: title,
                    hint: 'Title',
                  ),
                  SizedBox(
                    height: ht * 0.015,
                  ),
                  DropDownItems(
                    enabled: widget.isAdd,
                    onValueChange: (String p) {
                      period = deserializePeriod(p);
                    },
                    valueList: Period.values.map((e) => e.name).toList(),
                    value: serializePeriod(period),
                    heading: 'Period of repetion',
                  ),
                  SizedBox(
                    height: ht * 0.015,
                  ),
                  widget.isAdd
                      ? Container()
                      : ItemQuantity(
                          hint: "Current value",
                          enabled: true,
                          costs: curVal == null ? '' : curVal.toString(),
                          req: false,
                          onctrlchange: (TextEditingController t) {
                            curVal = safeDoubleParse(t.text);
                          },
                        ),
                  widget.isAdd
                      ? Container()
                      : SizedBox(
                          height: ht * 0.015,
                        ),
                  ItemQuantity(
                    hint: "End value",
                    enabled: true,
                    costs: endVal == null ? '' : endVal.toString(),
                    req: false,
                    onctrlchange: (TextEditingController t) {
                      endVal = safeDoubleParse(t.text);
                    },
                  ),
                  SizedBox(
                    height: ht * 0.13,
                    width: wt * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Skip first period",
                            style: TextStyle(
                              color: widget.isAdd ? Colors.black : Colors.grey,
                            )),
                        Checkbox(
                            checkColor: secondaryAppColor,
                            activeColor: primaryAppColor,
                            value: skipFirst,
                            onChanged: widget.isAdd
                                ? (val) {
                                    setState(() {
                                      skipFirst = val!;
                                    });
                                  }
                                : null),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_msformKey.currentState!.validate()) {
                          await widget.submit(
                              bc: context,
                              title: title,
                              curVal: curVal,
                              period: period,
                              endVal: endVal,
                              skipFirst: skipFirst);
                        }
                      },
                      style: buttonDecoration,
                      child: Center(
                          child: Text(widget.isAdd ? "Add" : "Modify",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
