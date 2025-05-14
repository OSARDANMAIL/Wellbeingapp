import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckinProgressPage extends StatelessWidget {
  const CheckinProgressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Your Mood Progress")),
        body: const Center(child: Text("No user logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Mood Progress"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('mentalHealthCheckin')
            .where('userId', isEqualTo: user.uid) // ✅ Keep this filter
            .orderBy('date', descending: true)
            .get(), // ❌ Removed orderBy to avoid indexing error

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text("Error fetching data: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No check-in data available"));
          }

          var checkins = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: checkins.length,
            itemBuilder: (context, index) {
              var data = checkins[index].data() as Map<String, dynamic>;

              return _buildCheckinCard(
                mood: data['mood'] ?? 'Unknown',
                notes: data['notes'] ?? 'No notes',
                date: data['date'] != null
                    ? (data['date'] as Timestamp).toDate().toString()
                    : 'Unknown Date',
              );
            },
          );
        },
      ),
    );
  }

  // ✅ Builds a styled check-in card centered on the page
  Widget _buildCheckinCard(
      {required String mood, required String notes, required String date}) {
    Color moodColor = _getMoodColor(mood);

    return Center(
      child: Container(
        width: 300, // ✅ Keeps a consistent card width
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: moodColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: moodColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Mood: $mood",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: moodColor)),
            const SizedBox(height: 5),
            Text("Notes: $notes", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text("Date: $date",
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // ✅ Get color based on mood
  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case "good":
        return Colors.green;
      case "neutral":
        return Colors.yellow;
      case "bad":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
