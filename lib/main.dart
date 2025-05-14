/*import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:well_being_app/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:well_being_app/pages/auth_service.dart';
import 'firebase_options.dart';
// Add this at the top of your file

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(color: Colors.blue),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(color: Colors.black),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // init flutter
  await Hive.initFlutter();

  // open the box
  var box = await Hive.openBox('mybox');
  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          AuthService(), // Create the AuthService provider here
      child: const MyApp(),
    ),
  );
}

void initHive() {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Use the system theme mode setting
      home: const AuthPage(),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:well_being_app/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:well_being_app/pages/auth_service.dart';
import 'firebase_options.dart';
// Add this at the top of your file

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(color: Colors.blue),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(color: Colors.black),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // init flutter
  await Hive.initFlutter();

  // open the box
  var box = await Hive.openBox('mybox');
  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          AuthService(), // Create the AuthService provider here
      child: const MyApp(),
    ),
  );
}

void initHive() {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Use the system theme mode setting
      home: const AuthPage(),
    );
  }
}
