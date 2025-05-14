import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:well_being_app/pages/login_or_register_page.dart';
import 'login_page.dart'; // Assuming login_page.dart is in the same directory as auth_page.dart.
import 'home_page.dart'; // Similarly, import home_page.dart if it's also in the same directory.

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return const HomePage();
          }
          // user is NOT logged in
          else {
            return const LoginOrRegisterPage();
          }
        },
      ), // StreamBuilder
    ); // Scaffold
  }
}
