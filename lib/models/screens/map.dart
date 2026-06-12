import 'package:fav_places_app/models/widgets/map_layers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.initialLocation = const LatLng(37.422, -122.084),
    this.isSelecting = true,
  });

  final LatLng initialLocation;
  final bool isSelecting;

  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Pick your Location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
            ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: widget.initialLocation,
          initialZoom: 16,
          onTap: !widget.isSelecting
              ? null
              : (tapPosition, latLng) {
                  setState(() {
                    _pickedLocation = latLng;
                  });
                },
        ),
        children: [
          osmTileLayer(),
          if (_pickedLocation != null || !widget.isSelecting)
            MarkerLayer(
              markers: [
                locationMarker(_pickedLocation ?? widget.initialLocation),
              ],
            ),
        ],
      ),
    );
  }
}
