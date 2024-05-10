// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:xpens/screens/home/settings/billSplit/billSplitGetxController.dart';
import 'package:xpens/screens/home/settings/billSplit/persons/PersonExpanded.dart';

import '../../../components/addItem.dart';
import 'PersonWidget.dart';

class PersonsMain extends StatefulWidget {
  const PersonsMain({super.key});

  @override
  State<PersonsMain> createState() => _PersonsMainState();
}

class _PersonsMainState extends State<PersonsMain> {
  final ctrl = Get.put(BillSplitController());
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    // double wt = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        GetBuilder<BillSplitController>(builder: (context) {
          return ListView.builder(
              itemCount: ctrl.persons.keys.length,
              itemBuilder: ((context, index) => InkWell(
                  onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => PersonExpanded(
                                name: ctrl.persons.keys.toList()[index],
                              ))),
                  child: PersonWidget(
                      name: ctrl.persons.keys.toList()[index],
                      amnt: ctrl.persons[ctrl.persons.keys.toList()[index]]
                          .toString()))));
        }),
        AddItemWidget(
          icon: Icons.person_add,
          tag: 'itemName',
          addFunc: (name) async {
            ctrl.addPerson(name);
          },
          btnPostionBottom: ht * 0.09,
          postionBottom: ht * 0.08,
          btnPositionRight: 10,
        ),
      ],
    );
  }
}
