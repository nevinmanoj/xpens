// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:xpens/services/toast.dart';
import 'package:xpens/shared/constants.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class Test extends StatefulWidget {
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Column(
      children: [
        ElevatedButton(
            onPressed: () async {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MapTest()));
            },
            child: Text("map")),
      ],
    );
  }
}

class MapTest extends StatefulWidget {
  const MapTest({super.key});

  @override
  State<MapTest> createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  String _locationMessage = "";
  double counter = 0;
  LocationMarkerPosition _currentPosition = LocationMarkerPosition(
    latitude: 9.99848078099773,
    longitude: 76.29091698753297,
    accuracy: 0,
  );
  LocationMarkerHeading _currentHeading = LocationMarkerHeading(
    heading: 0,
    accuracy: pi * 0.2,
  );
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationMessage = 'Location services are disabled.';
        });
        return;
      }

      // Check if the app has permission to access location
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationMessage = 'Location permissions are denied.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationMessage =
              'Location permissions are permanently denied, cannot request permissions.';
        });
        return;
      }

      // Get the current location
      // Position position = await Geolocator.getCurrentPosition(
      //   desiredAccuracy: LocationAccuracy.high,
      // );

      // setState(() {
      //   _locationMessage =
      //       'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
      // });

      Geolocator.getServiceStatusStream().listen((event) {
        print(event);
      });
      Geolocator.getPositionStream(
              locationSettings:
                  LocationSettings(accuracy: LocationAccuracy.medium))
          .listen((pos) {
        setState(() {
          counter++;
          _locationMessage =
              'Latitude: ${pos.latitude}, Longitude: ${pos.longitude},${pos.heading}';
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: primaryAppColor,
            onPressed: () async {
              Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high);
              print(position.latitude);
            },
            child: Icon(
              Icons.location_on,
              size: 25,
              color: secondaryAppColor,
            )),
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.moving_outlined),
              onPressed: () async {
                for (int i = 0; i < 10; i++) {
                  await Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      _currentPosition = LocationMarkerPosition(
                        latitude: _currentPosition.latitude - 0.001,
                        longitude: _currentPosition.longitude - 0.001,
                        accuracy: 0,
                      );
                    });
                  });
                }
              },
            ),
          ],
          backgroundColor: primaryAppColor,
        ),
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(10.000081581192912, 76.29059452482811),
            zoom: 15,
          ),
          nonRotatedChildren: [],
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            AnimatedLocationMarkerLayer(
              position: LocationMarkerPosition(
                latitude: _currentPosition.latitude - 0.001,
                longitude: _currentPosition.longitude - 0.001,
                accuracy: 0,
              ),
              heading: _currentHeading,
              style: LocationMarkerStyle(
                // marker: Icon(
                //   Icons.navigation,
                //   color: Colors.green,
                // ),
                marker: DefaultLocationMarker(
                  color: Colors.blue,
                  child: Container(),
                ),
                // markerSize: const Size(20, 20),
                markerDirection: MarkerDirection.heading,
              ),
            ),
            AnimatedLocationMarkerLayer(
              position: _currentPosition,
              heading: _currentHeading,
              style: LocationMarkerStyle(
                // marker: Icon(
                //   Icons.navigation,
                //   color: Colors.green,
                // ),
                marker: DefaultLocationMarker(
                  color: Colors.black,
                  child: Container(),
                ),
                // markerSize: const Size(20, 20),
                markerDirection: MarkerDirection.heading,
              ),
            ),
            CurrentLocationLayer(
              followOnLocationUpdate: FollowOnLocationUpdate.always,
              turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
              style: LocationMarkerStyle(
                marker: const DefaultLocationMarker(
                  child: Icon(
                    Icons.navigation,
                    color: Colors.white,
                  ),
                ),
                // markerSize: const Size(20, 20),
                markerDirection: MarkerDirection.heading,
              ),
            )
          ],
        ));
  }
}
