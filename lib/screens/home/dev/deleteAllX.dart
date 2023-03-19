import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:xpens/shared/constants.dart';

class DeleteAllX extends StatefulWidget {
  const DeleteAllX({super.key});

  @override
  State<DeleteAllX> createState() => _DeleteAllXState();
}

class _DeleteAllXState extends State<DeleteAllX> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return ElevatedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(
                child: SizedBox(
                    height: ht * 0.5,
                    child: AlertDialog(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              style: buttonDecoration,
                              onPressed: () {},
                              child: const Text("Confirm")),
                          ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  )),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          secondaryAppColor)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.black),
                              ))
                        ],
                      ),
                      title: Center(child: const Text("Delete all expenses")),
                    )),
              );
            });
      },
      style: buttonDecoration,
      child: Text("Delete all expenses"),
    );
  }
}
