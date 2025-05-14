import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'article_detail_page.dart'; // Import the detail page

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  String selectedCategory = "all"; // Default category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Articles")),
      body: Column(
        children: [
          _buildCategorySelector(), // Category selector
          Expanded(child: _buildArticlesList()), // Articles list
        ],
      ),
    );
  }

  // 🏷️ Category Selector
  Widget _buildCategorySelector() {
    List<String> categories = ["all", "stress", "sleep", "productivity"];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              label: Text(category.toUpperCase()),
              selected: selectedCategory == category,
              onSelected: (bool selected) {
                setState(() {
                  selectedCategory = selected ? category : "all";
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // 📄 Fetch Articles with Filtering
  Widget _buildArticlesList() {
    Query query = FirebaseFirestore.instance
        .collection('articles')
        .orderBy('date', descending: true);

    if (selectedCategory != "all") {
      query = query.where('category', isEqualTo: selectedCategory);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No articles found."));
        }

        var articles = snapshot.data!.docs;

        return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            var article = articles[index].data() as Map<String, dynamic>;
            return _buildArticleCard(context, article);
          },
        );
      },
    );
  }

  // 📜 Article Card UI
  Widget _buildArticleCard(BuildContext context, Map<String, dynamic> article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailPage(article: article),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(article['title'] ?? "No Title",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(article['summary'] ?? "No Summary",
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 10),
              Text(
                "Read more →",
                style: TextStyle(color: Colors.blue.shade700, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
