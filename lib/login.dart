import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'about.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  int currentBackgroundIndex = 0; // Index for cycling through background images
  List<String> backgroundImages = [
    'assets/cloth.png',
    'assets/bg2.png',
    'assets/bg3.png',
    'assets/bg4.png',
    // Add more paths as needed
  ];
  Timer? timer; // Timer object for changing background every 10 seconds

  @override
  void initState() {
    super.initState();
    // Start the timer when the widget initializes
    startTimer();
  }

  @override
  void dispose() {
    // Dispose the timer to prevent memory leaks when the widget is disposed
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    // Initialize a Timer to change background every 10 seconds
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      setState(() {
        // Increment the index to switch to the next background image
        currentBackgroundIndex = (currentBackgroundIndex + 1) % backgroundImages.length;
      });
    });
  }

  void signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Navigate to the home page after successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AboutUsPage()),
      );
    } catch (e) {
      // Handle login errors here
      print('Error logging in: $e');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log in. Please check your credentials.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFB99A45),
          title: Text(
            'CraftedHope',
            style: TextStyle(
              fontFamily: 'Gabriela-Regular',
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImages[currentBackgroundIndex]),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30.0), // Move the logo down
                    // App logo
                    Image.asset(
                      'assets/nobgapp.png', // Path to your logo image
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(height: 20.0), // Reduce distance between logo and form
                    // Stack for frame and input fields
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Frame image
                        Image.asset(
                          'assets/frame.png',
                          fit: BoxFit.contain,
                          width: 590.0, // Width of the frame image
                          height: 305.0, // Height of the frame image
                        ),
                        // Light gold-colored container with input fields
                        Container(
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFE5B4), // Light gold color
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Color(0xFFB99A45),
                              width: 3.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Email input field
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Gabriela-Regular',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFB99A45)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              // Password input field
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Gabriela-Regular',
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFB99A45)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    // Login button
                    ElevatedButton(
                      onPressed: () => signIn(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB99A45),
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Gabriela-Regular',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}