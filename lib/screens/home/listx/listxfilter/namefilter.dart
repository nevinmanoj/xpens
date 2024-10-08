import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';

class NameRadioAccordion extends StatefulWidget {
  final Function(String?) onNameChange;
  final String? selectedOption;
  const NameRadioAccordion(
      {super.key, required this.onNameChange, required this.selectedOption});
  @override
  _NameRadioAccordionState createState() => _NameRadioAccordionState();
}

class _NameRadioAccordionState extends State<NameRadioAccordion> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    List allItems = Provider.of<UserInfoProvider>(context).items;
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
                  // Update the selected option when an accordion is expanded
                  isExpanded = !isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool x) {
                    return const ListTile(
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
