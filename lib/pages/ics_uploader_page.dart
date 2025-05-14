import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IcsUploaderPage extends StatefulWidget {
  const IcsUploaderPage({Key? key}) : super(key: key);

  @override
  State<IcsUploaderPage> createState() => _IcsUploaderPageState();
}

class _IcsUploaderPageState extends State<IcsUploaderPage> {
  String status = '📆 Uploading timetable from local file...';

  @override
  void initState() {
    super.initState();
    _loadAndUploadLocalIcs();
  }

  Future<void> _loadAndUploadLocalIcs() async {
    try {
      // 🔹 Load the .ics content from the local asset
      final content = await rootBundle.loadString('assets/ical-10.ics');

      // 🔹 Parse the ICS data
      final calendar = ICalendar.fromString(content);
      final data = calendar.data;

      // 🔹 Extract events with type VEVENT
      final rawEvents = (data as List<Map<String, dynamic>>)
          .where((e) => e['type'] == 'VEVENT')
          .toList();

      if (rawEvents.isEmpty) {
        setState(() => status = '⚠️ No events found in the .ics file.');
        return;
      }

      int count = 0;

      // 🔹 Upload each event to Firestore
      for (var event in rawEvents) {
        final title = event['SUMMARY'] ?? 'Untitled';
        final start =
            DateTime.tryParse(event['DTSTART'].toString()) ?? DateTime.now();
        final end = DateTime.tryParse(event['DTEND'].toString()) ??
            start.add(const Duration(hours: 1));
        final location = event['LOCATION'] ?? 'No location';

        await FirebaseFirestore.instance.collection('timetables').add({
          'title': title,
          'start': start,
          'end': end,
          'location': location,
        });

        count++;
      }

      setState(() => status = "✅ Uploaded $count events to Firestore.");
    } catch (e) {
      setState(() => status = '❌ Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Timetable (.ics)")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(status, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
