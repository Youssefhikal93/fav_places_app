import 'package:fav_places_app/models/place.dart';
import 'package:fav_places_app/models/screens/places_details.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});
  final List<Place> places;

  void onPlaceTap(BuildContext context, Place place) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => PlacesDetailsScreen(place: place)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet, start adding some!',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, index) => ListTile(
        title: Text(places[index].name),
        onTap: () => onPlaceTap(context, places[index]),
      ),
    );
  }
}
