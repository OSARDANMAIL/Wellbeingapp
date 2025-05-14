/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutStepPage extends StatefulWidget {
  final String title;
  final String type;
  final String duration;
  final int order;

  const WorkoutStepPage({
    Key? key,
    required this.title,
    required this.type,
    required this.duration,
    required this.order,
  }) : super(key: key);

  @override
  State<WorkoutStepPage> createState() => _WorkoutStepPageState();
}

class _WorkoutStepPageState extends State<WorkoutStepPage> {
  int countdown = 0;
  Timer? timer;

  int extractSeconds(String duration) {
    if (duration.contains('min')) {
      return int.parse(duration.split(' ')[0]) * 60;
    } else {
      return int.parse(duration.split(' ')[0]);
    }
  }

  void startTimer() {
    countdown = extractSeconds(widget.duration);
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          t.cancel();
        }
      });
    });
  }

  Future<void> sendMotivationalNotification(String message) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('notifications').add({
      'userId': user.uid,
      'message': message,
      'date': DateTime.now(),
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 60, color: Colors.green),
            SizedBox(height: 20),
            Text(widget.type,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            SizedBox(height: 10),
            Text("Duration: ${widget.duration}",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            Text(
              countdown > 0 ? "$countdown sec left" : "✅ Done!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () async {
                await sendMotivationalNotification(
                  "🔥 You crushed '${widget.title}'! Keep going 💪",
                );
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_forward),
              label: Text("Next Step"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutStepPage extends StatefulWidget {
  final String title;
  final String type;
  final String duration;
  final int order;
  final int currentStep;
  final int totalSteps;

  const WorkoutStepPage({
    Key? key,
    required this.title,
    required this.type,
    required this.duration,
    required this.order,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  State<WorkoutStepPage> createState() => _WorkoutStepPageState();
}

class _WorkoutStepPageState extends State<WorkoutStepPage> {
  int countdown = 0;
  Timer? timer;

  int extractSeconds(String duration) {
    if (duration.contains('min')) {
      return int.parse(duration.split(' ')[0]) * 60;
    } else {
      return int.parse(duration.split(' ')[0]);
    }
  }

  void startTimer() {
    countdown = extractSeconds(widget.duration);
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          t.cancel();
        }
      });
    });
  }

  //send notification to the user
  Future<void> sendMotivationalNotification(String message) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('notifications').add({
      'userId': user.uid,
      'message': message,
      'date': DateTime.now(),
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress =
        widget.totalSteps == 0 ? 0 : widget.currentStep / widget.totalSteps;

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 🔹 Progress Bar + Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Step ${widget.currentStep} of ${widget.totalSteps}",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.green,
                  minHeight: 8,
                ),
              ],
            ),

            const SizedBox(height: 40),

            Icon(Icons.fitness_center, size: 60, color: Colors.green),
            const SizedBox(height: 20),
            Text(widget.type,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Text("Duration: ${widget.duration}",
                style: TextStyle(fontSize: 16)),

            const SizedBox(height: 30),

            Text(
              countdown > 0 ? "$countdown sec left" : "✅ Done!",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const Spacer(),

            ElevatedButton.icon(
              onPressed: () async {
                await sendMotivationalNotification(
                  "💪 You completed '${widget.title}'! Keep it up!",
                );
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_forward),
              label: Text("Next Step"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
