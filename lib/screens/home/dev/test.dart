// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

import 'GroupSummary/GroupSummaryMain.dart';

class Test extends StatefulWidget {
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    // double wt = MediaQuery.of(context).size.width;
    // double ht = MediaQuery.of(context).size.height;
    return Column(
      children: [
        ElevatedButton(
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GroupSummaryMain()));
            },
            child: Text("test")),
        AutocompleteExample()
      ],
    );
  }
}

class AutocompleteExample extends StatefulWidget {
  @override
  _AutocompleteExampleState createState() => _AutocompleteExampleState();
}

class _AutocompleteExampleState extends State<AutocompleteExample> {
  final List<String> suggestions = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape',
    'Honeydew',
    'Kiwi',
    'Lemon',
  ];

  TextEditingController textEditingController = TextEditingController();
  String? selectedSuggestion;

  @override
  void dispose() {
    // textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              // Filter the suggestions based on the user's input
              final query = textEditingValue.text.toLowerCase();
              return suggestions
                  .where(
                      (suggestion) => suggestion.toLowerCase().contains(query))
                  .toList();
            },
            onSelected: (String value) {
              // Update the selected suggestion when an option is selected
              setState(() {
                selectedSuggestion = value;
              });
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              this.textEditingController = textEditingController;
              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                onChanged: (text) {
                  // Notify the Autocomplete widget of changes in the text input
                  onFieldSubmitted();
                },
                decoration: InputDecoration(
                  labelText: 'Type a fruit',
                ),
              );
            },
            optionsViewBuilder: (BuildContext context,
                AutocompleteOnSelected<String> onSelected,
                Iterable<String> options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  child: SizedBox(
                    height: 200.0,
                    child: ListView(
                      children: options
                          .map((String option) => ListTile(
                                title: Text(option),
                                onTap: () {
                                  onSelected(option);
                                  textEditingController.text =
                                      option; // Set the selected value to the text input
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Selected Suggestion: $selectedSuggestion'),
        ),
      ],
    );
  }
}
