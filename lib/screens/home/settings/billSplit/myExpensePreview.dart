import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/database.dart';
import '../../../../services/providers/BillSplitProvider.dart';
import '../../../../services/providers/UserInfoProvider.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/dataModals/AddItemModal.dart';
import '../../../../shared/dataModals/billSplitModels.dart';
import '../../../../shared/utils/toast.dart';
import '../../components/ItemInput/ItemInputsMain.dart';

/// The normal expense form prefilled with my share of the bill. Nothing is
/// saved until I review it and tap Add.
class MyExpensePreview extends StatelessWidget {
  const MyExpensePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final bill = context.read<BillSplitProvider>();
    final userInfo = Provider.of<UserInfoProvider>(context, listen: false);
    final me = bill.me!;
    final myTotal = bill.totals[me.id] ?? 0;

    // Same lookup as the Add page, so my Expense defaults still apply.
    dynamic expenseDefault;
    for (final d in userInfo.defaults) {
      if (d["type"] == "expense") expenseDefault = d;
    }
    String def(String key, dynamic fallback) =>
        (expenseDefault?[key] ?? fallback).toString();

    final names = [for (final (item, _) in bill.breakdown(me.id)) item.name];
    final shown = names.take(4).join(", ");
    final more = names.length > 4 ? " +${names.length - 4} more" : "";
    final remarks = "Bill split (${bill.people.length} people): $shown$more";

    Future<void> addExpense(AddItem item) async {
      final user = Provider.of<User?>(context, listen: false);
      final ok = await DatabaseService(uid: user!.uid).addItem(item);
      if (!context.mounted) return;
      showToast(
          context: context,
          msg: "Expense added ${ok ? "successfully" : "failed"}");
      if (ok) Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        title: const Text("Review expense"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 30, bottom: 30),
        child: ItemInputs(
          optionDefault: null,
          isData: true,
          itemName: def("itemName", userInfo.items[0]),
          costS: paiseToInput(myTotal),
          group: def("group", "none"),
          date: DateTime.now(),
          location: def("location", locationList[0]),
          remarks: remarks,
          time: TimeOfDay.now(),
          buttonLabel: "Add",
          buttonfunc: addExpense,
        ),
      ),
    );
  }
}
