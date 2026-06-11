import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class Place {
  Place({required this.name}) : id = uuid.v4();
  final String name;
  final String id;
}
