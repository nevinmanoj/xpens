import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class OrderByRadioAccordion extends StatefulWidget {
  final Function(String?) onOrderChange;
  final String? selectedOption;
  const OrderByRadioAccordion(
      {super.key, required this.onOrderChange, required this.selectedOption});
  @override
  _OrderByRadioAccordionState createState() => _OrderByRadioAccordionState();
}

class _OrderByRadioAccordionState extends State<OrderByRadioAccordion> {
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
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  // Update the selected option when an accordion is expanded
                  isExpanded = !isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const ListTile(
                      title: Text(
                        "Order By",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                  body: Column(
                    children: [
                      RadioListTile(
                        activeColor: primaryAppColor,
                        // toggleable: true,
                        title: const Text("Latest to Oldest"),
                        value: "new",
                        groupValue: widget.selectedOption,
                        onChanged: (value) {
                          // if (value != null) {

                          setState(() {
                            widget.onOrderChange(value);
                          });
                          // }
                        },
                      ),
                      RadioListTile(
                        activeColor: primaryAppColor,
                        // toggleable: true,
                        title: const Text("Oldest to Latest"),
                        value: "old",
                        groupValue: widget.selectedOption,
                        onChanged: (value) {
                          // if (value != null) {
                          setState(() {
                            widget.onOrderChange(value);
                          });
                          // }
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
