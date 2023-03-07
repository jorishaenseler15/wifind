import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class AddWifiScreen extends StatefulWidget {
  @override
  _AddWifiScreenState createState() => _AddWifiScreenState();
}

class _AddWifiScreenState extends State<AddWifiScreen> {
  LatLng? _selectedLocation;

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
            SizedBox(
              height: 400,
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(0, 0),
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
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: _selectedLocation!,
                          builder: (ctx) => const Icon(
                            Icons.wifi,
                            color: Colors.red,
                          ),
                        ),
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
      Navigator.pop(context, _selectedLocation);
    }
  }
}
