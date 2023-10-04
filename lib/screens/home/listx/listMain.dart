// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:xpens/screens/home/listx/listStream/listStream.dart';
import 'package:xpens/screens/home/listx/listxfilter/listFilter.dart';

import 'search/listSearchMain.dart';

class listx extends StatefulWidget {
  const listx({super.key});

  @override
  State<listx> createState() => _listxState();
}

class _listxState extends State<listx> {
  var filter = {};
  void onFilterChange(var newfilter) {
    setState(() {
      filter = newfilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBodyState(
          filter: filter,
        ),
        ListSearchMain(
          filter: filter,
          onStreamChange: onFilterChange,
        ),
        FilterWindow(
          onFilterChange: onFilterChange,
        ),
      ],
    );
  }
}
