// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../services/providers/UserInfoProvider.dart';
import '../../../../../shared/constants.dart';

class GroupAuto extends StatefulWidget {
  const GroupAuto({
    super.key,
    required this.itemGroup,
    required this.onGroupChange,
  });
  final Function(String) onGroupChange;
  final String itemGroup;

  @override
  State<GroupAuto> createState() => _GroupAutoState();
}

class _GroupAutoState extends State<GroupAuto> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    // double ht = MediaQuery.of(context).size.height;
    final listData = Provider.of<UserInfoProvider>(context);
    List list = listData.docs;

    Set<String> uniqueGroupNames =
        {}; // Using a Set to automatically handle duplicates

    for (var item in list) {
      if (item['group'] != "none") {
        uniqueGroupNames.add(item['group']);
      }
    }
    List<String> kOptions = uniqueGroupNames.toList();

    return Container(
      padding: const EdgeInsets.all(20),
      child: Autocomplete<String>(
        initialValue: TextEditingValue(
            text: widget.itemGroup,
            selection: TextSelection.fromPosition(
              TextPosition(offset: widget.itemGroup.length),
            )),
        optionsBuilder: (TextEditingValue textEditingValue) {
          return kOptions
              .where((county) => county
                  .toLowerCase()
                  .startsWith(textEditingValue.text.toLowerCase()))
              .toList();
        },
        displayStringForOption: (option) => option,
        fieldViewBuilder: (BuildContext context,
            TextEditingController fieldTextEditingController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted) {
          return Container(
            decoration: addInputDecoration,
            width: wt * 0.8,
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: TextFormField(
              validator: (value) =>
                  value!.isEmpty ? ' Group Tag Name cannot be empty' : null,
              onChanged: (value) {
                widget.onGroupChange(value);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                hintText: 'Group tag',
              ),
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
            ),
          );
        },
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: Container(
                margin: const EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.withOpacity(0.4)),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                constraints: const BoxConstraints(
                  maxHeight: 200,
                ),
                width: wt * 0.8,
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.grey.withOpacity(0.5),
                    );
                  },
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);

                    return InkWell(
                      onTap: () {
                        onSelected(option);
                        widget.onGroupChange(option);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        height: 40,
                        child: Text(option,
                            style: const TextStyle(color: Colors.black)),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
 // String newText = itemGroup == "none" ? "" : itemGroup;
          // fieldTextEditingController = TextEditingController(text: newText);

          // fieldTextEditingController.selection = TextSelection.fromPosition(
          //     TextPosition(offset: fieldTextEditingController.text.length));
          // fieldTextEditingController.value.copyWith(
          //     text: newText,
          //     selection: TextSelection.fromPosition(
          //       TextPosition(offset: newText.length),
          //     ));