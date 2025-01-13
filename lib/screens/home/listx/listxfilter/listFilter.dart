import 'package:flutter/material.dart';
import 'package:xpens/screens/home/listx/listxfilter/filterButtons.dart';
import 'package:xpens/screens/home/listx/listxfilter/locationFilter.dart';
import 'package:xpens/screens/home/listx/listxfilter/orderBy.dart';
import 'package:xpens/shared/constants.dart';

class FilterWindow extends StatefulWidget {
  final Function(dynamic) onFilterChange;
  const FilterWindow({super.key, required this.onFilterChange});
  @override
  State<FilterWindow> createState() => _FilterWindowState();
}

class _FilterWindowState extends State<FilterWindow> {
  Color backdropColor = const Color(0x66C4C4C4);
  double _height = 0;
  String? location;
  String order = "new";
  void clearFilter() {
    setState(() {
      location = null;
      order = "new";
    });
    widget.onFilterChange({'order': 'new'});
  }

  void locchange(newLoc) {
    setState(() {
      location = newLoc;
    });
  }

  void orderchange(newOrder) {
    setState(() {
      order = newOrder;
    });
  }

  void toggleFilter() {
    if (_height == 500) {
      //hide filter
      setState(() {
        backdropColor = Colors.white;
        _height = 0;
      });
    } else {
      //show filter
      setState(() {
        backdropColor = const Color(0x66C4C4C4);
        _height = 500;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;

    return SizedBox(
      height: ht,
      child: Stack(
        children: [
          Positioned(
            bottom: 10,
            right: 10,
            child: InkWell(
              onTap: toggleFilter,
              child: Container(
                height: 56,
                width: 56,
                decoration: const BoxDecoration(
                    color: primaryAppColor, shape: BoxShape.circle),
                child: const Icon(
                  Icons.sort,
                  color: secondaryAppColor,
                ),
              ),
            ),
          ),
          _height == 500
              ? InkWell(
                  onTap: toggleFilter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.fastOutSlowIn,
                    color: backdropColor,
                  ),
                )
              : Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              // padding: EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)),
              ),
              height: _height,
              width: wt,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.fastOutSlowIn,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ListView(children: [
                      LocRadioAccordion(
                        onLocChange: locchange,
                        selectedOption: location,
                      ),
                      OrderByRadioAccordion(
                        selectedOption: order,
                        onOrderChange: orderchange,
                      ),
                      FilterBtns(
                          clearFilter: clearFilter,
                          toggleFilter: toggleFilter,
                          onFilterChange: widget.onFilterChange,
                          location: location,
                          order: order),
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, ht * 0.02, wt * 0.08, 0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: toggleFilter,
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
