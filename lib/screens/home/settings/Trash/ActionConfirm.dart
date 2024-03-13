import 'package:flutter/material.dart';

import '../../../../shared/constants.dart';

class ActionConfirm extends StatelessWidget {
  final String title;
  final String msg;
  final Function() cancel;
  final Function() delete;
  const ActionConfirm(
      {super.key,
      required this.title,
      required this.msg,
      required this.cancel,
      required this.delete});

  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Center(
        child: SizedBox(
      height: ht * 0.4,
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
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          content: Column(children: [
            Text(
              msg,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: ht * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: ht * 0.06,
                  width: wt * 0.3,
                  child: ElevatedButton(
                      onPressed: () async {
                        delete();
                      },
                      child: Text(
                        'Confirm',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              primaryAppColor))),
                ),
                SizedBox(
                  width: wt * 0.025,
                ),
                SizedBox(
                  height: ht * 0.06,
                  width: wt * 0.3,
                  child: ElevatedButton(
                      onPressed: () {
                        cancel();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: primaryAppColor, fontSize: 16),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(236, 255, 255, 255)))),
                ),
              ],
            ),
          ])),
    ));
  }
}
