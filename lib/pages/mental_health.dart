import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:well_being_app/pages/chat_page.dart'; // Import FirebaseAuth to get the current user

class MentalHealthPage extends StatefulWidget {
  const MentalHealthPage({super.key});

  @override
  _MentalHealthPageState createState() => _MentalHealthPageState();
}

class _MentalHealthPageState extends State<MentalHealthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health chat'),
      ),
      body: _buildUserList(),
    );
  }

  // build a list of users except the current logged-in user, and show admin to normal users
  // admin can see users who have sent messages
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error occurred');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        // Check if the current user is admin or not
        bool isAdmin = _auth.currentUser!.email == "admin@hull.ac.uk";

        // Filter users depending on if they are an admin or not
        var userDocs = snapshot.data!.docs.where((doc) {
          // Admin sees all users who have messaged them
          if (isAdmin) {
            return true;
          }

          // Users should only see the admin
          return doc['isAdmin'] == true &&
              _auth.currentUser!.email != doc['email']; // Show only admin
        }).toList();

        return ListView(
          children:
              userDocs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
        );
      },
    );
  }

  // build individual user list item
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    return ListTile(
      title: Text(data['email']),
      onTap: () {
        // When a user clicks on a list item, navigate to the ChatPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverUserEmail: data['email'],
              receiverUserID: data['uid'],
            ),
          ),
        );
      },
    );
  }
}
