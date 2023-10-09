import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/settings/DownloadStatement/months.dart';
import 'package:xpens/shared/constants.dart';

import '../../../../services/Excel.dart';
import '../../../../services/providers/UserInfoProvider.dart';
import '../../../../services/toast.dart';
import 'years.dart';

class DownloadStatementMain extends StatefulWidget {
  const DownloadStatementMain({super.key});

  @override
  State<DownloadStatementMain> createState() => _DownloadStatementMainState();
}

class _DownloadStatementMainState extends State<DownloadStatementMain> {
  String selectYear = DateTime.now().year.toString();
  String selectMonth = DateFormat.MMM().format(DateTime.now()).toString();
  final formKey = GlobalKey<FormState>();

  void setSelectYear(String year) {
    setState(() {
      selectYear = year;
    });
  }

  void setselectMonth(String month) {
    setState(() {
      selectMonth = month;
    });
  }

  @override
  Widget build(BuildContext context) {
    var userInfo = Provider.of<UserInfoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
      ),
      body: SingleChildScrollView(
          child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Year(
              setVal: setSelectYear,
              // year: selectYear,
            ),
            Month(setVal: setselectMonth, month: selectMonth),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: buttonDecoration,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await jsonToExcel(
                            list: userInfo.docs,
                            year: selectYear,
                            month: selectMonth);
                        Navigator.pop(context);
                        showToast(
                            context: context,
                            msg:
                                "Excel sheet for $selectMonth $selectYear Saved to storage");
                      }
                    },
                    child: Text('Download details')),
                ElevatedButton(
                    style: buttonDecoration,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        shareFile(
                            list: userInfo.docs,
                            month: selectMonth,
                            year: selectYear);
                      }
                    },
                    child: const Text("Share"))
              ],
            ),
          ],
        ),
      )),
    );
  }
}
