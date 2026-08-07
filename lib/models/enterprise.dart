import 'package:uuid/uuid.dart';

class Enterprise {
  final String id;
  final String name;
  final String type; // Hens or Cattle
  final String notes;
  final String dateCreated;

  Enterprise({
    String? id,
    required this.name,
    required this.type,
    required this.notes,
    required this.dateCreated,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'notes': notes,
        'dateCreated': dateCreated,
      };

  factory Enterprise.fromJson(Map<String, dynamic> json) => Enterprise(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        notes: json['notes'],
        dateCreated: json['dateCreated'],
      );
}
