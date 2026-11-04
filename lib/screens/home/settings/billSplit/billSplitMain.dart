import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../services/providers/BillSplitProvider.dart';
import '../../../../services/receiptScanner.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/dataModals/billSplitModels.dart';
import '../../../../shared/utils/toast.dart';
import 'billItemCard.dart';
import 'billItemEditSheet.dart';
import 'myExpensePreview.dart';
import 'peopleTab.dart';
import 'personWidgets.dart';
import 'receiptReview.dart';

class BillSplitMain extends StatefulWidget {
  const BillSplitMain({super.key});

  @override
  State<BillSplitMain> createState() => _BillSplitMainState();
}

class _BillSplitMainState extends State<BillSplitMain>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this)
    ..addListener(_onTabChanged);
  bool _onPeopleTab = false;

  void _onTabChanged() {
    final onPeople = _tabs.index == 1;
    if (onPeople != _onPeopleTab) setState(() => _onPeopleTab = onPeople);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bill = context.watch<BillSplitProvider>();
    final isEmpty = bill.items.isEmpty && bill.people.isEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        title: const Text("Bill Split"),
        actions: [
          IconButton(
            tooltip: "New bill",
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: isEmpty ? null : () => _confirmClear(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: secondaryAppColor,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: secondaryAppColor,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Items"),
            Tab(text: "People"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [_ItemsTab(), PeopleTab()],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryAppColor,
        tooltip: _onPeopleTab ? "Add person" : "Add item",
        onPressed: () => _onPeopleTab
            ? promptAddPerson(context)
            : showItemEditSheet(context),
        child: Icon(_onPeopleTab ? Icons.person_add : Icons.add,
            color: secondaryAppColor),
      ),
      bottomNavigationBar: _Footer(
        onPeopleTab: _onPeopleTab,
        onSummary: () => _tabs.animateTo(1),
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Start a new bill?"),
        content: const Text("All people and items will be removed."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Clear")),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<BillSplitProvider>().clear();
    }
  }
}

/// Asks for camera or gallery, runs OCR, then opens the review screen.
Future<void> startReceiptScan(BuildContext context) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    builder: (context) => SafeArea(
      child: Wrap(children: [
        ListTile(
          leading: const Icon(Icons.photo_camera),
          title: const Text("Take photo"),
          onTap: () => Navigator.pop(context, ImageSource.camera),
        ),
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text("Choose from gallery"),
          onTap: () => Navigator.pop(context, ImageSource.gallery),
        ),
      ]),
    ),
  );
  if (source == null || !context.mounted) return;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
        child: CircularProgressIndicator(color: secondaryAppColor)),
  );
  try {
    final receipt = await scanReceipt(source);
    if (!context.mounted) return;
    Navigator.pop(context); // loading
    if (receipt == null) return;
    if (receipt.lines.isEmpty) {
      showToast(context: context, msg: "No items found on the receipt");
      return;
    }
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ReceiptReview(receipt: receipt)));
  } catch (e) {
    if (!context.mounted) return;
    Navigator.pop(context); // loading
    showToast(context: context, msg: "Couldn't read the receipt");
  }
}

class _ItemsTab extends StatelessWidget {
  const _ItemsTab();

  @override
  Widget build(BuildContext context) {
    final items = context.watch<BillSplitProvider>().items;

    if (items.isEmpty) return const _EmptyState();
    return ListView.builder(
      key: const PageStorageKey("billSplitItems"),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
      itemCount: items.length,
      itemBuilder: (context, i) => BillItemCard(item: items[i]),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              "Add people in the People tab, then scan a receipt or add items by hand.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: buttonDecoration,
              onPressed: () => startReceiptScan(context),
              icon: const Icon(Icons.document_scanner_outlined),
              label: const Text("Scan receipt"),
            ),
            TextButton(
              onPressed: () => showItemEditSheet(context),
              child: const Text("Add item manually",
                  style: TextStyle(color: primaryAppColor)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final bool onPeopleTab;
  final VoidCallback onSummary;
  const _Footer({required this.onPeopleTab, required this.onSummary});

  @override
  Widget build(BuildContext context) {
    final bill = context.watch<BillSplitProvider>();
    final unsettled = bill.unsettledTotal;
    final me = bill.me;

    // The action for the current tab. It lives here rather than on the
    // People tab so the add button can't cover it.
    final String label;
    final VoidCallback? onPressed;
    if (!onPeopleTab) {
      label = "Summary";
      onPressed = bill.items.isEmpty ? null : onSummary;
    } else if (me == null) {
      label = "Add me";
      onPressed = bill.addMe;
    } else {
      label = "Preview my expense";
      onPressed = (bill.totals[me.id] ?? 0) == 0
          ? null
          : () => Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => const MyExpensePreview()));
    }

    return Container(
      color: primaryAppColor,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total",
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text(formatPaise(bill.billTotal),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    if (unsettled != 0)
                      Text("${formatPaise(unsettled)} not split yet",
                          style: const TextStyle(
                              color: secondaryAppColor, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryAppColor,
                    foregroundColor: primaryAppColor),
                onPressed: onPressed,
                child: Text(label,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
