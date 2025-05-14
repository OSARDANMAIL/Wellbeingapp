import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseDetailPage extends StatelessWidget {
  final String courseId;
  final String courseTitle;

  const CourseDetailPage({
    Key? key,
    required this.courseId,
    required this.courseTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(courseTitle)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .collection('weekId') // ✅ Correct collection name
            .orderBy('week')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final weeks = snapshot.data!.docs;

          if (weeks.isEmpty) {
            return Center(child: Text("No weeks added yet."));
          }

          return ListView.builder(
            itemCount: weeks.length,
            itemBuilder: (context, index) {
              final data = weeks[index].data() as Map<String, dynamic>;

              final title = data['title'] ?? '';
              final content = data['content'] ?? '';
              final imageUrl = data['imageUrl'] ?? '';
              final bulletPoints = content.split('•');

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ExpansionTile(
                  leading: Icon(Icons.calendar_month, color: Colors.blue),
                  title: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (bulletPoints
                            .where(
                                (point) => (point as String).trim().isNotEmpty)
                            .map<Widget>((point) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("• ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blueAccent)),
                                      Expanded(
                                        child: Text(
                                          point.trim(),
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList()),
                      ),
                    ),
                    if (imageUrl.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
