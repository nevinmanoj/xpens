// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:xpens/shared/utils/filterFunction.dart';
import '../../../../shared/constants.dart';

class InputAutoFill extends StatefulWidget {
  const InputAutoFill(
      {super.key,
      required this.value,
      required this.docs,
      required this.onValueChange,
      required this.tag,
      required this.isNullable,
      this.avoidValue});
  final Function(String) onValueChange;
  final String value;
  final String tag;
  final List docs;
  final String? avoidValue;
  final bool isNullable;

  @override
  State<InputAutoFill> createState() => _InputAutoFillState();
}

class _InputAutoFillState extends State<InputAutoFill> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;

    List list = widget.docs;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Autocomplete<String>(
        initialValue: TextEditingValue(
            text: widget.value,
            selection: TextSelection.fromPosition(
              TextPosition(offset: widget.value.length),
            )),
        optionsBuilder: (TextEditingValue textEditingValue) {
          var filter = {};
          var value = textEditingValue.text.toLowerCase();
          if (value == "") {
            return const Iterable<String>.empty();
          }

          filter['query'] = value;
          filter['queryType'] = widget.tag;
          Set<String> uniqueNames = {};
          var newList = applyFilter(data: list, filter: filter).toList();
          for (var item in newList) {
            if (item[widget.tag] != widget.avoidValue) {
              uniqueNames.add(item[widget.tag]);
            }
          }
          List<String> kOptions = uniqueNames.toList();

          return kOptions;
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
              validator: widget.isNullable
                  ? null
                  : (value) =>
                      value!.isEmpty ? ' ${widget.tag} cannot be empty' : null,
              onChanged: (value) {
                widget.onValueChange(value);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                hintText: widget.tag,
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
                        widget.onValueChange(option);
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
