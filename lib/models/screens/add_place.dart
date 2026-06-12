import 'dart:io';

import 'package:fav_places_app/models/place.dart';
import 'package:fav_places_app/models/widgets/image_input.dart';
import 'package:fav_places_app/models/widgets/location_input.dart';
import 'package:flutter/material.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  final _selectedImage = ValueNotifier<File?>(null);
  final _selectedLocation = ValueNotifier<PlaceLocation?>(null);

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _selectedImage.dispose();
    _selectedLocation.dispose();
  }

  void onAddPlace() {
    final title = _titleController.text;
    if (title.isEmpty ||
        _selectedImage.value == null ||
        _selectedLocation.value == null) {
      return;
    }

    final newPlace = Place(
      name: title,
      image: _selectedImage.value!,
      location: _selectedLocation.value!,
    );
    Navigator.of(context).pop(newPlace);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a New Place')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleController,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            SizedBox(height: 16),
            ImageInput(
              onPickImage: (image) {
                _selectedImage.value = image;
              },
            ),

            SizedBox(height: 16),
            LocationInput(
              onSelectLocation: (location) {
                _selectedLocation.value = location;
              },
            ),

            SizedBox(height: 10),
            ListenableBuilder(
              listenable: Listenable.merge([
                _titleController,
                _selectedImage,
                _selectedLocation,
              ]),
              builder: (ctx, _) => ElevatedButton.icon(
                onPressed:
                    _titleController.text.isEmpty ||
                        _selectedImage.value == null ||
                        _selectedLocation.value == null
                    ? null
                    : onAddPlace,
                icon: const Icon(Icons.add),
                label: const Text('Add Place'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
