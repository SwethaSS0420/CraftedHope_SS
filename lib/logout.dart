
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'landing.dart';

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.signOut().then((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
        (Route<dynamic> route) => false,
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable back arrow button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sentiment_satisfied,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Logged out successfully',
              style: TextStyle(
                fontSize: 26,
                fontFamily: 'Gabriela-Regular',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}