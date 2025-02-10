import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/Streaks/StreakSettings/StreakSettingRow.dart';
import 'package:xpens/screens/home/components/ActionConfirm.dart';
import 'package:xpens/screens/home/components/ItemInput/dropDown.dart';
import 'package:xpens/services/streakDatabase.dart';
import 'package:xpens/shared/dataModals/dbModals/streakModal.dart';

class StreakSettings extends StatefulWidget {
  final Streak ss;
  final Function setDefault;
  const StreakSettings({super.key, required this.ss, required this.setDefault});

  @override
  State<StreakSettings> createState() => _StreakSettingsState();
}

class _StreakSettingsState extends State<StreakSettings> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    double wt = MediaQuery.of(context).size.width;
    return StatefulBuilder(builder: (context, snapshot) {
      return AlertDialog(
        title: const Center(child: Text("Streak Settings")),
        content: SizedBox(
          height: 300,
          // width: wt * 0.8,
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreakSettingRow(
                  onConfirm: (String v) {
                    StreakDatabaseService(uid: user!.uid).editStreakProperty(
                        key: "verb", value: v, selfId: widget.ss.selfId);
                  },
                  title: 'VERB',
                  value: widget.ss.verb,
                ),
                const SizedBox(
                  height: 10,
                ),
                StreakSettingRow(
                  onConfirm: (String v) {
                    StreakDatabaseService(uid: user!.uid).editStreakProperty(
                        key: "title", value: v, selfId: widget.ss.selfId);
                  },
                  title: 'TITLE',
                  value: widget.ss.title,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: wt,
                  child: Text('MARKED DATE COLOR',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                ),
                DropDownItems(
                  onValueChange: (val) {
                    StreakDatabaseService(uid: user!.uid).editStreakProperty(
                        selfId: widget.ss.selfId,
                        value: val == "red",
                        key: 'selectRed');
                  },
                  valueList: const ["red", "green"],
                  value: widget.ss.selectRed ? "red" : "green",
                  heading: 'color',
                  enabled: true,
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: ((context) => ActionConfirm(
                              title: "Delete",
                              msg: "Delete current streak?",
                              cancel: () => Navigator.pop(context),
                              confirm: () {
                                widget.setDefault();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                StreakDatabaseService(uid: user!.uid)
                                    .deleteStreak(selfId: widget.ss.selfId);
                              })));
                    },
                    child: const Text("Delete Streak"))
              ],
            ),
          ),
        ),
      );
    });
  }
}
