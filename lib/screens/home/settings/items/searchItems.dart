import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class ItemsSearchWidget extends StatefulWidget {
  final String searchKey;
  final Function(String) changeSearchKey;
  const ItemsSearchWidget(
      {super.key, required this.searchKey, required this.changeSearchKey});

  @override
  State<ItemsSearchWidget> createState() => _ItemsSearchWidgetState();
}

class _ItemsSearchWidgetState extends State<ItemsSearchWidget> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(wt * 0.05, ht * 0.02, 0, wt * 0.05),
          height: ht * 0.065,
          width: wt * 0.9,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 167, 167, 167)),
            borderRadius: BorderRadius.circular(10),
            // color: Colors.grey[200]?.withOpacity(0.6),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color:
                    const Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
            child: TextFormField(
              initialValue: widget.searchKey,
              onChanged: (value) {
                widget.changeSearchKey(value);
              },
              // initialValue: showClear ? filter['query'] : "",
              cursorColor: primaryAppColor,
              cursorWidth: 1,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                hintText: 'Search Item Name',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
