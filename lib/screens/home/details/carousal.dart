// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:googleapis/cloudsearch/v1.dart';
// import 'package:intl/intl.dart';
// import 'package:skeletons/skeletons.dart';

// class Caroursal extends StatefulWidget {
//   final Query<Map<String, dynamic>> stream;
//   Caroursal({required this.stream});

//   @override
//   State<Caroursal> createState() => _CaroursalState();
// }

// class _CaroursalState extends State<Caroursal> {
//   @override
//   Widget build(BuildContext context) {
//     double wt = MediaQuery.of(context).size.width;
//     double ht = MediaQuery.of(context).size.height;
//     int c = 3;
//     List<Widget> items = [
//       Testmonth(
//         stream: widget.stream,
//         mY: DateTime(DateTime.now().year, DateTime.now().month - 2),
//       ),
//       Testmonth(
//         stream: widget.stream,
//         mY: DateTime(DateTime.now().year, DateTime.now().month - 1),
//       ),
//       Testmonth(
//         stream: widget.stream,
//         mY: DateTime(DateTime.now().year, DateTime.now().month),
//       ),
//       Testmonth(
//         stream: widget.stream,
//         mY: DateTime(DateTime.now().year, DateTime.now().month + 1),
//       ),
//     ];
//     final _pageController = PageController(initialPage: 2);
//     return Container(
//         height: 200, //remove this height and make it dynamic
//         child: PageView(
//           onPageChanged: (i) {
//             if (i == 1) {
//               items.insert(
//                 0,
//                 Testmonth(
//                   stream: widget.stream,
//                   mY: DateTime(DateTime.now().year, DateTime.now().month - c),
//                 ),
//               );
//               _pageController.animateToPage(1,
//                   duration: Duration(seconds: 1), curve: Curves.bounceIn);
//               c++;
//               // add prev month
//             } else if (i == items.length - 1) {
//               //add next month
//               items.insert(
//                 i + 1,
//                 Testmonth(
//                   stream: widget.stream,
//                   mY: DateTime(DateTime.now().year, DateTime.now().month + i),
//                 ),
//               );
//             }
//           },
//           controller: _pageController,
//           // shrinkWrap: true,
//           scrollDirection: Axis.horizontal,
//           children: items,
//           // itemCount: 3,
//           // itemBuilder: (context, i) {
//           //   return Testmonth(stream: widget.stream);
//           // }),
//         ));
//   }
// }

// class Testmonth extends StatefulWidget {
//   final Query<Map<String, dynamic>> stream;

//   DateTime mY;

//   Testmonth({super.key, required this.stream, required this.mY});

//   @override
//   State<Testmonth> createState() => _TestmonthState();
// }

// class _TestmonthState extends State<Testmonth> {
//   @override
//   Widget build(BuildContext context) {
//     // FirebaseAuth auth = FirebaseAuth.instance;
//     // User? user = auth.currentUser;
//     // double ht = MediaQuery.of(context).size.height;
//     double wt = MediaQuery.of(context).size.width;

//     String heading =
//         (widget.mY == DateTime(DateTime.now().year, DateTime.now().month))
//             ? "This Month"
//             : "${DateFormat.MMM().format(widget.mY)} ${widget.mY.year}";
//     return StreamBuilder<QuerySnapshot>(
//         stream: widget.stream
//             .where('month',
//                 isEqualTo: DateFormat.MMM().format(widget.mY).toString())
//             .where('year', isEqualTo: widget.mY.year.toString())
//             .snapshots(),
//         builder: (context, listSnapshot) {
//           var list = listSnapshot.data?.docs;

//           if (listSnapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               // child: CircularProgressIndicator(),
//               child: Skeleton(
//                 isLoading: true,
//                 skeleton: SkeletonItem(
//                   child: Container(
//                       margin: EdgeInsets.fromLTRB(wt * 0.05, 10, wt * 0.05, 0),
//                       width: wt * 0.9,
//                       height: 100,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.5),
//                         border: Border.all(
//                           color: Colors.grey.withOpacity(0.3),
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       )),
//                 ),
//                 child: Container(),
//               ),
//             );
//           }
//           if (list == null) {
//             return Container();
//           }

//           List<Map<String, dynamic>> data = list
//               .map((document) => document.data() as Map<String, dynamic>)
//               .toList();
//           double sum = 0;
//           Map<String, double> ranks = {};
//           for (var item in data) {
//             sum += item['cost'];
//             if (ranks[item['itemName']] == null) {
//               ranks[item['itemName']] = 0;
//             }
//             ranks[item['itemName']] = (ranks[item['itemName']]! + item['cost']);
//           }
//           List<MapEntry<String, double>> sortedList = ranks.entries.toList()
//             ..sort((a, b) => b.value.compareTo(a.value));

//           return GestureDetector(
//             // onHorizontalDragEnd: (details) {
//             //   if (details.primaryVelocity! > 0) {
//             //     setState(() {
//             //       widget.mY = DateTime(
//             //           widget.mY.year, widget.mY.month - 1, widget.mY.day);
//             //     });
//             //   } else if (details.primaryVelocity! < 0) {
//             //     setState(() {
//             //       widget.mY = DateTime(
//             //           widget.mY.year, widget.mY.month + 1, widget.mY.day);
//             //     });
//             //   }
//             // },
//             child: Container(
//               margin: EdgeInsets.fromLTRB(wt * 0.05, 10, wt * 0.05, 0),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Colors.grey.withOpacity(0.3),
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               // height: 200,
//               width: 0.9 * wt,
//               child: Padding(
//                 padding: EdgeInsets.all(10.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           heading,
//                           style: TextStyle(
//                               fontSize: 22, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           "TOTAL:  ${sum.toInt().toString()} ₹ ",
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     for (int i = 0;
//                         i < sortedList.length;
//                         // i < ((sortedList.length < 3) ? sortedList.length : 3);
//                         i++)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 5),
//                         child: Text(
//                           "${sortedList[i].key}:   ${sortedList[i].value.toInt()} ₹",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
