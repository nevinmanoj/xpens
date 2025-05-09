import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ItemInput/cost.dart';
import 'package:xpens/screens/home/components/ItemInput/dropDown.dart';
import 'package:xpens/screens/home/components/ItemInput/group.dart';
import 'package:xpens/screens/home/components/ItemInput/remarks.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/dbModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/MilestoneTemplateModal.dart';
import 'package:xpens/shared/dataModals/enums/Period.dart';
import 'package:xpens/shared/dataModals/subModals/MilestoneValue.dart';
import 'package:xpens/shared/utils/safeParse.dart';

class MilestoneAddorEdit extends StatefulWidget {
  final bool isAdd;
  final Milestone? inputms;

  final Function(
      {required Milestone? newms,
      required MilestoneTemplate newmst,
      required BuildContext bc}) submit;
  const MilestoneAddorEdit(
      {super.key,
      required this.isAdd,
      required this.submit,
      required this.inputms});

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
  String? group;

  @override
  void initState() {
    if (widget.inputms != null) {
      title = widget.inputms!.title;
      period = widget.inputms!.period;
      curVal = widget.inputms!.currentVal;
      endVal = widget.inputms!.endVal;
      skipFirst = widget.inputms!.skipFirst;
      group = widget.inputms!.group;
    } else {
      title = '';
      period = Period.daily;
      skipFirst = false;
      curVal = null;
      endVal = null;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    List msdocs = Provider.of<UserInfoProvider>(context).milestones;

    return Form(
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
                        enabled: widget.isAdd,
                        costs: curVal == null ? '' : curVal.toString(),
                        req: false,
                        onctrlchange: (TextEditingController t) {
                          if (t.text == '') {
                            curVal = null;
                          } else {
                            curVal = safeDoubleParse(t.text);
                          }
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
                    if (t.text == '') {
                      endVal = null;
                    } else {
                      endVal = safeDoubleParse(t.text);
                    }
                  },
                ),
                SizedBox(
                  // height: ht * 0.13,
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
                ItemGroup(
                  avoidValue: null,
                  docs: msdocs,
                  itemGroup: group,
                  onGroupChange: (g) {
                    group = g;
                  },
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      MilestoneTemplate mst = MilestoneTemplate(
                          addedDate: DateTime.now(),
                          title: title,
                          templateId: widget.inputms != null
                              ? widget.inputms!.templateID
                              : "place_holder",
                          period: period,
                          group: group,
                          skipFirst: skipFirst,
                          endVal: endVal);
                      if (_msformKey.currentState!.validate()) {
                        Milestone? ms;
                        if (widget.inputms != null) {
                          ms = Milestone(
                              isOrphan: widget.inputms!.isOrphan,
                              dateRange: widget.inputms!.dateRange,
                              currentVal: curVal,
                              endVal: endVal,
                              selfId: widget.inputms!.selfId,
                              title: title,
                              period: widget.inputms!.period,
                              templateID: widget.inputms!.templateID,
                              currentStatus: widget.inputms!.currentStatus,
                              skipFirst: skipFirst,
                              values: widget.inputms!.values,
                              idCount: widget.inputms!.idCount,
                              group: group);
                        }
                        await widget.submit(
                            bc: context, newms: ms, newmst: mst);
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
    );
  }
}
