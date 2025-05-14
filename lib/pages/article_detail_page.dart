import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ArticleDetailPage extends StatefulWidget {
  final Map<String, dynamic> article;

  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  bool isRead = false;
  String? userId;
  List<Map<String, dynamic>> relatedArticles = [];

  final List<Color> colorOptions = [
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.purple.shade100,
    Colors.orange.shade100,
    Colors.red.shade100,
    Colors.teal.shade100,
  ];

  @override
  void initState() {
    super.initState();
    _fetchReadStatus();
    _fetchRelatedArticles();
  }

  // ✅ Fetch Read Status from Firestore
  Future<void> _fetchReadStatus() async {
    userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('readArticles')
        .doc(widget.article['title'])
        .get();

    setState(() {
      isRead = doc.exists;
    });
  }

  // ✅ Fetch Related Articles (same category)
  Future<void> _fetchRelatedArticles() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('articles')
        .where('category', isEqualTo: widget.article['category'])
        .limit(3) // Show max 3 related articles
        .get();

    setState(() {
      relatedArticles = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((article) => article['title'] != widget.article['title'])
          .toList();
    });
  }

  // ✅ Toggle Read Status & Send Notification
  Future<void> _toggleReadStatus() async {
    if (userId == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('readArticles')
        .doc(widget.article['title']);

    if (isRead) {
      await docRef.delete();
    } else {
      await docRef.set({
        'title': widget.article['title'],
        'timestamp': Timestamp.now(),
      });

      // ✅ Send Notification
      await _sendReadNotification(widget.article['title']);
    }

    setState(() {
      isRead = !isRead;
    });
  }

  // ✅ Send a Read Notification to Firestore
  Future<void> _sendReadNotification(String articleTitle) async {
    if (userId == null) return;

    await FirebaseFirestore.instance.collection('notifications').add({
      'userId': userId,
      'message': "📖 You just read '$articleTitle'. Keep it up!",
      'date': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.article['title'] ?? 'Article')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Colorful Box Instead of Image
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorOptions[widget.article['title'].hashCode %
                    colorOptions.length], // Assign random color
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  widget.article['title'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Title & Summary
            Text(
              widget.article['title'],
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
            ),
            const SizedBox(height: 5),
            Text(
              widget.article['summary'],
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // ✅ Content
            Text(
              widget.article['content'] ?? "No Content Available",
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 25),

            // ✅ "Mark as Read" Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _toggleReadStatus,
                icon: Icon(
                    isRead ? Icons.check_circle : Icons.bookmark_border_rounded,
                    color: Colors.white),
                label: Text(isRead ? "Read Again" : "Mark as Read"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRead ? Colors.green : Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ✅ Related Articles Section
            const Text("Related Articles",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Column(
              children: relatedArticles.map((relatedArticle) {
                return GestureDetector(
                  onTap: () {
                    // ✅ Navigate to Selected Related Article
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ArticleDetailPage(article: relatedArticle),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorOptions[relatedArticle['title'].hashCode %
                          colorOptions.length], // Assign random color
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Title & Summary
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                relatedArticle['title'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                relatedArticle['summary'],
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Arrow Icon
                        const Icon(Icons.arrow_forward_ios,
                            size: 18, color: Colors.black87),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
