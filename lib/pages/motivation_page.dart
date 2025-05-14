import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('userId', isEqualTo: userId)
            .orderBy('date', descending: true)
            .snapshots(), // ✅ StreamBuilder for real-time updates
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text("Error fetching data: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No notifications available"));
          }

          var notifications = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: notifications.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return _buildNotificationCard(
                    message: data['message'] ?? 'No message',
                    date: data['date'] != null
                        ? data['date'].toDate().toString()
                        : 'Unknown Date',
                    docId: doc.id, // ✅ Pass document ID
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  // ✅ Function to delete a notification
  Future<void> _dismissNotification(String docId) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(docId)
        .delete();
  }

  // ✅ Styled notification card with dismiss button
  Widget _buildNotificationCard(
      {required String message, required String date, required String docId}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Notification:",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              const SizedBox(height: 5),
              Text(message, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              Text("Date: $date",
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () =>
                    _dismissNotification(docId), // ✅ Dismiss notification
                child:
                    const Text("Got it", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
