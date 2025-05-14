import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WellbeingDailyCheckIn extends StatefulWidget {
  const WellbeingDailyCheckIn({super.key});

  @override
  _WellbeingDailyCheckInState createState() => _WellbeingDailyCheckInState();
}

class _WellbeingDailyCheckInState extends State<WellbeingDailyCheckIn> {
  String? selectedSymptom;
  double stressLevel = 0.0;
  String feelingToday = "Good";
  double anxietyLevel = 0.0;
  TextEditingController medicineController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitForm() async {
    // Get the current user ID
    final String userId = _auth.currentUser!.uid;
    final String userEmail = _auth.currentUser!.email!;

    try {
      // Save data to Firestore under the collection 'wellbeingCheckins'
      await FirebaseFirestore.instance.collection('wellbeingCheckins').add({
        'userId': userId,
        'email': userEmail, // Add the email here
        'symptom': selectedSymptom ?? 'No symptoms selected',
        'stressLevel': stressLevel,
        'feeling': feelingToday,
        'anxietyLevel': anxietyLevel,
        'medicine': medicineController.text.isNotEmpty
            ? medicineController.text
            : 'No medicine provided',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Optionally, show a success message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Well-being check-in submitted successfully!"),
      ));

      // Clear the form after submission
      setState(() {
        selectedSymptom = null;
        stressLevel = 0.0;
        feelingToday = "Good";
        anxietyLevel = 0.0;
        medicineController.clear();
      });
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error submitting form: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Well-being Check-in"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Symptom Selection
            const Text("Symptoms you have?", style: TextStyle(fontSize: 18)),
            DropdownButton<String>(
              hint: const Text("Select Symptoms"),
              value: selectedSymptom,
              items: <String>['Headache', 'Nausea', 'Fatigue']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSymptom = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            // Stress Levels
            const Text("Your Stress levels?", style: TextStyle(fontSize: 18)),
            Slider(
              value: stressLevel,
              min: 0,
              max: 100,
              divisions: 100,
              label: stressLevel.round().toString(),
              onChanged: (double newValue) {
                setState(() {
                  stressLevel = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            // Feeling Today
            const Text("How are you feeling today?",
                style: TextStyle(fontSize: 18)),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.sentiment_very_satisfied),
                  onPressed: () {
                    setState(() {
                      feelingToday = "Good";
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.sentiment_neutral),
                  onPressed: () {
                    setState(() {
                      feelingToday = "Normal";
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.sentiment_dissatisfied),
                  onPressed: () {
                    setState(() {
                      feelingToday = "Bad";
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Anxiety Levels
            const Text("Your Anxiety levels?", style: TextStyle(fontSize: 18)),
            Slider(
              value: anxietyLevel,
              min: 0,
              max: 100,
              divisions: 100,
              label: anxietyLevel.round().toString(),
              onChanged: (double newValue) {
                setState(() {
                  anxietyLevel = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            // Medicine Input
            const Text("Western medicine you're taking?",
                style: TextStyle(fontSize: 18)),
            TextField(
              controller: medicineController,
              decoration: const InputDecoration(
                hintText: 'Write medicine names here',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: submitForm,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
