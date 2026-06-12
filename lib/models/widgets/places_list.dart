import 'package:fav_places_app/models/place.dart';
import 'package:fav_places_app/models/screens/places_details.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({
    super.key,
    required this.places,
    required this.onRemovePlace,
  });
  final List<Place> places;
  final void Function(Place place) onRemovePlace;

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
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(places[index].id),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Theme.of(context).colorScheme.error,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.onError,
          ),
        ),
        onDismissed: (direction) => onRemovePlace(places[index]),
        child: ListTile(
          title: Text(places[index].name),
          subtitle: places[index].location == null
              ? null
              : Text(places[index].location!.address),
          leading: CircleAvatar(
            radius: 22,
            backgroundImage: FileImage(places[index].image),
          ),
          onTap: () => onPlaceTap(context, places[index]),
        ),
      ),
    );
  }
}
