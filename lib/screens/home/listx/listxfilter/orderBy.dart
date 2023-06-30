import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class OrderByRadioAccordion extends StatefulWidget {
  final Function(String?) onOrderChange;
  String? selectedOption;
  OrderByRadioAccordion(
      {required this.onOrderChange, required this.selectedOption});
  @override
  _OrderByRadioAccordionState createState() => _OrderByRadioAccordionState();
}

class _OrderByRadioAccordionState extends State<OrderByRadioAccordion> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionPanelList(
              elevation: 0,
              expandedHeaderPadding: EdgeInsets.all(0),
              expansionCallback: (int index, bool _isExpanded) {
                setState(() {
                  // Update the selected option when an accordion is expanded
                  isExpanded = !_isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool _isExpanded) {
                    return ListTile(
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
                        title: Text("Spent Date"),
                        value: "Spent Date",
                        groupValue: widget.selectedOption,
                        onChanged: (value) {
                          // if (value != null) {
                          setState(() {
                            widget.selectedOption = value;
                            widget.onOrderChange(value);
                          });
                          // }
                        },
                      ),
                      RadioListTile(
                        activeColor: primaryAppColor,
                        // toggleable: true,
                        title: Text("Date added"),
                        value: "Date added",
                        groupValue: widget.selectedOption,
                        onChanged: (value) {
                          // if (value != null) {

                          setState(() {
                            widget.selectedOption = value;
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
