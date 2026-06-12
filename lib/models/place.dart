import 'dart:io';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class Place {
  Place({required this.name, required this.image, this.location})
    : id = uuid.v4();
  final String name;
  final String id;
  final File image;
  final PlaceLocation? location;
}

class PlaceLocation {
  PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
  final double latitude;
  final double longitude;
  final String address;
}
