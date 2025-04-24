import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/enums/Period.dart';
import 'package:xpens/shared/utils/CapsFirst.dart';

import '../../../../services/providers/UserInfoProvider.dart';
import '../MilestoneGetx.dart';

class GroupFilterAccordion extends StatefulWidget {
  const GroupFilterAccordion({super.key});
  @override
  State<GroupFilterAccordion> createState() => _GroupFilterAccordionState();
}

class _GroupFilterAccordionState extends State<GroupFilterAccordion> {
  bool isExpanded = false;
  final controller = Get.put(MilestoneFilterController());
  @override
  Widget build(BuildContext context) {
    List list = Provider.of<UserInfoProvider>(context).milestones;

    Set<String> uniqueGroupNames = {};

    for (var item in list) {
      if (item["group"] != null) {
        uniqueGroupNames.add(item["group"]);
      }
    }
    List<String> kOptions = uniqueGroupNames.toList();
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
                        "Groups",
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
                        for (var group in kOptions)
                          CheckboxListTile(
                            checkColor: secondaryAppColor,
                            activeColor: primaryAppColor,
                            title: Text(group),
                            value: controller.groups.contains(group) ||
                                controller.groups.isEmpty,
                            onChanged: (bool? value) {
                              // widget.onChange(p);
                              controller.modifyGroupsList(group);
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
