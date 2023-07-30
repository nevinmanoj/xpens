import 'package:flutter/material.dart';

const primaryAppColor = Colors.black;
const secondaryAppColor = Color.fromRGBO(255, 143, 0, 1);

var authInputDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  color: Colors.grey[200]?.withOpacity(0.6),
  boxShadow: [
    BoxShadow(
      color: Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
      spreadRadius: 4, //spread radius
      blurRadius: 4, // blur radius
      offset: Offset(6, 4), // changes position of shadow
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
      color: Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
    ),
  ],
);

var buttonDecoration = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    )),
    backgroundColor: MaterialStateProperty.all<Color>(primaryAppColor));

List locationList = ["Personel", "Home"];

List<String> filterList = ["All", "Personel", "Home"];
