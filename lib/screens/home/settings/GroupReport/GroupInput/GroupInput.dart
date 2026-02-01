import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../services/providers/UserInfoProvider.dart';

class GroupInput extends StatefulWidget {
  final Function(String) setGroup;
  final String group;
  const GroupInput({super.key, required this.setGroup, required this.group});

  @override
  State<GroupInput> createState() => _GroupInputState();
}

class _GroupInputState extends State<GroupInput> {
  TextEditingController ctrl = TextEditingController();
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    ctrl.text = widget.group;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GroupInput oldWidget) {
    if (oldWidget.group != widget.group) {
      ctrl.text = widget.group;
      focusNode.unfocus();
    }
    super.didUpdateWidget(oldWidget);
  }

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
      child: RawAutocomplete<String>(
        textEditingController: ctrl,
        focusNode: focusNode,
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
            decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 167, 167, 167)),
              borderRadius: BorderRadius.circular(10),
              // color: Colors.grey[200]?.withOpacity(0.6),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFCCCCCC)
                      .withOpacity(0.5), //color of shadow
                ),
              ],
            ),
            width: wt * 0.9,
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: TextFormField(
              controller: fieldTextEditingController,
              validator: (value) =>
                  value!.isEmpty ? ' Group Tag Name cannot be empty' : null,
              onFieldSubmitted: (value) {
                widget.setGroup(value);
              },
              decoration: InputDecoration(
                suffixIcon: fieldTextEditingController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        color: Colors.black.withOpacity(0.5),
                        onPressed: () {
                          widget.setGroup("");
                          fieldTextEditingController.clear();
                          FocusManager.instance.primaryFocus!.unfocus();
                        })
                    : null,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                hintText: 'Group tag',
              ),
              focusNode: fieldFocusNode,
            ),
          );
        },
        onSelected: (option) => widget.setGroup(option),
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
                width: wt * 0.9,
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
