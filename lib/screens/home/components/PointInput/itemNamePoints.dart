// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../../services/providers/UserInfoProvider.dart';
// import '../../../../shared/constants.dart';
// import '../ItemInput/inputAutofill.dart';

// class ItemNamePoints extends StatefulWidget {
//   const ItemNamePoints({super.key});

//   @override
//   State<ItemNamePoints> createState() => _ItemNamePointsState();
// }

// class _ItemNamePointsState extends State<ItemNamePoints> {
//   @override
//   Widget build(BuildContext context) {
//     double wt = MediaQuery.of(context).size.width;
//     // double ht = MediaQuery.of(context).size.width;
//     var userInfo = Provider.of<UserInfoProvider>(context);
//     List allItems = userInfo.items;
//     return Column(
//       children: [
//         Container(
//           width: wt * 0.8,
//           decoration: addInputDecoration,
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//             child: DropdownButtonFormField<String>(
//               value: allItems.contains(widget.itemName)
//                   ? widget.itemName
//                   : "Other",
//               validator: (value) =>
//                   value!.isEmpty ? ' Must select a category for item' : null,
//               decoration: InputDecoration(border: InputBorder.none),
//               hint: Text(
//                 "Category of Item",
//                 style: TextStyle(color: Colors.grey.withOpacity(0.8)),
//               ),
//               onChanged: (value) {
//                 widget.onNameChange(value!);
//               },
//               items: allItems.map<DropdownMenuItem<String>>((value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//         SizedBox(height: 10),
//         (widget.itemName == "Other" || !allItems.contains(widget.itemName))
//             ? InputAutoFill(
//                 docs: userInfo.docs,
//                 value: widget.itemName == "Other" ? "" : widget.itemName,
//                 onValueChange: widget.onNameChange,
//                 tag: "itemName",
//               )
            
//             : Container(),
//       ],
//     );
//   }
// }
