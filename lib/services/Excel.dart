import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

Future<File> jsonToExcel(
    {required List<Map<String, dynamic>> list,
    required String year,
    required String month}) async {
  Map<String, dynamic> jsonData;
  var excel = Excel.createExcel();
  var sheet = excel[month];

  // Add the header row to the sheet
  sheet.appendRow(['Name', 'Cost', 'Date', 'Remarks']);
  for (int i = 0; i < list.length; i++) {
    jsonData = list[i];
    if ((jsonData['year'] == year) && (jsonData['month'] == month)) {
      var formattedDate =
          DateFormat.yMd().format(DateTime.parse(jsonData['date'])).toString();
      sheet.appendRow([
        jsonData['itemName'],
        jsonData['cost'],
        formattedDate,
        jsonData['remarks']
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
    print(directory!.path);
  } else {
    print('file created');
  }
  file.writeAsBytesSync(excel.encode() as List<int>);

  return file;
}

void shareFile({
  required String year,
  required String month,
  required List<Map<String, dynamic>> list,
}) async {
  final directory = await getExternalStorageDirectory();
  var filePath = '${directory!.path}/$year-$month.xlsx';

  var file = File(filePath);
  if (!await file.exists()) {
    print("creating file");
    await jsonToExcel(list: list, year: year, month: month);
  }
  try {
    Share.shareXFiles([XFile(filePath)], subject: "Excel file");
  } catch (e) {
    print(e.toString());
  }
}
