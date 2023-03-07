import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class AddMarkerScreen extends StatefulWidget {
  @override
  _AddMarkerScreenState createState() => _AddMarkerScreenState();
}

class _AddMarkerScreenState extends State<AddMarkerScreen> {
  LatLng? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Marker"),
      ),
      body: Stack(
        children: <Widget>[
          FlutterMap(
            options: MapOptions(
              center: LatLng(0, 0),
              zoom: 13,
              onTap: _selectLocation,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.jorishaenseler.wifind',
              ),
              MarkerLayer(
                markers: [
                  if (_selectedLocation != null)
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _selectedLocation!,
                      builder: (ctx) => Container(
                        child: Icon(Icons.location_pin),
                      ),
                    ),
                ],
              )
            ],
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: _submitLocation,
              child: const Text("Add Marker"),
            ),
          ),
        ],
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
      Navigator.pop(context, _selectedLocation);
    }
  }
}
