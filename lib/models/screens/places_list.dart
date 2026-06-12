import 'dart:io';

import 'package:fav_places_app/models/place.dart';
import 'package:fav_places_app/models/screens/add_place.dart';
import 'package:fav_places_app/models/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import "package:path/path.dart" as path;
import "package:sqflite/sqflite.dart" as sql;
import "package:sqflite/sqlite_api.dart";

class PlacesListScreen extends StatefulWidget {
  const PlacesListScreen({super.key});

  @override
  State<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  List<Place> places = [];

  @override
  void initState() {
    super.initState();
    getPlaces().then((value) => setState(() => places = value));
  }

  void onPress() async {
    final newPlace = await Navigator.of(
      context,
    ).push<Place>(MaterialPageRoute(builder: (ctx) => const AddPlaceScreen()));
    if (newPlace != null) {
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final fileName = path.basename(newPlace.image.path);
      final savedImage = await newPlace.image.copy('${appDir.path}/$fileName');

      final placeToAdd = Place(
        name: newPlace.name,
        image: savedImage,
        location: newPlace.location,
      );

      insertPlace(placeToAdd);

      var loadedPlaces = await getPlaces();
      setState(() {
        // places.addAll(loadedPlaces);
        places = loadedPlaces;
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

  Future<sql.Database> getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, name TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)',
        );
      },
      version: 1,
    );

    return db;
  }

  void insertPlace(Place place) async {
    final db = await getDatabase();
    db.insert('user_places', {
      'id': place.id,
      'name': place.name,
      'image': place.image.path,
      'loc_lat': place.location?.latitude,
      'loc_lng': place.location?.longitude,
      'address': place.location?.address,
    });
  }

  Future<List<Place>> getPlaces() async {
    final db = await getDatabase();
    var loadedPlaces = await db.query('user_places');

    return loadedPlaces
        .map(
          (place) => Place(
            id: place['id'] as String,
            name: place['name'] as String,
            image: File(place['image'] as String),
            location: PlaceLocation(
              latitude: place['loc_lat'] as double,
              longitude: place['loc_lng'] as double,
              address: place['address'] as String,
            ),
          ),
        )
        .toList();
  }
}
