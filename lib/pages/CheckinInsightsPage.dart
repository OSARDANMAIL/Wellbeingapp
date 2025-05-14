import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'checkin_progress_page.dart'; // Import the progress page

class CheckinInsightsPage extends StatefulWidget {
  const CheckinInsightsPage({super.key});

  @override
  _CheckinInsightsPageState createState() => _CheckinInsightsPageState();
}

class _CheckinInsightsPageState extends State<CheckinInsightsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String selectedMood = 'Good';
  List<String> activities = [];
  TextEditingController notesController = TextEditingController();

  // ✅ Submit a new mood log
  Future<void> _submitMoodLog() async {
    final user = _auth.currentUser;
    if (user == null) return;

    String notificationMessage = _getNotificationMessage(selectedMood);

    try {
      // ✅ Save mood check-in
      await FirebaseFirestore.instance.collection('mentalHealthCheckin').add({
        'userId': user.uid,
        'email': user.email, // Store user email
        'mood': selectedMood,
        'activities': activities,
        'notes': notesController.text,
        'date': Timestamp.now(),
      });

      // ✅ Save notification in Firestore
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': user.uid,
        'email': user.email,
        'message': notificationMessage,
        'date': Timestamp.now(),
      });

      // ✅ Check for reward after submission
      await _checkForReward(user.uid);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mood Log submitted successfully!')),
      );

      setState(() {
        selectedMood = 'Good';
        activities.clear();
        notesController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting log: $e')),
      );
    }
  }

  // ✅ Check if the user deserves a reward
  Future<void> _checkForReward(String userId) async {
    try {
      print("🔍 Checking last 3 check-ins for rewards...");

      final querySnapshot = await FirebaseFirestore.instance
          .collection('mentalHealthCheckin')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(3) // ✅ Get the last 3 check-ins
          .get();

      if (querySnapshot.docs.length < 3) {
        print("⚠️ Not enough check-ins for a reward.");
        return; // ✅ User needs at least 3 check-ins
      }

      // ✅ Extract last 3 moods
      List<String> lastThreeMoods = querySnapshot.docs
          .map((doc) => doc['mood'].toString().toLowerCase())
          .toList();

      // ✅ Get timestamp of the latest check-in
      Timestamp latestCheckinTime = querySnapshot.docs.first['date'];

      print("✅ Last 3 moods: $lastThreeMoods");

      // ✅ Ensure last 3 check-ins are all "Good"
      if (lastThreeMoods.every((mood) => mood == "good")) {
        print("🎯 User qualifies for a reward!");

        // ✅ Fetch latest reward notification
        final rewardSnapshot = await FirebaseFirestore.instance
            .collection('notifications')
            .where('userId', isEqualTo: userId)
            .where('message',
                isEqualTo:
                    '🎉 Congrats! You’ve maintained a positive mood for 3 check-ins in a row! Keep it up! 🎊')
            .orderBy('date', descending: true)
            .limit(1)
            .get();

        // ✅ Check if a reward already exists AFTER the last check-in
        if (rewardSnapshot.docs.isEmpty ||
            (rewardSnapshot.docs.first['date'] as Timestamp)
                .toDate()
                .isBefore(latestCheckinTime.toDate())) {
          print("✅ Sending reward notification...");
          await _sendRewardNotification(userId);
        } else {
          print("⚠️ Reward notification already sent recently.");
        }
      } else {
        print("❌ Last 3 check-ins are not all 'Good'. No reward.");
      }
    } catch (e) {
      print("❌ Error in _checkForReward: $e");
    }
  }

  // ✅ Send a reward notification
  // ✅ Send a reward notification
  // ✅ Send a reward notification
// ✅ Send a reward notification
  Future<void> _sendRewardNotification(String userId) async {
    // Get the latest check-in time
    final latestCheckinSnapshot = await FirebaseFirestore.instance
        .collection('mentalHealthCheckin')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (latestCheckinSnapshot.docs.isEmpty) return; // No check-ins found

    Timestamp latestCheckinTime = latestCheckinSnapshot.docs.first['date'];

    // ✅ Fetch the most recent reward notification
    final rewardSnapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('message',
            isEqualTo:
                '🎉 Congrats! You’ve maintained a positive mood for 3 check-ins in a row! Keep it up! 🎊')
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    // ✅ Only add a reward if the last reward is before the latest check-in
    if (rewardSnapshot.docs.isEmpty ||
        (rewardSnapshot.docs.first['date'] as Timestamp)
            .toDate()
            .isBefore(latestCheckinTime.toDate())) {
      print("🏆 Adding new reward to Firestore...");
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userId,
        'message':
            '🎉 Congrats! You’ve maintained a positive mood for 3 check-ins in a row! Keep it up! 🎊',
        'date': Timestamp.now(),
      });
      print("✅ Reward successfully added!");
    } else {
      print(
          "⚠️ Reward notification already exists for the latest check-ins. No new reward added.");
    }
  }

  // ✅ Generate a notification message based on the mood
  String _getNotificationMessage(String mood) {
    switch (mood.toLowerCase()) {
      case "good":
        return "😊 Keep being happy! Stay positive and spread joy!";
      case "neutral":
        return "😐 Try engaging in activities you enjoy to lift your mood!";
      case "bad":
        return "😔 It's okay to have tough days. Reach out to someone you trust for support.";
      default:
        return "🔔 Mood check-in recorded.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mood Check-in")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Add a Mood Check-in",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // ✅ Mood Selection Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _moodButton("Good", Colors.green),
                  _moodButton("Neutral", Colors.yellow),
                  _moodButton("Bad", Colors.red),
                ],
              ),
              const SizedBox(height: 20),

              // ✅ Notes Field
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Add a note (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // ✅ Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitMoodLog,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text("Submit Mood Log"),
                ),
              ),

              const SizedBox(height: 30),

              // ✅ Check Progress Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CheckinProgressPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text("Check Progress"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Mood Selection Buttons
  Widget _moodButton(String moodLabel, Color color) {
    bool isSelected = (selectedMood.toLowerCase() == moodLabel.toLowerCase());
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : Colors.grey,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      onPressed: () => setState(() => selectedMood = moodLabel),
      child: Text(moodLabel),
    );
  }
}
