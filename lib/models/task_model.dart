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
    this.urgency = 'high',
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'libraryId': libraryId,
      'title': title,
      'description': description,
      'dueDate': _formatDateForApi(dueDate),
      'urgency': urgency,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    final library = map['libraryId'];

    return TaskModel(
      id: map['_id']?.toString() ?? map['id']?.toString(),
      libraryId: library is Map
          ? library['_id'].toString()
          : library.toString(),
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      dueDate: DateTime.parse(map['dueDate'].toString()),
      urgency: map['urgency']?.toString() ?? 'medium',
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }

  factory TaskModel.fromJson(String source) {
    return TaskModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }

  static String _formatDateForApi(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
