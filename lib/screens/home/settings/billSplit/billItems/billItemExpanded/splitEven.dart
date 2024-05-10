import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:get/get.dart';
import 'package:xpens/screens/home/settings/billSplit/billSplitGetxController.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/BillISplitModal.dart';

class SplitEven extends StatefulWidget {
  final Function(List<Share>) updateShares;
  final List<Share> shares;
  final double cost;
  final String itemName;

  const SplitEven({
    super.key,
    required this.updateShares,
    required this.shares,
    required this.cost,
    required this.itemName,
  });
  @override
  State<SplitEven> createState() => _SplitEvenState();
}

class _SplitEvenState extends State<SplitEven> {
  final ctrl = Get.put(BillSplitController());

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: ctrl.persons.keys.length,
        itemBuilder: ((context, index) {
          Share? shr = widget.shares.firstWhereOrNull(
              (element) => element.person == ctrl.persons.keys.toList()[index]);
          String subTotal = "0";
          if (shr != null) {
            subTotal = (widget.cost * shr.fraction.toDouble()).toString();
          }

          return Row(
            children: [
              Checkbox(
                  checkColor: secondaryAppColor,
                  activeColor: primaryAppColor,
                  value: shr != null,
                  onChanged: (value) {
                    List<Share> newshares = [];
                    if (value!) {
                      int denominator = widget.shares.length + 1;
                      newshares = widget.shares
                          .map((e) => Share(
                              person: e.person,
                              fraction: Fraction(1, denominator),
                              itemName: e.itemName))
                          .toList();
                      newshares.add(Share(
                          person: ctrl.persons.keys.toList()[index],
                          fraction: Fraction(1, denominator),
                          itemName: widget.itemName));
                    } else {
                      int denominator = widget.shares.length - 1;
                      if (denominator == 0) {
                        widget.updateShares([]);
                      } else {
                        newshares = widget.shares
                            .map((e) => Share(
                                person: e.person,
                                fraction: Fraction(1, denominator),
                                itemName: e.itemName))
                            .toList();
                        newshares.removeWhere((ele) =>
                            ele.person == ctrl.persons.keys.toList()[index]);
                      }
                    }
                    widget.updateShares(newshares);
                  }),
              Text(
                ctrl.persons.keys.toList()[index],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  subTotal,
                ),
              )
            ],
          );
        }));
  }
}
