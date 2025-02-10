import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class MilestoneChooseEdit extends StatelessWidget {
  final Function() current;
  final Function() all;
  final bool isOrphan;

  const MilestoneChooseEdit(
      {super.key,
      required this.current,
      required this.all,
      required this.isOrphan});

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Center(
        child: SizedBox(
      width: wt * 0.9,
      child: AlertDialog(
          insetPadding: EdgeInsets.fromLTRB(
            0,
            0,
            0,
            ht * 0.1,
          ),
          title: Center(
              child: Text(
            "Modify Current ${isOrphan ? "" : "or All"}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          content: SizedBox(
            height: 200,
            child: Column(children: [
              Text(
                "Only change current milestone (Current) ${isOrphan ? "" : "or current and upcomming(All)"}",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: ht * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: ht * 0.06,
                    width: wt * 0.23,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: secBtnDecoration,
                        child: const Text(
                          'Cancel',
                          style:
                              TextStyle(fontSize: 16, color: primaryAppColor),
                        )),
                  ),
                  SizedBox(
                    height: ht * 0.06,
                    width: wt * 0.23,
                    child: ElevatedButton(
                        onPressed: () async {
                          current();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        style: buttonDecoration,
                        child: const Text(
                          'Current',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                  ),
                  if (!isOrphan)
                    SizedBox(
                      height: ht * 0.06,
                      width: wt * 0.23,
                      child: ElevatedButton(
                          onPressed: () async {
                            all();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          style: buttonDecoration,
                          child: const Text(
                            'All',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          )),
                    ),
                ],
              ),
            ]),
          )),
    ));
  }
}
