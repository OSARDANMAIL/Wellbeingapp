import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Declare variables to store the student messages and reply text
  List<Map<String, dynamic>> studentMessages = [];
  TextEditingController replyController = TextEditingController();
  String selectedConversationId = ''; // Store selected conversation ID

  @override
  void initState() {
    super.initState();
    fetchStudentMessages(); // Call fetch messages on page load
  }

  // Function to fetch student messages from Firestore
  Future<void> fetchStudentMessages() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Fetch all student messages from the studentMessages collection
      QuerySnapshot querySnapshot = await firestore
          .collection('messages')
          .doc(
              'unique_conversation_id') // Replace with actual conversation ID logic
          .collection('studentMessages')
          .orderBy('timestamp') // Order by timestamp to show latest messages
          .get();

      // Get the documents and store them in a list
      List<Map<String, dynamic>> fetchedMessages = [];
      for (var doc in querySnapshot.docs) {
        fetchedMessages.add(doc.data() as Map<String, dynamic>);
      }

      setState(() {
        studentMessages =
            fetchedMessages; // Update the state with the fetched messages
      });
    } catch (e) {
      print('Error fetching student messages: $e');
    }
  }

// Function to send admin's reply
  Future<void> sendAdminReply(String conversationId) async {
    if (conversationId.isNotEmpty && replyController.text.isNotEmpty) {
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Add admin's reply to Firestore under adminMessages subcollection
        await firestore
            .collection('messages')
            .doc(conversationId) // Ensure valid conversationId
            .collection(
                'adminMessages') // Store in the adminMessages subcollection
            .add({
          'content': replyController.text,
          'timestamp': FieldValue.serverTimestamp(),
          'uid': 'admin', // Use a generic admin identifier
        });

        replyController.clear();
        fetchStudentMessages();
      } catch (e) {
        print('Error sending admin reply: $e');
      }
    } else {
      print("No conversation selected or reply is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Manage Messages'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: studentMessages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: studentMessages.length,
                    itemBuilder: (context, index) {
                      var message = studentMessages[index];
                      return ListTile(
                        title: Text(message['message']),
                        subtitle: Text('Sent by: ${message['userEmail']}'),
                        trailing: const Icon(Icons.reply),
                        onTap: () {
                          // Set the selected conversation ID when a message is clicked
                          setState(() {
                            selectedConversationId =
                                message['conversationId'] ?? '';
                          });
                        },
                      );
                    },
                  ),
          ),
          if (selectedConversationId.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: replyController,
                decoration: InputDecoration(
                  hintText: 'Type your reply...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => sendAdminReply(selectedConversationId),
                child: const Text('Send Reply'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
