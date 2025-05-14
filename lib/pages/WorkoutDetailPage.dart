import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:well_being_app/pages/WorkoutStepPage.dart';

class WorkoutDetailPage extends StatefulWidget {
  final String workoutId;

  const WorkoutDetailPage({super.key, required this.workoutId});

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  Set<int> completedSteps = {};

  void markStepCompleted(int order) {
    setState(() {
      completedSteps.add(order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workout Steps")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('workouts')
            .doc(widget.workoutId)
            .collection('steps')
            .orderBy('order')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final steps = snapshot.data!.docs;

          double progress =
              steps.isEmpty ? 0 : completedSteps.length / steps.length;

          return Column(
            children: [
              // 🔥 Progress Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.green,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "${completedSteps.length} of ${steps.length} steps completed",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: steps.length,
                  itemBuilder: (context, index) {
                    final data = steps[index].data() as Map<String, dynamic>;
                    final order = data['order'];

                    return Card(
                      color: completedSteps.contains(order)
                          ? Colors.green.shade100
                          : Colors.green.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Icon(Icons.timer,
                                color: completedSteps.contains(order)
                                    ? Colors.green
                                    : Colors.grey),
                            title: Text(
                              data['title'] ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle:
                                Text("${data['type']} • ${data['duration']}"),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkoutStepPage(
                                    title: data['title'],
                                    type: data['type'],
                                    duration: data['duration'],
                                    order: order,
                                    currentStep: index + 1,
                                    totalSteps: steps.length,
                                  ),
                                ),
                              );

                              markStepCompleted(order);
                            },
                          ),
                          if (data['imageUrl'] != null &&
                              data['imageUrl'].toString().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  data['imageUrl'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
