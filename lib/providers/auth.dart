import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  // signin with email and password
  static Future<void> login(Map<String, String> credentials) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: credentials['email']!,
      password: credentials['password']!,
    );
  }

  // signup with email and password
  static Future<void> signup(Map<String, String> credentials) async {
    // try to create a user with email/password
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: credentials['email']!,
      password: credentials['password']!,
    );
  }

  // logout
  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
