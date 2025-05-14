import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Import the file_picker package
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase storage
import 'package:firebase_auth/firebase_auth.dart';

class SAPFormPage extends StatefulWidget {
  const SAPFormPage({super.key});

  @override
  _SAPFormPageState createState() => _SAPFormPageState();
}

class _SAPFormPageState extends State<SAPFormPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isFormSubmitted = false;
  PlatformFile? pickedFile; // To store the picked file

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        pickedFile = result.files.single;
      });
    }
  }

  Future<void> _uploadFile() async {
    if (pickedFile != null) {
      try {
        final user = _auth.currentUser;
        if (user != null) {
          String fileName = pickedFile!.name;
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('sap_documents/${user.uid}/$fileName');
          final uploadTask = storageRef.putData(pickedFile!.bytes!);
          await uploadTask;
          print("File uploaded successfully!");
        }
      } catch (e) {
        print("Error uploading file: $e");
      }
    }
  }

  Future<void> submitForm() async {
    final fullName = fullNameController.text;
    final email = emailController.text;
    final reason = reasonController.text;

    // Upload the selected file
    await _uploadFile();

    // Save the form data to Firestore
    final user = _auth.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('sapApplications').add({
        'fullName': fullName,
        'email': email,
        'reason': reason,
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    setState(() {
      isFormSubmitted = true;
    });

    print("Full Name: $fullName");
    print("Email: $email");
    print("Reason: $reason");

    // You could add logic to show a success message, clear fields, etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SAP Application Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Full Name", style: TextStyle(fontSize: 18)),
            TextField(
                controller: fullNameController,
                decoration:
                    const InputDecoration(hintText: "Enter your full name")),
            const SizedBox(height: 20),
            const Text("Email Address", style: TextStyle(fontSize: 18)),
            TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    hintText: "Enter your email address")),
            const SizedBox(height: 20),
            const Text("Reason for Assistance", style: TextStyle(fontSize: 18)),
            TextField(
                controller: reasonController,
                decoration:
                    const InputDecoration(hintText: "Explain your situation"),
                maxLines: 5),
            const SizedBox(height: 20),

            // Add file upload button
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text("Upload Supporting Documents"),
            ),
            if (pickedFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("File selected: ${pickedFile!.name}",
                    style: const TextStyle(fontSize: 16)),
              ),

            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: submitForm,
              child: const Text("Submit Application"),
            ),

            // Success message after submission
            if (isFormSubmitted)
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text("Your application has been submitted successfully.",
                    style: TextStyle(fontSize: 16, color: Colors.green)),
              ),
          ],
        ),
      ),
    );
  }
}
