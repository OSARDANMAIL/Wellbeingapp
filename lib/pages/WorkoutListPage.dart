import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:well_being_app/pages/WorkoutDetailPage.dart';

class WorkoutListPage extends StatelessWidget {
  const WorkoutListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workouts")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('workouts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final workouts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final data = workouts[index].data() as Map<String, dynamic>;
              final docId = workouts[index].id;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: ListTile(
                  leading: Icon(Icons.fitness_center, color: Colors.blue),
                  title: Text(data['title'] ?? ''),
                  subtitle: Text("${data['duration']} • ${data['type']}"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkoutDetailPage(workoutId: docId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
