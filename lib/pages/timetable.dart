import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
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
        appBar: AppBar(title: Text("My Timetable")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userDepartment == null) {
      return Scaffold(
        appBar: AppBar(title: Text("My Timetable")),
        body: Center(child: Text("No department info found.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("My Timetable")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('timetables')
            .where('department', isEqualTo: userDepartment)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return Center(
                child: Text("No timetable found for $userDepartment."));

          final timetableDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: timetableDocs.length,
            itemBuilder: (context, index) {
              final data = timetableDocs[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.schedule, color: Colors.green),
                  title: Text(
                    data['title'] ?? 'Untitled Class',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${data['day']} • ${data['time']}\nVenue: ${data['venue']}",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
