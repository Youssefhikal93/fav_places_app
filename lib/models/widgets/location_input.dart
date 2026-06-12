import 'dart:convert';

import 'package:fav_places_app/models/place.dart';
import 'package:fav_places_app/models/screens/map.dart';
import 'package:fav_places_app/models/widgets/map_preview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var isGettingLocation = false;

  Future<void> _savePlace(double latitude, double longitude) async {
    // coordinates if the request fails.
    var address = '$latitude, $longitude';
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude',
      );
      final response = await http.get(
        url,
        headers: {'User-Agent': 'com.example.fav_places_app'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        address = data['display_name'] as String? ?? address;
      }
    } catch (_) {
      // Keep the coordinate fallback.
    }

    if (!mounted) return;

    final placeLocation = PlaceLocation(
      latitude: latitude,
      longitude: longitude,
      address: address,
    );

    setState(() {
      _pickedLocation = placeLocation;
      isGettingLocation = false;
    });

    widget.onSelectLocation(placeLocation);
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isGettingLocation = true;
    });

    locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      setState(() {
        isGettingLocation = false;
      });
      return;
    }

    await _savePlace(locationData.latitude!, locationData.longitude!);
  }

  void _selectOnMap() async {
    final picked = _pickedLocation;
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(
          initialLocation: picked != null
              ? LatLng(picked.latitude, picked.longitude)
              : const LatLng(58.398536, 15.573098),
        ),
      ),
    );
    if (selectedLocation == null) return;

    setState(() {
      isGettingLocation = true;
    });

    await _savePlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      'No Location Chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium,
    );

    if (isGettingLocation) {
      content = CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      );
    } else if (_pickedLocation != null) {
      content = MapPreview(
        key: ValueKey(_pickedLocation),
        location: _pickedLocation!,
        width: double.infinity,
        height: double.infinity,
        zoom: 16,
        markerSize: 40,
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary.withAlpha(150),
              width: 1,
            ),
          ),
          child: content,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}
