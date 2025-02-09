import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/enums/Period.dart';
import 'package:xpens/shared/utils/CapsFirst.dart';

class PeriodFilterAccordion extends StatefulWidget {
  final Function(Period) onChange;
  final List selectedOptions;
  const PeriodFilterAccordion(
      {super.key, required this.onChange, required this.selectedOptions});
  @override
  State<PeriodFilterAccordion> createState() => _PeriodFilterAccordionState();
}

class _PeriodFilterAccordionState extends State<PeriodFilterAccordion> {
  bool isExpanded = false;

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
                  body: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var p in Period.values)
                        CheckboxListTile(
                          checkColor: secondaryAppColor,
                          activeColor: primaryAppColor,
                          title: Text(capsFirst(p.name)),
                          value: widget.selectedOptions.contains(p),
                          onChanged: (bool? value) {
                            widget.onChange(p);
                          },
                        ),
                    ],
                  ),
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
