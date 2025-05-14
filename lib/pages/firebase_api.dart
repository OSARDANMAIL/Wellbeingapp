import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:well_being_app/pages/todo.dart'; // Update this import to match your project structure

class FirebaseApi {
  // Method to create a new task in Firestore for a specific user
  static Future<String> createTodoForUser(String userId, Todo todo) async {
    try {
      // Add the todo (task) to the 'todos' collection under the user's document
      await FirebaseFirestore.instance
          .collection('users') // Using 'users' collection to store each user
          .doc(userId) // Each user has their own document by UID
          .collection('todos') // Store todos within the user's document
          .add(todo.toMap());

      return 'Todo created successfully';
    } catch (e) {
      // If any error occurs during the process, return the error message
      return 'Error: $e';
    }
  }
}
