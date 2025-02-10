import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xpens/shared/constants.dart';

class StreakSettingRow extends StatefulWidget {
  final String value;
  final String title;
  final Function(String) onConfirm;
  const StreakSettingRow(
      {super.key,
      required this.onConfirm,
      required this.title,
      required this.value});

  @override
  State<StreakSettingRow> createState() => _StreakSettingRowState();
}

class _StreakSettingRowState extends State<StreakSettingRow> {
  bool updateName = false;
  String value = "";
  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  final _formKeyN = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    return Form(
      key: _formKeyN,
      child: Column(
        children: [
          SizedBox(
            width: wt,
            child: Text(widget.title,
                style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!updateName)
                Text(value,
                    style: TextStyle(
                        color: Colors.grey[600], fontWeight: FontWeight.w400))
              else
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  decoration: addInputDecoration,
                  width: wt * 0.665,
                  child: TextFormField(
                      initialValue: value,
                      validator: (value) => value!.isEmpty
                          ? '${widget.title} cannot be empty'
                          : null,
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.left,
                      onChanged: (v) {
                        value = v;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        constraints: BoxConstraints(maxWidth: 0.8 * wt),
                      )),
                ),
              if (!updateName)
                InkWell(
                    onTap: () {
                      setState(() => updateName = true);
                    },
                    child: const Icon(
                      Icons.edit,
                      color: Color.fromARGB(255, 188, 188, 188),
                    )),
            ],
          ),
          if (updateName)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        value = widget.value;
                        updateName = false;
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(236, 255, 255, 255))),
                    child: const Text(
                      'cancel',
                      style: TextStyle(color: secondaryAppColor),
                    )),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKeyN.currentState!.validate()) {
                        widget.onConfirm(value);

                        setState(() => updateName = false);
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryAppColor)),
                    child: const Text(
                      'Update',
                      // style: TextStyle(color: secondaryAppColor),
                    )),
              ],
            ),
        ],
      ),
    );
  }
}
