import 'package:flutter/material.dart';

const primaryAppColor = Colors.black;
// const primaryAppColor = Color.fromARGB(255, 187, 255, 0);
const secondaryAppColor = Color.fromRGBO(255, 143, 0, 1);

var authInputDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  color: Colors.grey[200]?.withOpacity(0.6),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
      spreadRadius: 4, //spread radius
      blurRadius: 4, // blur radius
      offset: const Offset(6, 4), // changes position of shadow
      //first paramerter of offset is left-right
      //second parameter is top to down
    ),
    //you can set more BoxShadow() here
  ],
);

var addInputDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  color: Colors.grey[200]?.withOpacity(0.6),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
    ),
  ],
);

var buttonDecoration = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    )),
    backgroundColor: MaterialStateProperty.all<Color>(primaryAppColor));
var secBtnDecoration = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    )),
    backgroundColor: MaterialStateProperty.all<Color>(Colors.white));

// List locationList = ["Personel", "Home", "Investments"];
// List<String> filterList = ["All", "Personel", "Home", "Investments"];
List locationList = [
  "Personel",
  "Home",
];

List inputTypes = ["Expense", "Points"];
List<String> filterList = [
  "All",
  "Personel",
  "Home",
];

const monthList = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

const weekList = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"];
