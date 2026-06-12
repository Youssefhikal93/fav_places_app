import 'package:fav_places_app/models/place.dart';
import 'package:fav_places_app/models/screens/map.dart';
import 'package:fav_places_app/models/widgets/map_preview.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class PlacesDetailsScreen extends StatelessWidget {
  const PlacesDetailsScreen({super.key, required this.place});
  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place.name)),
      body: Stack(
        children: [
          Image.file(
            place.image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          if (place.location != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => MapScreen(
                            initialLocation: LatLng(
                              place.location!.latitude,
                              place.location!.longitude,
                            ),
                            isSelecting: false,
                          ),
                        ),
                      );
                    },
                    child: MapPreview(
                      location: place.location!,
                      width: 140,
                      height: 140,
                      zoom: 15,
                      circular: true,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                    child: Text(
                      place.location!.address,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
