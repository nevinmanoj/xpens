import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class MilestonePopupAddVal extends StatefulWidget {
  final Function() cancel;
  final Function(String) addVal;
  const MilestonePopupAddVal(
      {super.key, required this.cancel, required this.addVal});

  @override
  State<MilestonePopupAddVal> createState() => _MilestonePopupAddValState();
}

class _MilestonePopupAddValState extends State<MilestonePopupAddVal> {
  String val = "0";
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;

    return Column(
      children: [
        TextField(
          onChanged: (value) => setState(() => val = value),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              width: wt * 0.25,
              height: ht * 0.05,
              child: OutlinedButton(
                // style: buttonDecoration,
                onPressed: () => widget.cancel(),
                child: const Center(
                    child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                )),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              width: wt * 0.3,
              height: ht * 0.05,
              child: ElevatedButton(
                style: buttonDecoration,
                onPressed: () => widget.addVal(val),
                child: const Center(
                    child: Text(
                  "Add to Total",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )),
              ),
            )
          ],
        )
      ],
    );
  }
}
