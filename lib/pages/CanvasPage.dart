import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:well_being_app/pages/CourseDetailPage.dart';

class CanvasPage extends StatefulWidget {
  @override
  _CanvasPageState createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  String? userDepartment;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDepartment();
  }

  Future<void> fetchUserDepartment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        userDepartment = doc['department'];
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Canvas")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userDepartment == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Canvas")),
        body: Center(child: Text("No department info found.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("My Courses")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .where('department', isEqualTo: userDepartment)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final courses = snapshot.data!.docs;

          if (courses.isEmpty) {
            return Center(child: Text("No courses found for $userDepartment."));
          }

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final data = courses[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.book, color: Colors.blue),
                  title: Text(data['title'] ?? 'Untitled Course',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      "Code: ${data['code']}\nLecturer: ${data['lecturer']}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailPage(
                          courseId: courses[index].id,
                          courseTitle: data['title'],
                        ),
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
