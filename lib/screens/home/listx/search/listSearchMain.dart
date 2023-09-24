import 'package:flutter/material.dart';

import '../../../../shared/constants.dart';

class ListSearchMain extends StatefulWidget {
  const ListSearchMain({super.key, required this.onStreamChange, this.filter});
  final filter;
  final Function(dynamic) onStreamChange;

  @override
  State<ListSearchMain> createState() => _ListSearchMainState();
}

class _ListSearchMainState extends State<ListSearchMain> {
  var filter;
  bool showClear = false;
  TextEditingController ctrl = TextEditingController();
  @override
  void initState() {
    filter = widget.filter;
    if (filter['query'] != null) {
      showClear = filter['query'].length != 0;
      ctrl.text = filter['query'];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 40,
              color: primaryAppColor,
            ),
            Container(),
          ],
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            height: 50,
            width: 350,
            decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 167, 167, 167)),
              borderRadius: BorderRadius.circular(10),
              // color: Colors.grey[200]?.withOpacity(0.6),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
              child: TextFormField(
                controller: ctrl,
                // initialValue: showClear ? filter['query'] : "",
                cursorColor: primaryAppColor,
                cursorWidth: 1,
                onChanged: updateFilter,
                onFieldSubmitted: updateFilter,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  suffixIcon: showClear
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          color: Colors.black.withOpacity(0.5),
                          onPressed: () {
                            updateFilter("");
                            ctrl.clear();
                          })
                      : null,
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                  hintText: 'Search Expenses',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void updateFilter(String value) {
    final List<String> tags = value
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word.toLowerCase())
        .toList();

    filter['search'] = tags;
    filter['query'] = value;

    setState(() {
      showClear = filter['query'].length != 0;
    });
    widget.onStreamChange(filter);
  }
}
