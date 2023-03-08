import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:wifind/model/WiFindSpot.dart';
import 'package:wifind/screens/AddWifiScreen.dart';

//used for distance calculation
import 'package:geolocator/geolocator.dart';
import 'package:wifind/service/NotificationWiFind.dart';
import 'package:wifind/widgets/CustomMarker.dart';

class WiFindScreen extends StatefulWidget {
  WiFindScreen({super.key});

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  State<WiFindScreen> createState() => _WiFindScreenState();
}

class _WiFindScreenState extends State<WiFindScreen> {
  final List<WiFindSpot> _wiFindSpots = [];
  final MapController _mapController = MapController();

  final Location _location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionStatus;
  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    _checkLocationPermissions();
    NotificationWiFind.initialize(widget.flutterLocalNotificationsPlugin);
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
    for (WiFindSpot wiFindSpot in _wiFindSpots) {
      double distance = await Geolocator.distanceBetween(
        _locationData!.latitude!,
        _locationData!.longitude!,
        wiFindSpot.getPoint.latitude,
        wiFindSpot.getPoint.longitude,
      );
      if (distance < 50) {
        NotificationWiFind.showBigTextNotification(
            title: "WiFind",
            body: "The Wifi '${wiFindSpot.getWifiName}' is near you!",
            fln: widget.flutterLocalNotificationsPlugin);
      }
    }
  }

  Future<void> _addMarker() async {
    WiFindSpot wiFindSpot = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddWifiScreen(
                locationData: _locationData!,
              )),
    );
    setState(() {
      _wiFindSpots.add(wiFindSpot);
    });
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
          : Stack(children: <Widget>[
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(
                      _locationData!.latitude!, _locationData!.longitude!),
                  zoom: 13,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                      markers: _wiFindSpots
                          .map((wifiSpot) => wifiSpot.getMarker)
                          .toList()),
                  MarkerLayer(
                    markers: [
                      buildPersonMarker(LatLng(_locationData!.latitude!, _locationData!.longitude!)),
                    ],
                  ),
                ],
              ),
              Positioned(
                left: 30,
                bottom: 50,
                child: FloatingActionButton(
                  onPressed: _centerMapOnLocation,
                  child: const Icon(Icons.center_focus_strong_outlined),
                ),
              )
            ]),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _addMarker,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
