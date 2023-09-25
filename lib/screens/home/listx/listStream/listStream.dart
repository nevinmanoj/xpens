// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';

import '../search/listSearchMain.dart';
import 'ListItem.dart';
import 'filterFunction.dart';

// class StreamBodyState extends StatefulWidget {
//   final curstream;
//   final Function(dynamic) onStreamChange;
//   StreamBodyState({required this.curstream, required this.onStreamChange});

//   @override
//   State<StreamBodyState> createState() => _StreamBodyStateState();
// }

// class _StreamBodyStateState extends State<StreamBodyState> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print("rebuulding listxxxxxxxx");

//     double wt = MediaQuery.of(context).size.width;
//     return StreamBuilder<QuerySnapshot>(
//         stream: widget.curstream.snapshots(),
//         builder: (context, listSnapshot) {
//           var list = listSnapshot.data?.docs;

//           if (listSnapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (list == null) {
//             return Center(
//               child: Text("list is empty"),
//             );
//           }

//           List<Map<String, dynamic>> data = list
//               .map((document) => document.data() as Map<String, dynamic>)
//               .toList();
//           String curDate = "";
//           return ListView.builder(
//             itemCount: data.length + 2,
//             itemBuilder: (context, i) {
//               if (i == 0)
//                 return ListSearchMain(
//                   onStreamChange: widget.onStreamChange,
//                 );
//               if (i - 1 < data.length) {
//                 bool dispDate = false;
//                 String iDate = DateFormat.yMMMd()
//                     .format(DateTime.parse(data[i - 1]['date']))
//                     .toString();
//                 if (iDate != curDate) {
//                   curDate = iDate;
//                   dispDate = true;
//                 }

//                 return item(list[i - 1].id, data[i - 1], context, dispDate);
//               } else
//                 return Container();
//               // return Container(
//               //     padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//               //     width: wt,
//               //     // alignment: Alignment.center,
//               //     child: TextButton(
//               //       style: ButtonStyle(
//               //         overlayColor: MaterialStateProperty.all<Color>(
//               //             Color.fromRGBO(255, 145, 0, 0.212)),
//               //         foregroundColor: MaterialStateProperty.all<Color>(
//               //             const Color.fromARGB(255, 58, 58, 58)),
//               //       ),
//               //       onPressed: () {
//               //         setState(() {
//               //           // count += 10;
//               //           // _oldScrollPosition = _scrollController.offset;
//               //         });
//               //       },
//               //       child: Container(
//               //         alignment: Alignment.center,
//               //         width: wt,
//               //         child: Text(
//               //           "Show All",
//               //           style: TextStyle(fontWeight: FontWeight.bold),
//               //         ),
//               //       ),
//               //     ));
//             },
//           );
//         });
//   }
// }
class StreamBodyState extends StatefulWidget {
  final filter;
  final Function(dynamic) onFilterChange;
  StreamBodyState({required this.filter, required this.onFilterChange});

  @override
  State<StreamBodyState> createState() => _StreamBodyStateState();
}

class _StreamBodyStateState extends State<StreamBodyState> {
  @override
  Widget build(BuildContext context) {
    final listData = Provider.of<UserInfoProvider>(context);
    List list = listData.docs;

    list = applyFilter(data: list, filter: widget.filter);
    String curDate = "";
    return ListView.builder(
      itemCount: list.length + 2,
      itemBuilder: (context, i) {
        if (i == 0)
          return ListSearchMain(
            filter: widget.filter,
            onStreamChange: widget.onFilterChange,
          );
        if (i - 1 < list.length) {
          bool dispDate = false;
          String iDate = DateFormat.yMMMd()
              .format(DateTime.parse(list[i - 1]['date']))
              .toString();
          if (iDate != curDate) {
            curDate = iDate;
            dispDate = true;
          }

          return item(list[i - 1].id, list[i - 1], context, dispDate);
        } else
          return Container();
        // return Container(
        //     padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        //     width: wt,
        //     // alignment: Alignment.center,
        //     child: TextButton(
        //       style: ButtonStyle(
        //         overlayColor: MaterialStateProperty.all<Color>(
        //             Color.fromRGBO(255, 145, 0, 0.212)),
        //         foregroundColor: MaterialStateProperty.all<Color>(
        //             const Color.fromARGB(255, 58, 58, 58)),
        //       ),
        //       onPressed: () {
        //         setState(() {
        //           // count += 10;
        //           // _oldScrollPosition = _scrollController.offset;
        //         });
        //       },
        //       child: Container(
        //         alignment: Alignment.center,
        //         width: wt,
        //         child: Text(
        //           "Show All",
        //           style: TextStyle(fontWeight: FontWeight.bold),
        //         ),
        //       ),
        //     ));
      },
    );
  }
}
