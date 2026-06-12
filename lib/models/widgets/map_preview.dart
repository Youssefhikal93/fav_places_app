import 'package:fav_places_app/models/place.dart';
import 'package:fav_places_app/models/widgets/map_layers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPreview extends StatelessWidget {
  const MapPreview({
    super.key,
    required this.location,
    this.width = 100,
    this.height = 56,
    this.zoom = 14,
    this.markerSize = 20,
    this.circular = false,
  });

  final PlaceLocation location;
  final double width;
  final double height;
  final double zoom;
  final double markerSize;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    final latLng = LatLng(location.latitude, location.longitude);

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: circular
            ? BorderRadius.circular(width / 2)
            : BorderRadius.circular(8),
        child: IgnorePointer(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: latLng,
              initialZoom: zoom,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.none,
              ),
            ),
            children: [
              osmTileLayer(),
              MarkerLayer(
                markers: [locationMarker(latLng, size: markerSize)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
