import 'package:flutter/material.dart';
import 'package:well_being_app/util/mytask_button.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;
  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.lightGreen[300],
      content: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Get user input
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Add a new task",
              ), // InputDecoration
            ), // TextField

            // Buttons -> save + cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Save button
                MytaskButton(text: "Save", onPressed: onSave),

                const SizedBox(
                  width: 8,
                ),

                // Cancel button
                MytaskButton(text: "Cancel", onPressed: onCancel),
              ], // Row
            ), // Column
          ],
        ), // Container
      ), // AlertDialog
    );
  }
}
