import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:xpens/shared/constants.dart';

class ToggleButtonWidget extends StatefulWidget {
  final Function() onShowBarChanged;
  bool showBar;

  ToggleButtonWidget(
      {super.key, required this.onShowBarChanged, required this.showBar});
  @override
  _ToggleButtonWidgetState createState() => _ToggleButtonWidgetState();
}

class _ToggleButtonWidgetState extends State<ToggleButtonWidget> {
  late List<bool> _selectedWeather = [widget.showBar, !widget.showBar];

  void _toggleSelection(int index) {
    setState(() {
      for (int i = 0; i < _selectedWeather.length; i++) {
        _selectedWeather[i] = i == index;
      }
    });
    widget.onShowBarChanged();
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: _toggleSelection,
      isSelected: _selectedWeather,
      selectedColor: secondaryAppColor,
      highlightColor: secondaryAppColor.withOpacity(0.2),
      fillColor: Colors.black,
      borderRadius: BorderRadius.circular(10),
      children: <Widget>[
        Icon(Icons.calendar_month),
        Icon(Icons.bar_chart),
      ],
    );
  }
}
