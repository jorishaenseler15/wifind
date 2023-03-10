
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:wifind/model/WiFindSpot.dart';
import 'package:wifind/service/ColorGenerator.dart';
import 'package:wifind/widgets/CustomMarker.dart';

import 'package:wifind/widgets/GrayedOut.dart';

class AddWifiScreen extends StatefulWidget {
  const AddWifiScreen({super.key, required LocationData locationData})
      : _locationData = locationData;

  final LocationData _locationData;

  @override
  AddWifiScreenState createState() => AddWifiScreenState();
}

class AddWifiScreenState extends State<AddWifiScreen> {
  LatLng? _selectedLocation;
  String _wifiName = '';

  final _controller = TextEditingController();

  String? get _errorText {
    final text = _controller.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    return null;
  }

  bool get _filledOut => _errorText != null || _selectedLocation == null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add WiFi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            const Icon(
              Icons.wifi,
              size: 100,
              color: Colors.blue,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Wifi Name',
                hintText: 'Enter a name',
                errorText: _errorText,
              ),
              controller: _controller,
              onChanged: (text) => setState(() => _wifiName = text),
            ),
            const SizedBox(height: 40),
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
              height: 40,
            ),
            GrayedOut(
              grayedOut: _filledOut,
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
                  onPressed: _submitWiFindSpot,
                  child: const Text("Add Marker"),
                ),
              ),
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

  void _submitWiFindSpot() {
    if (_selectedLocation != null) {
      WiFindSpot newLocationWiFindSpot = WiFindSpot(
          _wifiName,
          buildWifiMarker(_selectedLocation!,
              ColorGenerator.getColor()));
      Navigator.pop(context, newLocationWiFindSpot);
    }
  }
}
