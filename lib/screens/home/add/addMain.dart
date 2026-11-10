import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/add/welcome.dart';
import 'package:xpens/screens/home/components/ItemInput/ItemInputsMain.dart';
import 'package:xpens/screens/home/settings/points/PointsMain.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/dataModals/dbModals/card.dart';
import 'package:xpens/shared/utils/toast.dart';
import 'package:xpens/shared/constants.dart';

import '../../../shared/dataModals/AddItemModal.dart';
import '../../../shared/dataModals/AddPointModal.dart';
import '../components/PointInput/PointInputMain.dart';

/// Add tab: header with today's spend, then the Expense or Points form.
class AddX extends StatelessWidget {
  const AddX({super.key});

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);
    final user = Provider.of<User?>(context);
    final List allItems = userInfo.items;
    final cards = userInfo.cards.map((e) => PointSource.fromJson(e)).toList();
    final option = userInfo.option;
    final optionDefault = userInfo.defaults
        .firstWhereOrNull((e) => e["type"] == option.toLowerCase());

    String def(String key, Object fallback) =>
        optionDefault == null || optionDefault[key] == null
            ? fallback.toString()
            : optionDefault[key].toString();

    Future<void> addItem(AddItem item) async {
      final ok = await DatabaseService(uid: user!.uid).addItem(item);
      if (!context.mounted) return;
      showToast(
          context: context,
          msg: ok ? "Expense added" : "Couldn't add the expense");
    }

    Future<void> addPointSpent(AddPoint item) async {
      final ok = await DatabaseService(uid: user!.uid).addPointSpent(item);
      if (!context.mounted) return;
      showToast(
          context: context, msg: ok ? "Points added" : "Couldn't add the points");
    }

    Widget form;
    if (option == "Expense") {
      final now = TimeOfDay.now();
      final time = def("time", "${now.hour}:${now.minute}").split(":");
      form = ItemInputs(
        // Rebuild the form once defaults finish loading.
        key: ValueKey(optionDefault?.id ?? "no-default"),
        optionDefault: optionDefault,
        isData: true,
        itemName: def("itemName", allItems[0]),
        costS: def("cost", ""),
        group: def("group", "none"),
        date: DateTime.parse(def("date", DateTime.now())),
        location: def("location", locationList[0]),
        remarks: def("remarks", ""),
        time: TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1])),
        buttonLabel: "Add expense",
        buttonfunc: addItem,
      );
    } else if (cards.isEmpty) {
      form = const _NoCards();
    } else {
      form = PointInputMain(
        cardName: cards[0].name,
        sourceId: cards[0].selfId,
        costS: "",
        group: "none",
        date: DateTime.now(),
        location: locationList[0],
        itemName: "",
        time: TimeOfDay.now(),
        buttonLabel: "Add points",
        buttonfunc: addPointSpent,
      );
    }

    return Column(
      children: [
        const Welcome(),
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: form,
          ),
        ),
      ],
    );
  }
}

class _NoCards extends StatelessWidget {
  const _NoCards();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 80, 32, 32),
      child: Column(
        children: [
          Icon(Icons.credit_card, size: 56, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text("No cards yet",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text("Add a card to start logging points.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryAppColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PointsMain())),
            child: const Text("Add a card",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
