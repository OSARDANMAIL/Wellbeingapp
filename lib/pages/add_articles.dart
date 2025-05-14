import 'package:cloud_firestore/cloud_firestore.dart';

void addArticlesToFirestore() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> articles = [
    {
      "title": "How to Reduce Stress",
      "summary": "Practical ways to lower stress.",
      "content": "Stress is a common problem...",
      "imageUrl": "https://example.com/stress.jpg",
      "category": "stress",
      "date": FieldValue.serverTimestamp(),
    },
    {
      "title": "Managing Anxiety",
      "summary": "How to handle anxiety effectively.",
      "content": "Anxiety can be overwhelming, but you can manage it by...",
      "imageUrl": "https://example.com/anxiety.jpg",
      "category": "stress",
      "date": FieldValue.serverTimestamp(),
    },
    {
      "title": "Meditation Techniques",
      "summary": "Learn simple meditation methods.",
      "content": "Meditation is an effective way to...",
      "imageUrl": "https://example.com/meditation.jpg",
      "category": "mindfulness",
      "date": FieldValue.serverTimestamp(),
    },
    {
      "title": "Daily Mindfulness Tips",
      "summary": "Easy ways to stay mindful daily.",
      "content": "Practicing mindfulness daily helps to...",
      "imageUrl": "https://example.com/mindful.jpg",
      "category": "mindfulness",
      "date": FieldValue.serverTimestamp(),
    },
    {
      "title": "Yoga for Beginners",
      "summary": "Start your yoga journey today.",
      "content": "Yoga improves flexibility and mental health...",
      "imageUrl": "https://example.com/yoga.jpg",
      "category": "mindfulness",
      "date": FieldValue.serverTimestamp(),
    },
    {
      "title": "Healthy Eating Habits",
      "summary": "Nutrition tips for better well-being.",
      "content": "Eating healthy contributes to...",
      "imageUrl": "https://example.com/healthy.jpg",
      "category": "nutrition",
      "date": FieldValue.serverTimestamp(),
    },
    {
      "title": "Superfoods for Energy",
      "summary": "Boost your energy with the right food.",
      "content": "Superfoods like blueberries and nuts help...",
      "imageUrl": "https://example.com/superfoods.jpg",
      "category": "nutrition",
      "date": FieldValue.serverTimestamp(),
    },
    {
      "title": "Hydration and Health",
      "summary": "Why drinking water is essential.",
      "content": "Drinking enough water daily improves...",
      "imageUrl": "https://example.com/hydration.jpg",
      "category": "nutrition",
      "date": FieldValue.serverTimestamp(),
    },
    {
      "title": "Sleeping Better at Night",
      "summary": "Improve your sleep quality.",
      "content": "Good sleep hygiene is important for...",
      "imageUrl": "https://example.com/sleep.jpg",
      "category": "sleep",
      "date": FieldValue.serverTimestamp(),
    },
  ];

  for (var article in articles) {
    await firestore.collection("articles").add(article);
  }

  print("✅ All articles added successfully!");
}
