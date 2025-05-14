import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class VitaminDeficiencyPage extends StatefulWidget {
  @override
  _VitaminDeficiencyPageState createState() => _VitaminDeficiencyPageState();
}

class _VitaminDeficiencyPageState extends State<VitaminDeficiencyPage> {
  String? selectedSymptom;
  String? deficiency;
  String? foodRecommendation;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final Map<String, Map<String, String>> vitaminData = {
    "Fatigue": {"vitamin": "Vitamin B12", "food": "Eggs, Fish, Dairy"},
    "Weak Bones": {"vitamin": "Vitamin D", "food": "Milk, Cheese, Sunlight"},
    "Muscle Cramps": {"vitamin": "Magnesium", "food": "Bananas, Nuts, Spinach"},
    "Dry Skin": {"vitamin": "Vitamin E", "food": "Nuts, Seeds, Olive Oil"},
    "Hair Loss": {"vitamin": "Biotin", "food": "Eggs, Nuts, Whole Grains"},
  };

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings settings =
        InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(settings);
  }

  void _setReminder() async {
    if (deficiency == null) return;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails("vitamin_reminder", "Vitamin Reminder",
            importance: Importance.high);
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0,
      "Vitamin Reminder",
      "Don't forget to take $deficiency today! Stay healthy! 🌿",
      notificationDetails,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Reminder set for $deficiency!")),
    );
  }

  void _checkVitaminDeficiency() {
    if (selectedSymptom != null) {
      setState(() {
        deficiency = vitaminData[selectedSymptom]?["vitamin"];
        foodRecommendation = vitaminData[selectedSymptom]?["food"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vitamin Deficiency Check")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Select a symptom:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedSymptom,
              items: vitaminData.keys.map((symptom) {
                return DropdownMenuItem(
                  value: symptom,
                  child: Text(symptom),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSymptom = value;
                  _checkVitaminDeficiency();
                });
              },
            ),
            SizedBox(height: 20),
            if (deficiency != null) ...[
              Text("Possible Deficiency: $deficiency",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Suggested Foods: $foodRecommendation",
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _setReminder,
                child: Text("Set Reminder"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
