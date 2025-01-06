import 'package:flutter/material.dart';

class MilestonePills extends StatefulWidget {
  final List<String> names;
  final List items;
  final List<bool> selected;
  final Function(String) toggle;

  const MilestonePills(
      {super.key,
      required this.names,
      required this.selected,
      required this.toggle,
      required this.items});

  @override
  State<MilestonePills> createState() => _MilestonePillsState();
}

class _MilestonePillsState extends State<MilestonePills> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < widget.selected.length; i++)

          // for (var name in widget.names)
          InkWell(
            onTap: () => widget.toggle(widget.names[i]),
            child: Container(
              alignment: Alignment.center,
              // height: 25,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                  color: widget.selected[i] ? Colors.green : Colors.amber,
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                widget.names[i],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}
