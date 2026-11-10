import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

/// Expenses in [year] and [month] ("Jan" … "Dec", or "All" for the whole
/// year), oldest first.
List statementRows(
    {required List list, required String year, required String month}) {
  final rows = list
      .where(
          (e) => e['year'] == year && (month == "All" || e['month'] == month))
      .toList()
    ..sort((a, b) =>
        DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
  return rows;
}

/// Writes the statement to `<app storage>/<year>-<month>.xlsx`, replacing
/// any earlier copy, and returns the file.
Future<File> jsonToExcel(
    {required List list, required String year, required String month}) async {
  final sheetName = month == "All" ? year : "$month $year";
  final excel = Excel.createExcel();
  final sheet = excel[sheetName];
  // Drop the empty default sheet so the file opens on the statement.
  if (sheetName != "Sheet1") excel.delete("Sheet1");

  String text(dynamic v) => (v ?? "").toString();

  sheet.appendRow([
    TextCellValue('Date'),
    TextCellValue('Time'),
    TextCellValue('Name'),
    TextCellValue('Cost'),
    TextCellValue('Location'),
    TextCellValue('Remarks'),
    TextCellValue('Group'),
  ]);
  double total = 0;
  for (final e in statementRows(list: list, year: year, month: month)) {
    final cost = (e['cost'] as num?)?.toDouble() ?? 0;
    total += cost;
    final group = text(e['group']);
    sheet.appendRow([
      TextCellValue(DateFormat("d MMM y").format(DateTime.parse(e['date']))),
      TextCellValue(text(e['time'])),
      TextCellValue(text(e['itemName'])),
      DoubleCellValue(cost),
      TextCellValue(text(e['location'])),
      TextCellValue(text(e['remarks'])),
      TextCellValue(group == "none" ? "" : group),
    ]);
  }
  sheet.appendRow([]);
  sheet.appendRow([
    TextCellValue('Total'),
    null,
    null,
    DoubleCellValue(total),
  ]);

  final directory = await getExternalStorageDirectory();
  final file = File('${directory!.path}/$year-$month.xlsx');
  await file.writeAsBytes(excel.encode()!, flush: true);
  return file;
}

/// Builds a fresh statement and opens the share sheet for it.
Future<void> shareFile({
  required String year,
  required String month,
  required List list,
}) async {
  final file = await jsonToExcel(list: list, year: year, month: month);
  await Share.shareXFiles([XFile(file.path)],
      subject: "xpens statement ${month == "All" ? year : "$month $year"}");
}
