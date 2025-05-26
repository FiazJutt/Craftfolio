import 'package:craftfolio/homepage.dart';
import 'package:craftfolio/signuppage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthStatus extends StatelessWidget {
  const AuthStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          /// User is Logged In
          if(snapshot.hasData){
            return Homepage();   /// Opens Home Screen if logged in
          }
          /// User is not Logged In
          else{
            return SignupPage();   /// Opens if not logged in
          }
        },
      ),

    );
  }
}
