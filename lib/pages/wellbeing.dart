import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:well_being_app/chat/presentation/ai_chatpage.dart';
import 'package:well_being_app/chat/presentation/chat_provider.dart';
import 'package:well_being_app/pages/CalmSoundsPage.dart';
import 'package:well_being_app/pages/CheckinInsightsPage.dart';
import 'package:well_being_app/pages/WorkoutListPage.dart';
import 'package:well_being_app/pages/active_wellbeing_page.dart';
import 'package:well_being_app/pages/articles_page.dart';
import 'package:well_being_app/pages/meal_planner_page.dart';
import 'package:well_being_app/pages/sap_page_dart';
import 'mental_health.dart'; // Import the mental health page

class Wellbeingpage extends StatelessWidget {
  const Wellbeingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Daily Wellness Tip Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Daily Wellness Tip",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Take short breaks during study sessions to stretch and move around. This helps improve focus and reduces stress.",
                      style: TextStyle(color: Colors.green.shade800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // What's New Section
              const SectionTitle(title: "What's new"),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SectionCard(
                      title: "Find Your Groove",
                      image: 'lib/images/pathway.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => ChatProvider(),
                              child: const AiChatPage(),
                            ),
                          ),
                        );
                      },
                    ),
                    SectionCard(
                        title: "30 mins Workout",
                        image: 'lib/images/exercise.png',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => WorkoutListPage()),
                          );
                        }),
                    SectionCard(
                      title: "Healthy Meal Prep",
                      image: 'lib/images/healthy-food.png',
                      onTap: () {
                        // Action when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MealPlannerPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // All for Your Well-being Section
              const SectionTitle(title: "All for your well-being"),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SectionCard(
                      title: "Tackle Depression",
                      image: 'lib/images/sad.png',
                      onTap: () {
                        // Action when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CheckinInsightsPage()),
                        );
                      },
                    ),
                    SectionCard(
                      title: "Calm Sounds",
                      image: 'lib/images/music.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalmSoundsPage()),
                        );
                      },
                    ),
                    SectionCard(
                      title: "Articles",
                      image: 'lib/images/search.png',
                      onTap: () {
                        // Action when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ArticlesPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // University Of Hull Well-being Services Section
              const SectionTitle(
                  title: "University Of Hull Well-being Services"),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SectionCard(
                      title: "Mental Health and Wellbeing Team",
                      image: 'lib/images/emotional-control.png',
                      onTap: () {
                        // Action when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MentalHealthPage()),
                        );
                      },
                    ),
                    SectionCard(
                      title: "Active Wellbeing Programme",
                      image: 'lib/images/clipboard.png',
                      onTap: () {
                        // Action when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const WellbeingDailyCheckIn()),
                        );
                      },
                    ),
                    SectionCard(
                      title: "Student Assistance Programme (SAP)",
                      image: 'lib/images/scholarship.png',
                      onTap: () {
                        // Action when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EmergencyFundPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final String image;
  final Function onTap;

  const SectionCard({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(), // Trigger the onTap action when clicked
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.shade200,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(image,
                  fit: BoxFit.cover, height: 150, width: 150),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
