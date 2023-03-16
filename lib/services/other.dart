import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:xpens/shared/constants.dart';

import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

import 'package:share/share.dart';

void showToast({required BuildContext context, required String msg}) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      duration: Duration(seconds: 2, milliseconds: 500),
      backgroundColor: primaryAppColor,
      content: Text(msg),
    ),
  );
}

Future<File> jsonToExcel(
    {required List<Map<String, dynamic>> list,
    required String year,
    required String month}) async {
  Map<String, dynamic> jsonData;
  var excel = Excel.createExcel();
  var sheet = excel[month];

  // Add the header row to the sheet
  sheet.appendRow(['Name', 'Cost', 'Date']);
  for (int i = 0; i < list.length; i++) {
    jsonData = list[i];
    if ((jsonData['year'] == year) && (jsonData['month'] == month))
      sheet.appendRow(
          [jsonData['itemName'], jsonData['cost'], jsonData['date']]);
  }

  final directory = await getExternalStorageDirectory();

  var file = File('${directory!.path}/$year-$month.xlsx');

  if (await file.exists()) {
    await file.open();
    print(directory.path);
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
    Share.shareFiles([filePath], text: "excel file");
  } catch (e) {
    print(e.toString());
  }
}
