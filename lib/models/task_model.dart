import 'dart:convert';

class TaskModel {
  final String? id;
  final String libraryId;

  final String title;
  final String description;
  final DateTime dueDate;
  final String urgency;

  final bool isCompleted;

  const TaskModel({
    this.id,
    required this.libraryId,
    required this.title,
    required this.description,
    required this.dueDate,
    this.urgency = 'medium',
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'libraryId': libraryId,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'urgency': urgency,
    };
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    final library = map['libraryId'];

    return TaskModel(
      id: map['_id'] ?? map['id'],
      libraryId: library is Map ? library['_id'] : library,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: DateTime.parse(map['dueDate']),
      urgency: map['urgency'] ?? 'medium',
      isCompleted: map['isCompleted'] ?? false,
    );
  }
  factory TaskModel.fromJson(String source) {
    return TaskModel.fromMap(json.decode(source));
  }
}
