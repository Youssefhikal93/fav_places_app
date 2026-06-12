import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

TileLayer osmTileLayer() {
  return TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'com.example.fav_places_app',
  );
}

Marker locationMarker(LatLng point, {double size = 40}) {
  return Marker(
    point: point,
    width: size,
    height: size,
    child: Icon(Icons.location_pin, size: size, color: Colors.red),
  );
}
