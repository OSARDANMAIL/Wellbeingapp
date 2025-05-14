/*import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:well_being_app/components/month_summary.dart'; // Import MonthlySummary widget
import 'package:well_being_app/data/database.dart';
import 'package:well_being_app/datetime/date_time.dart';
import 'package:well_being_app/pages/auth_service.dart';
import 'package:well_being_app/util/dialog_box.dart';
import '../util/todo_tile.dart';
import 'motivation_page.dart'; // Assuming this is your existing Motivation Page
import 'wellbeing.dart'; // Assuming this is your existing Wellbeing Page
import 'SupportPage.dart'; // Assuming this is your existing Support Page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  // sign user out
  void signOut() {
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    // call signOut method
    authService.signOut();
  }

  @override
  void initState() {
    // if this is the 1st time ever opening the app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      //there already exist data
      db.loadData();
    }

    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  // checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  // create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  // Method to return the title based on the selected index
  String getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Home Page'; // Title for Dashboard
      case 1:
        return 'Motivation';
      case 2:
        return 'Wellbeing';
      case 3:
        return 'Support';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // Dashboard Content (Home Page)
      SingleChildScrollView(
        // Wrap the entire content in SingleChildScrollView
        child: Column(
          children: [
            // Monthly Summary HeatMap
            MonthlySummary(
              datasets: db.heatMapDataSet,
              startDate: _myBox.get("START_DATE") ?? todaysDateFormatted(),
            ),

            // ToDo List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  taskName: db.toDoList[index][0],
                  taskCompleted: db.toDoList[index][1],
                  onChanged: (value) => checkBoxChanged(value, index),
                  deleteFunction: (context) => deleteTask(index),
                );
              },
            ),
          ],
        ),
      ),

      // Motivation Page
      const NotificationsPage(),
      // Wellbeing Page
      const Wellbeingpage(),
      // Support Page
      const SupportPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        actions: [
          // Notification Icon
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
          // Settings Icon
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle settings tap
            },
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            padding: const EdgeInsets.all(16),
            gap: 8,
            tabs: const [
              GButton(icon: Icons.dashboard, text: 'Dashboard'),
              GButton(icon: Icons.lock, text: 'Motivation'),
              GButton(icon: Icons.favorite_border, text: 'Wellbeing'),
              GButton(icon: Icons.support, text: 'Support'),
            ],
          ),
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: createNewTask,
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            )
          : null, // Hide FAB on other pages (Motivation, Wellbeing, Support)
    );
  }
}
*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:table_calendar/table_calendar.dart'; // Calendar widget
import 'package:provider/provider.dart';
import 'package:well_being_app/pages/auth_service.dart';
import 'package:well_being_app/pages/firebase_api.dart'; // Firebase API file
import 'package:well_being_app/pages/todo.dart';
import 'package:well_being_app/util/dialog_box.dart';
import '../util/todo_tile.dart';
import 'motivation_page.dart';
import 'wellbeing.dart';
import 'SupportPage.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Import Slidable package

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  DateTime _selectedDay = DateTime.now();
  late Map<DateTime, bool>
      _taskCompletionDays; // Map to store task completion for specific days

  // Text controller for new task input
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _taskCompletionDays = {};
    _loadTasks();
  }

  // Sign user out
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  // Load tasks from Firestore for the current user
  void _loadTasks() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return; // If no logged-in user, don't proceed
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('todos')
        .orderBy('createdAt',
            descending: true) // Order tasks by creation date, descending
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _taskCompletionDays.clear(); // Clear previous task completion days
        for (var doc in snapshot.docs) {
          var taskData = doc.data() as Map<String, dynamic>;
          var taskDate = (taskData['createdAt'] as Timestamp).toDate();

          // Normalize the task date to remove the time portion
          var normalizedTaskDate =
              DateTime(taskDate.year, taskDate.month, taskDate.day);

          // Mark the day as completed if the task was created on this day
          _taskCompletionDays[normalizedTaskDate] = true;
        }
      });
    });
  }

  // Save new task to Firestore
  void saveNewTask() async {
    String taskTitle = _controller.text;

    // Get current user UID
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return; // If there's no logged-in user, don't proceed
    }

    // Create a new Todo object with title from the controller and other default values
    Todo newTask = Todo(
      title: taskTitle,
      createdAt: DateTime.now(),
    );

    // Save task to Firestore under the user's document
    await FirebaseApi.createTodoForUser(user.uid, newTask);

    // Clear the text field after task is saved
    _controller.clear();
    Navigator.of(context).pop(); // Close the dialog
  }

  // Create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // Method to return the title based on the selected index
  String getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Home Page';
      case 1:
        return 'Motivation';
      case 2:
        return 'Wellbeing';
      case 3:
        return 'Support';
      default:
        return '';
    }
  }

  // Method to check if a date has any completed tasks
  bool _isDateCompleted(DateTime date) {
    // Normalize the date to compare only the year, month, and day (ignore the time)
    var normalizedDate = DateTime(date.year, date.month, date.day);
    return _taskCompletionDays.containsKey(normalizedDate) &&
        _taskCompletionDays[normalizedDate]!;
  }

  // Method to mark the task as completed (strike-through the text)
  void _markTaskCompleted(String taskId, bool completed) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return; // If there's no logged-in user, don't proceed
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('todos')
        .doc(taskId)
        .update({'completed': completed}); // Update task completion status

    _loadTasks(); // Refresh the task list
  }

  // Method to delete a task
  void _deleteTask(String taskId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return; // If there's no logged-in user, don't proceed
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('todos')
        .doc(taskId)
        .delete();

    _loadTasks(); // Refresh the task list
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // Dashboard Content (Home Page)
      SingleChildScrollView(
        child: Column(
          children: [
            // Calendar inside a box (Container with padding and border)
            Container(
              padding: const EdgeInsets.all(12.0),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2025, 01, 01),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _selectedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                eventLoader: (day) {
                  // Highlight days where there are tasks
                  return _isDateCompleted(day) ? [Text("✔")] : [];
                },
              ),
            ),

            // ToDo List - StreamBuilder to fetch tasks from Firestore
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .collection('todos')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var tasks = snapshot.data!.docs.map((doc) {
                  var taskData = doc.data() as Map<String, dynamic>;
                  return Todo(
                    title: taskData['title'],
                    description: taskData['description'],
                    completed: taskData['completed'],
                    createdAt: taskData['createdAt'].toDate(),
                  );
                }).toList();

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              _deleteTask(snapshot.data!.docs[index]
                                  .id); // Delete task when swiped
                            },
                            icon: Icons.delete,
                            backgroundColor: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25, top: 25),
                          ),
                        ],
                      ),
                      child: ToDoTile(
                        taskName: tasks[index].title,
                        taskCompleted: tasks[index].completed,
                        onChanged: (value) {
                          _markTaskCompleted(snapshot.data!.docs[index].id,
                              value!); // Mark task as completed when checkbox is tapped
                        },
                        deleteFunction: (context) {
                          _deleteTask(snapshot.data!.docs[index]
                              .id); // Delete task when swipe-to-delete is used
                        },
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),

      // Motivation Page
      const NotificationsPage(),
      // Wellbeing Page
      const Wellbeingpage(),
      // Support Page
      const SupportPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        actions: [
          // Notification Icon
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
          // Settings Icon
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            padding: const EdgeInsets.all(16),
            gap: 8,
            tabs: const [
              GButton(icon: Icons.dashboard, text: 'Dashboard'),
              GButton(icon: Icons.lock, text: 'Motivation'),
              GButton(icon: Icons.favorite_border, text: 'Wellbeing'),
              GButton(icon: Icons.support, text: 'Support'),
            ],
          ),
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: createNewTask,
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
