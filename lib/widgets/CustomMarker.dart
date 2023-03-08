import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

Marker buildPersonMarker(LatLng point) {
  return buildCustomMarker(
      100,
      100,
      point,
      const Icon(
        Icons.person,
        color: Colors.black,
      ));
}

Marker buildWifiMarker(LatLng point, Color wifiColor) {
  return buildCustomMarker(
      80,
      80,
      point,
      Icon(
        Icons.wifi,
        color: wifiColor,
      ));
}

Marker buildCustomMarker(double width, double height, LatLng point, Icon icon) {
  return Marker(
    width: width,
    height: height,
    point: point,
    builder: (ctx) => icon,
  );
}
