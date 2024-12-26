import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

Future<File> jsonToExcel(
    {required List list, required String year, required String month}) async {
  var jsonData;
  var excel = Excel.createExcel();
  var sheet = excel[month];

  // Add the header row to the sheet

  sheet.appendRow([
    TextCellValue('Name'),
    TextCellValue('Cost'),
    TextCellValue('Date'),
    TextCellValue('Location'),
    TextCellValue('Remarks'),
    TextCellValue('Group')
  ]);
  for (int i = 0; i < list.length; i++) {
    jsonData = list[i];
    if ((jsonData['year'] == year) && (jsonData['month'] == month)) {
      var formattedDate =
          DateFormat.yMd().format(DateTime.parse(jsonData['date'])).toString();
      sheet.appendRow([
        TextCellValue(jsonData['itemName']),
        TextCellValue(jsonData['cost']),
        TextCellValue(formattedDate),
        TextCellValue(jsonData['location']),
        TextCellValue(jsonData['remarks']),
        TextCellValue(jsonData['group'])
      ]);
    }
  }
  Directory? directory;
  var file;
  try {
    directory = await getExternalStorageDirectory();
    file = File('${directory!.path}/$year-$month.xlsx');
  } catch (e) {
    print(e);
  }

  if (await file.exists()) {
    await file.open();
  } else {}
  file.writeAsBytesSync(excel.encode() as List<int>);

  return file;
}

void shareFile({
  required String year,
  required String month,
  required List list,
}) async {
  final directory = await getExternalStorageDirectory();
  var filePath = '${directory!.path}/$year-$month.xlsx';

  var file = File(filePath);
  if (!await file.exists()) {
    await jsonToExcel(list: list, year: year, month: month);
  }
  try {
    Share.shareXFiles([XFile(filePath)], subject: "Excel file");
  } catch (e) {
    print(e.toString());
  }
}
