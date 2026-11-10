import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ItemInput/formFields.dart'
    show FieldLabel;
import 'package:xpens/screens/home/listx/listStream/listStream.dart'
    show costOf, formatRupee;
import 'package:xpens/shared/constants.dart';

import '../../../../shared/utils/Excel.dart';
import '../../../../services/providers/UserInfoProvider.dart';
import '../../../../shared/utils/toast.dart';

/// Export a month (or a whole year) of expenses as an Excel sheet.
class DownloadStatementMain extends StatefulWidget {
  const DownloadStatementMain({super.key});

  @override
  State<DownloadStatementMain> createState() => _DownloadStatementMainState();
}

class _DownloadStatementMainState extends State<DownloadStatementMain> {
  String _year = DateTime.now().year.toString();
  String _month = monthList[DateTime.now().month - 1];
  bool _busy = false;

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      backgroundColor: Colors.grey.shade100,
      selectedColor: primaryAppColor,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black87,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) {
        showToast(context: context, msg: "Couldn't create the statement");
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final docs = Provider.of<UserInfoProvider>(context).docs;
    final years = {
      DateTime.now().year.toString(),
      for (final d in docs) d['year'].toString(),
    }.toList()
      ..sort((a, b) => b.compareTo(a));
    final rows = statementRows(list: docs, year: _year, month: _month);
    final total = rows.fold<double>(0, (s, e) => s + costOf(e));
    final label = _month == "All" ? "All of $_year" : "$_month $_year";
    final empty = rows.isEmpty;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
          backgroundColor: primaryAppColor,
          title: const Text("Download statement")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const FieldLabel("Year"),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final y in years)
              _chip(y, _year == y, () => setState(() => _year = y)),
          ]),
          const SizedBox(height: 22),
          const FieldLabel("Month"),
          Wrap(spacing: 8, runSpacing: 8, children: [
            _chip("Whole year", _month == "All",
                () => setState(() => _month = "All")),
            for (final m in monthList)
              _chip(m, _month == m, () => setState(() => _month = m)),
          ]),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.table_chart_outlined,
                      color: Colors.green.shade700),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$_year-$_month.xlsx",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(
                        empty
                            ? "No expenses in $label"
                            : "${rows.length} ${rows.length == 1 ? "expense" : "expenses"} · ${formatRupee(total)}",
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy || empty
                      ? null
                      : () => _run(() async {
                            await jsonToExcel(
                                list: docs, year: _year, month: _month);
                            if (mounted) {
                              showToast(
                                  context: this.context,
                                  msg: "Saved $_year-$_month.xlsx to storage");
                            }
                          }),
                  icon: const Icon(Icons.download_outlined, size: 20),
                  label: const Text("Save"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey.shade300),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _busy || empty
                      ? null
                      : () => _run(() =>
                          shareFile(list: docs, year: _year, month: _month)),
                  icon: const Icon(Icons.share_outlined, size: 20),
                  label: const Text("Share"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryAppColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    elevation: 0,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
