import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/listx/listStream/listStream.dart'
    show formatRupee;
import 'package:xpens/shared/dataModals/dbModals/expenseDefault.dart';

import '../../../../services/database.dart';
import '../../../../services/providers/UserInfoProvider.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/utils/CapsFirst.dart';
import '../../../../shared/utils/toast.dart';
import '../../components/ItemInput/ItemInputsMain.dart';
import '../settingsMenuItem.dart';

/// Defaults: values the Add form starts with, per entry type.
class Defaults extends StatelessWidget {
  const Defaults({super.key});

  static Map _data(dynamic doc) => doc == null ? {} : doc.data() as Map;

  static String _summary(Map d) {
    final parts = <String>[
      if (d['itemName'] != null) d['itemName'].toString(),
      if (d['location'] != null)
        d['location'] == "Personel" ? "Personal" : d['location'].toString(),
      if (d['cost'] != null) formatRupee(d['cost'] as num),
      if (d['group'] != null && d['group'] != "none" && d['group'] != "")
        d['group'].toString(),
    ];
    return parts.isEmpty ? "Not set yet" : parts.join(" · ");
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);
    // The Add tab reads the "expense" default; always offer it, even before
    // one has been saved.
    final byType = {for (final d in userInfo.defaults) d.id as String: d};
    final types = {"expense", ...byType.keys}.toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
          backgroundColor: primaryAppColor, title: const Text("Defaults")),
      body: ListView(
        padding: const EdgeInsets.only(top: 16),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Text(
              "The Add form starts with these values, so you only change what's different.",
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          SettingsSection(title: "Forms", items: [
            for (final t in types)
              SettingsItem(
                icon: t == "expense" ? Icons.currency_rupee : Icons.tune,
                title: capsFirst(t),
                subtitle: _summary(_data(byType[t])),
                onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (_) =>
                          _DefaultEditor(type: t, data: _data(byType[t]))),
                ),
              ),
          ]),
        ],
      ),
    );
  }
}

class _DefaultEditor extends StatelessWidget {
  final String type;
  final Map data;
  const _DefaultEditor({required this.type, required this.data});

  TimeOfDay _time() {
    final parts = (data['time'] ?? "").toString().split(":");
    final h = parts.length == 2 ? int.tryParse(parts[0]) : null;
    final m = parts.length == 2 ? int.tryParse(parts[1]) : null;
    return h == null || m == null
        ? TimeOfDay.now()
        : TimeOfDay(hour: h, minute: m);
  }

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<UserInfoProvider>(context).items;
    final cost = data['cost'] as num?;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: primaryAppColor,
          title: Text("${capsFirst(type)} defaults")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: secondaryAppColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Leave the amount empty to type it each time. Clear the date to always use the day you add.",
                style: TextStyle(fontSize: 13),
              ),
            ),
            ItemInputs(
              optionDefault: null,
              isData: false,
              itemName: (data['itemName'] ?? items[0]).toString(),
              costS: cost == null
                  ? ""
                  : (cost == cost.roundToDouble()
                      ? cost.toInt().toString()
                      : cost.toString()),
              group: (data['group'] ?? "none").toString(),
              date: data['date'] == null
                  ? null
                  : DateTime.tryParse(data['date'].toString()),
              location: (data['location'] ?? locationList[0]).toString(),
              remarks: (data['remarks'] ?? "").toString(),
              time: _time(),
              buttonLabel: "Save defaults",
              buttonfunc: (ExpenseDefault d) async {
                final ok = await DatabaseService(
                        uid: FirebaseAuth.instance.currentUser!.uid)
                    .updateDefaults(type: type, I: d);
                if (!context.mounted) return;
                showToast(
                    context: context,
                    msg: ok ? "Defaults saved" : "Couldn't save the defaults");
                if (ok) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
