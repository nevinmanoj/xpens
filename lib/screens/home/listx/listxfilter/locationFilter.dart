import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class LocRadioAccordion extends StatefulWidget {
  final Function(String?) onLocChange;
  final String? selectedOption;
  LocRadioAccordion({required this.onLocChange, required this.selectedOption});
  @override
  _LocRadioAccordionState createState() => _LocRadioAccordionState();
}

class _LocRadioAccordionState extends State<LocRadioAccordion> {
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
                        "Location",
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
                        toggleable: true,
                        title: Text("Personel"),
                        value: "Personel",
                        groupValue: widget.selectedOption,
                        onChanged: (value) {
                          // if (value != null) {
                          setState(() {
                            widget.onLocChange(value);
                          });
                          // }
                        },
                      ),
                      RadioListTile(
                        activeColor: primaryAppColor,
                        toggleable: true,
                        title: Text("Home"),
                        value: "Home",
                        groupValue: widget.selectedOption,
                        onChanged: (value) {
                          // if (value != null) {

                          setState(() {
                            widget.onLocChange(value);
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
