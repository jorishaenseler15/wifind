import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:wifind/model/WiFindSpot.dart';
import 'package:wifind/widgets/CustomMarker.dart';

class AddWifiScreen extends StatefulWidget {
  AddWifiScreen({required LocationData locationData})
      : _locationData = locationData;

  LocationData _locationData;

  @override
  _AddWifiScreenState createState() => _AddWifiScreenState();
}

class _AddWifiScreenState extends State<AddWifiScreen> {
  LatLng? _selectedLocation;
  String wifiName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add WiFi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.wifi,
              size: 100,
              color: Colors.blue,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Wifi Name',
                hintText: 'Enter a name',
              ),
              onChanged: (value) {
                setState(() {
                  wifiName = value;
                });
              },
            ),
            SizedBox(
              height: 400,
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(widget._locationData.latitude!,
                      widget._locationData.longitude!),
                  zoom: 13,
                  onTap: _selectLocation,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.jorishaenseler.wifind',
                  ),
                  MarkerLayer(
                    markers: [
                      if (_selectedLocation != null)
                        buildWifiMarker(_selectedLocation!, Colors.red)
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _submitLocation,
              child: const Text("Add Marker"),
            ),
          ],
        ),
      ),
    );
  }

  void _selectLocation(_, LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _submitLocation() {
    if (_selectedLocation != null) {
      print(wifiName);
      WiFindSpot newLocationWiFindSpot = WiFindSpot(
        wifiName,
        buildWifiMarker(_selectedLocation!, Colors.primaries[Random().nextInt(Colors.primaries.length)])
      );
      Navigator.pop(context, newLocationWiFindSpot);
    }
  }
}
