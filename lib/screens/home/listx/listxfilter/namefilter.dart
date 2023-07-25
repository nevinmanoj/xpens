import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/providers.dart';
import 'package:xpens/shared/constants.dart';

class NameRadioAccordion extends StatefulWidget {
  final Function(String?) onNameChange;
  String? selectedOption;
  NameRadioAccordion(
      {required this.onNameChange, required this.selectedOption});
  @override
  _NameRadioAccordionState createState() => _NameRadioAccordionState();
}

class _NameRadioAccordionState extends State<NameRadioAccordion> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    List allItems = Provider.of<UserInfoProvider>(context).items;
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
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                  body: Column(
                    children: [
                      for (int i = 0; i < allItems.length; i++)
                        RadioListTile(
                          activeColor: primaryAppColor,
                          toggleable: true,
                          title: Text(allItems[i]),
                          value: allItems[i],
                          groupValue: widget.selectedOption,
                          onChanged: (value) {
                            // if (value != null) {
                            setState(() {
                              widget.selectedOption = value;
                              widget.onNameChange(value);
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
