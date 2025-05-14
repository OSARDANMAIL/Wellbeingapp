import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String title;
  String description;
  bool completed;
  DateTime createdAt;

  Todo({
    required this.title,
    this.description = 'No description provided',
    this.completed = false,
    required this.createdAt,
  });

  // Convert Todo object to Map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'createdAt': createdAt,
    };
  }

  // Convert Firestore document data to Todo object
  factory Todo.fromMap(Map<String, dynamic> map, String docId) {
    return Todo(
      title: map['title'],
      description: map['description'],
      completed: map['completed'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
