import 'package:craftfolio/firebase_options.dart';
import 'package:craftfolio/signuppage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Craftfolio',
    home: SignupPage(),
    // home: HomePage(),
  ));
}
