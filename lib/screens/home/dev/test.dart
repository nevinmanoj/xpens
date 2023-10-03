// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

import 'GroupReport/GroupReportMain.dart';

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
        MyForm(),
        ElevatedButton(
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GroupReportMain()));
            },
            child: Text("testgrp")),

        // AutocompleteExample()
      ],
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Enter text',
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                      });
                    },
                  )
                : null,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Do something with the text input
            print('Text: ${_controller.text}');
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
