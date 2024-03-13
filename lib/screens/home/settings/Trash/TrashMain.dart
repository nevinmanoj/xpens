import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../services/providers/UserInfoProvider.dart';
import '../../../../shared/constants.dart';
import 'TrashBody.dart';
import 'TrashSelector.dart';
import 'package:intl/intl.dart';

class TrashMain extends StatefulWidget {
  const TrashMain({super.key});

  @override
  State<TrashMain> createState() => _TrashMainState();
}

class _TrashMainState extends State<TrashMain> {
  String type = inputTypes[0];
  void ontypeChange(newType) {
    setState(() {
      type = newType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
      ),
      body: Stack(
        children: [
          TrashBody(
            type: type,
          ),
          TrashSelector(
            value: type,
            onValChange: ontypeChange,
          ),
        ],
      ),
    );
  }
}
