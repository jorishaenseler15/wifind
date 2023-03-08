import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WiFindSpot {
  late String _wifiName;
  late Marker _marker;

  WiFindSpot(String name, Marker marker): _wifiName = name, _marker = marker;

  Marker get getMarker => _marker;
  LatLng get getPoint => _marker.point;
  String get getWifiName => _wifiName;

  void setMarker(Marker marker) {
    _marker = marker;
  }

  void setWifiName(String name) {
    _wifiName = name;
  }
}