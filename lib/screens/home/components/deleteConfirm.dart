import 'package:flutter/material.dart';
import '../../../shared/constants.dart';

class DeleteConfirm extends StatefulWidget {
  final String title;
  final String msg;
  final Function() cancel;
  final Function() delete;

  const DeleteConfirm({
    required this.title,
    required this.cancel,
    required this.delete,
    required this.msg,
  });
  @override
  State<DeleteConfirm> createState() => _DeleteConfirmState();
}

class _DeleteConfirmState extends State<DeleteConfirm> {
  @override
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
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          content: Column(children: [
            Text(
              widget.msg,
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
                        widget.delete();
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
                        widget.cancel();
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
