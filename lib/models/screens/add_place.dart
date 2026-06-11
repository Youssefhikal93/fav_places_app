import 'package:fav_places_app/models/place.dart';
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

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  void onAddPlace() {
    final title = _titleController.text;
    if (title.isEmpty) return;

    final newPlace = Place(name: title);
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
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: _titleController,
              builder: (ctx, value, _) => ElevatedButton.icon(
                onPressed: value.text.isEmpty ? null : onAddPlace,
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
