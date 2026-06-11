import 'package:fav_places_app/models/place.dart';
import 'package:fav_places_app/models/screens/add_place.dart';
import 'package:fav_places_app/models/widgets/places_list.dart';
import 'package:flutter/material.dart';

class PlacesListScreen extends StatefulWidget {
  const PlacesListScreen({super.key});

  @override
  State<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  final List<Place> places = [];
  void onPress() async {
    final newPlace = await Navigator.of(
      context,
    ).push<Place>(MaterialPageRoute(builder: (ctx) => const AddPlaceScreen()));
    if (newPlace != null) {
      setState(() {
        places.add(newPlace);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [IconButton(onPressed: onPress, icon: const Icon(Icons.add))],
      ),
      body: PlacesList(places: places),
    );
  }
}
