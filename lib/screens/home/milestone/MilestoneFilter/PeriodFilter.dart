import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/enums/Period.dart';
import 'package:xpens/shared/utils/CapsFirst.dart';

import '../MilestoneGetx.dart';

class PeriodFilterAccordion extends StatefulWidget {
  const PeriodFilterAccordion({super.key});
  @override
  State<PeriodFilterAccordion> createState() => _PeriodFilterAccordionState();
}

class _PeriodFilterAccordionState extends State<PeriodFilterAccordion> {
  bool isExpanded = false;
  final controller = Get.put(MilestoneFilterController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionPanelList(
              elevation: 0,
              expandedHeaderPadding: const EdgeInsets.all(0),
              expansionCallback: (int index, bool x) {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool x) {
                    return const ListTile(
                      title: Text(
                        "Period",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                  body:
                      GetBuilder<MilestoneFilterController>(builder: (context) {
                    return Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var p in Period.values)
                          CheckboxListTile(
                            checkColor: secondaryAppColor,
                            activeColor: primaryAppColor,
                            title: Text(capsFirst(p.name)),
                            value: controller.periodList.contains(p),
                            onChanged: (bool? value) {
                              // widget.onChange(p);
                              controller.modifyPeriodList(p);
                            },
                          ),
                      ],
                    );
                  }),
                  isExpanded: isExpanded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
