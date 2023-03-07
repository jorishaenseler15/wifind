import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:wifind/AddMarkerScreen.dart';

//used for distance calculation
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<Marker> _markers = [];
  final MapController _mapController = MapController();

  final Location _location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionStatus;
  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    _checkLocationPermissions();
  }

  Future<void> _checkLocationPermissions() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionStatus = await _location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await _location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _locationData = currentLocation;
      });
      _checkForMarkers();
    });
  }

  Future<void> _checkForMarkers() async {
    for (Marker marker in _markers) {
      double distance = await Geolocator.distanceBetween(
        _locationData!.latitude!,
        _locationData!.longitude!,
        marker.point.latitude,
        marker.point.longitude,
      );
      print(distance);
      if (distance < 50) {
        _showMarkerAlert(marker);
      }
    }
  }

  Future<void> _showMarkerAlert(Marker marker) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("You're near a marker!"),
        content: Text("You're within 50m of a marker at ${marker.point}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _addMarker() async {
    LatLng selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMarkerScreen()),
    );
    if (selectedLocation != null) {
      setState(() {
        _markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: selectedLocation,
            builder: (ctx) => const Icon(Icons.location_pin),
          ),
        );
      });
    }
  }

  void _centerMapOnLocation() {
    if (_locationData != null) {
      _mapController.move(
        LatLng(_locationData!.latitude!, _locationData!.longitude!),
        _mapController.zoom,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _locationData == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center:
                    LatLng(_locationData!.latitude!, _locationData!.longitude!),
                zoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(markers: _markers),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(
                          _locationData!.latitude!, _locationData!.longitude!),
                      builder: (ctx) => const Icon(Icons.person),
                    ),
                  ],
                ),
              ],
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _centerMapOnLocation,
            child: const Icon(Icons.center_focus_strong_outlined),
          ),
          const SizedBox(
            height: 16,
          ),
          FloatingActionButton(
            onPressed: _addMarker,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
