// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Test extends StatefulWidget {
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => MapScreen()));
      },
      child: Text("maps"),
    );
  }
}

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Example'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(51.5074,
              -0.1278), // Replace with the desired center latitude and longitude
          zoom: 13.0,
        ),
        children: [
          Container(
            height: 100,
            width: 100,
            color: Colors.amber,
          )
          //  TileLayerOptions(
          //     urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          //     subdomains: ['a', 'b', 'c'],
          //   ),
        ],
      ),
    );
  }
}
