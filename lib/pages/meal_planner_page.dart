import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MealPlannerPage extends StatefulWidget {
  const MealPlannerPage({Key? key}) : super(key: key);

  @override
  _MealPlannerPageState createState() => _MealPlannerPageState();
}

class _MealPlannerPageState extends State<MealPlannerPage> {
  String selectedDay = "monday"; // Default selected day
  String selectedGoal = "healthy"; // Default goal type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meal Planner")),
      body: Column(
        children: [
          _buildDaySelector(),
          _buildGoalSelector(),
          Expanded(child: _buildMealsList()),
        ],
      ),
    );
  }

  // 🔄 Day Selector
  Widget _buildDaySelector() {
    List<String> days = [
      "monday",
      "tuesday",
      "wednesday",
      "thursday",
      "friday",
      "saturday",
      "sunday"
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: days.map((day) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              label: Text(day.toUpperCase()),
              selected: selectedDay == day,
              onSelected: (bool selected) {
                setState(() {
                  selectedDay = day;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // 🔄 Goal Selector
  Widget _buildGoalSelector() {
    List<String> goals = ["healthy", "muscle gain", "weight gain"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: goals.map((goal) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              label: Text(goal.toUpperCase()),
              selected: selectedGoal == goal,
              onSelected: (bool selected) {
                setState(() {
                  selectedGoal = goal;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // 📄 Fetch Meals from Firestore
  Widget _buildMealsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mealPlanner')
          .where('day', isEqualTo: selectedDay.toLowerCase().trim())
          .where('goal', isEqualTo: selectedGoal.toLowerCase().trim())
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text("⚠️ No meals available. Check Firestore!"));
        }

        var mealDoc = snapshot.data!.docs.first;
        var mealData = mealDoc.data() as Map<String, dynamic>;

        if (!mealData.containsKey('meals')) {
          return const Center(
              child: Text("⚠️ No meals field found in Firestore."));
        }

        var meals = List<Map<String, dynamic>>.from(mealData['meals']);

        return ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index) {
            return _buildMealCard(meals[index], index, mealDoc.reference);
          },
        );
      },
    );
  }

  // 🍽️ Meal Card
  Widget _buildMealCard(
      Map<String, dynamic> meal, int mealIndex, DocumentReference mealDocRef) {
    final user = FirebaseAuth.instance.currentUser;
    bool isCompleted =
        meal['completedBy'] != null && meal['completedBy'][user!.uid] == true;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isCompleted ? Colors.green[100] : Colors.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(meal['name'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(meal['description'],
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                _buildMealInfo("🔥 ${meal['calories']} kcal"),
                _buildMealInfo("🥩 ${meal['protein']}g Protein"),
                _buildMealInfo("🍞 ${meal['carbs']}g Carbs"),
                _buildMealInfo("🥑 ${meal['fats']}g Fats"),
              ],
            ),

            const SizedBox(height: 8),
            Text("✅ ${meal['healthBenefits']}",
                style: const TextStyle(fontSize: 14, color: Colors.green)),
            const SizedBox(height: 8),

            // ✅ Toggle "Used" button on and off
            ElevatedButton(
              onPressed: () =>
                  _toggleMealCompletion(meal, mealIndex, mealDocRef),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted ? Colors.red : Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(isCompleted ? "Undo" : "Mark as Used"),
            ),
          ],
        ),
      ),
    );
  }

  // 📊 Meal Info Box
  Widget _buildMealInfo(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  // ✅ Toggle Meal Completion
  Future<void> _toggleMealCompletion(Map<String, dynamic> meal, int mealIndex,
      DocumentReference mealDocRef) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot mealSnapshot = await mealDocRef.get();
    if (!mealSnapshot.exists) return;

    List<dynamic> meals = List.from(mealSnapshot['meals']);

    var updatedMeal = meals[mealIndex];

    if (updatedMeal['completedBy'] == null) {
      updatedMeal['completedBy'] = {}; // Initialize if missing
    }

    if (updatedMeal['completedBy'][user.uid] == true) {
      updatedMeal['completedBy']
          .remove(user.uid); // Remove user if already completed
    } else {
      updatedMeal['completedBy'][user.uid] = true; // Mark as completed
    }

    meals[mealIndex] = updatedMeal; // Update meal data

    await mealDocRef.update({"meals": meals});

    setState(() {}); // Refresh UI

    // Send notification only if marking as completed
    if (updatedMeal['completedBy'][user.uid] == true) {
      _sendCompletionNotification(meal['name']);
    }
  }

  // 🔔 Send Completion Notification
  Future<void> _sendCompletionNotification(String mealName) async {
    FirebaseFirestore.instance.collection('notifications').add({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'message': "🍽️ You completed '$mealName'! Keep eating healthy! 💪",
      'date': Timestamp.now(),
    });
  }
}
