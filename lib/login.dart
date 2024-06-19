import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'about.dart';
import 'account.dart'; 
import 'pwd.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
    return Material( // Add Material widget here
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
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/lg_whitebg.png',
                        height: 100,
                        width: 100,
                      ),
                    ],
                  ),
                  SizedBox(height: 80.0),
                  TextField(
                    controller: emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        color: Color(0xFFB99A45),
                        fontFamily: 'Gabriela-Regular',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Color(0xFFB99A45),
                        fontFamily: 'Gabriela-Regular',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () => signIn(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB99A45),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Gabriela-Regular',
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateAccountForm()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB99A45),
                    ),
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Gabriela-Regular',
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB99A45),
                    ),
                    child: Text(
                      'Forgot Password?',
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
    );
  }
}
