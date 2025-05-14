/*import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Learning Resources Section
              const SectionTitle(title: "Learning Resources"),
              const SizedBox(height: 10),
              // Learning Resources Cards
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    LearningResourceCard(
                      title: "Study Techniques",
                      image:
                          'lib/images/book.png', // Update with your correct image path
                    ),
                    LearningResourceCard(
                      title: "Canvas",
                      image:
                          'lib/images/canvas.png', // Update with your correct image path
                    ),
                    LearningResourceCard(
                      title: "Timetable",
                      image:
                          'lib/images/deadline.png', // Update with your correct image path
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Support Services Section
              const SectionTitle(title: "Support services"),
              const SizedBox(height: 10),
              // Support service cards
              Container(
                child: const Column(
                  children: [
                    SupportCard(
                      icon: Icons.phone,
                      title: "24/7 Helpline",
                      description:
                          "Call 1-800-123-4567 for immediate assistance",
                    ),
                    SizedBox(height: 15),
                    SupportCard(
                      icon: Icons.school,
                      title: "University of Hull Support",
                      description:
                          "Call 1-800-123-4567 for immediate assistance",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Upcoming Workshops & Events Section
              const SectionTitle(title: "Upcoming Workshops & Events"),
              const SizedBox(height: 10),
              // Workshops & Events cards
              Container(
                child: const Column(
                  children: [
                    EventCard(
                      icon: Icons.laptop,
                      title: "Assistive Technology Training",
                      date: "Date: May 15, 2023",
                      time: "Time: 2:00 PM - 4:00 PM",
                    ),
                    SizedBox(height: 15),
                    EventCard(
                      icon: Icons.lightbulb,
                      title: "Study Strategies for ADHD",
                      date: "Date: May 22, 2023",
                      time: "Time: 1:00 PM - 3:00 PM",
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

class SupportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const SupportCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final IconData icon;

  const EventCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 30), // Icon with color
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  date,
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LearningResourceCard extends StatelessWidget {
  final String title;
  final String image;

  const LearningResourceCard({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.blue.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              image,
              height: 160,
              width: 160,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:well_being_app/pages/CanvasPage.dart';
import 'package:well_being_app/pages/ics_uploader_page.dart';
import 'package:well_being_app/pages/timetable.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: "Learning Resources"),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    LearningResourceCard(
                      title: "Canvas",
                      image: 'lib/images/canvas.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CanvasPage()),
                        );
                      },
                    ),
                    LearningResourceCard(
                      title: "Timetable",
                      image: 'lib/images/deadline.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TimetablePage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const SectionTitle(title: "Support services"),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('supportServices')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const CircularProgressIndicator();
                  return Column(
                    children: snapshot.data!.docs.map((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: SupportCard(
                          icon: getIconFromString(data['icon']),
                          title: data['title'],
                          description: data['description'],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20),
              const SectionTitle(title: "Upcoming Workshops & Events"),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('upcomingEvents')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return const CircularProgressIndicator();
                  return Column(
                    children: snapshot.data!.docs.map((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: EventCard(
                          icon: getIconFromString(data['icon']),
                          title: data['title'],
                          date: "Date: ${data['date']}",
                          time: data['startTime'] != null &&
                                  data['endTime'] != null
                              ? "Time: ${data['startTime']} - ${data['endTime']}"
                              : "Time: TBD",
                          venue: "Venue: ${data['venue']}",
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData getIconFromString(String iconName) {
    switch (iconName) {
      case 'phone':
        return Icons.phone;
      case 'school':
        return Icons.school;
      case 'laptop':
        return Icons.laptop;
      case 'lightbulb':
        return Icons.lightbulb;
      default:
        return Icons.info;
    }
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

class SupportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const SupportCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 5),
                Text(description, style: const TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String venue;
  final IconData icon;

  const EventCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.venue,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 5),
                Text(date, style: const TextStyle(color: Colors.black)),
                Text(time, style: const TextStyle(color: Colors.black)),
                Text(venue, style: const TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LearningResourceCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback? onTap;

  const LearningResourceCard({
    super.key,
    required this.title,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blue.shade100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                image,
                height: 160,
                width: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
