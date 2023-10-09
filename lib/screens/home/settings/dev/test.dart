// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/providers/UserInfoProvider.dart';
import '../../../../shared/constants.dart';

class Test extends StatefulWidget {
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;

    return Column(
      children: [
        // AutocompleteBasicExample() ,
        // GroupName()
      ],
    );
  }
}

// class AutocompleteBasicExample extends StatelessWidget {
//   AutocompleteBasicExample({super.key});
//   TextEditingController textEditingController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     double wt = MediaQuery.of(context).size.width;
//     double ht = MediaQuery.of(context).size.height;
//     final listData = Provider.of<UserInfoProvider>(context);

//     List list = listData.docs;

//     Set<String> uniqueGroupNames =
//         {}; // Using a Set to automatically handle duplicates

//     for (var item in list) {
//       if (item['group'] != "none") {
//         uniqueGroupNames.add(item['group']);
//       }
//     }
//     print(uniqueGroupNames);
//     List<String> kOptions = uniqueGroupNames.toList();
//     return Container(
//         // height: ht * 0.08,
//         width: wt * 0.8,
//         decoration: addInputDecoration,
//         child: Padding(
//           // padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//           padding: EdgeInsets.all(0),
//           child: InputDecorator(
//             decoration: InputDecoration(
//               hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
//               hintText: 'Group Tag Name',
//               enabledBorder: UnderlineInputBorder(
//                   borderSide: BorderSide(color: Colors.transparent)),
//               // border: InputBorder.none,
//               suffixIcon: Icon(Icons.menu),
//             ),
//             child: Autocomplete<String>(
//               fieldViewBuilder:
//                   (context, controller, focusNode, onEditingComplete) {
//                 // this.textEditingController = controller;
//                 return TextFormField(
//                   controller: controller,
//                   cursorColor: primaryAppColor,
//                   cursorWidth: 1,
//                   focusNode: focusNode,
//                   onEditingComplete: onEditingComplete,
//                   onChanged: (value) {
//                     // widget.onNameChange(value);
//                   },
//                   validator: (value) =>
//                       value!.isEmpty ? ' Name cannot be empty' : null,
//                   keyboardType: TextInputType.name,
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
//                     hintText: 'Item Name',
//                   ),
//                 );
//               },
//               optionsViewBuilder: (BuildContext context,
//                   AutocompleteOnSelected<String> onSelected,
//                   Iterable<String> options) {
//                 return Align(
//                   alignment: Alignment.topCenter,
//                   child: Material(
//                     // elevation: 4.0,
//                     child: SizedBox(
//                       // height: 200.0,
//                       child: ListView(
//                         shrinkWrap: true,
//                         children: options
//                             .map((String option) => InkWell(
//                                   onTap: () {
//                                     onSelected(option);
//                                     textEditingController.text =
//                                         option; // Set the selected value to the text input
//                                   },
//                                   child: Container(
//                                     color: Colors.amber,
//                                     child: Text(option),
//                                   ),
//                                 ))
//                             .toList(),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//               optionsBuilder: (TextEditingValue textEditingValue) {
//                 if (textEditingValue.text == '') {
//                   return const Iterable<String>.empty();
//                 }
//                 return kOptions.where((String option) {
//                   return option.contains(textEditingValue.text.toLowerCase());
//                 });
//               },
//               onSelected: (String selection) {},
//             ),
//           ),
//         ));
//   }
// }


