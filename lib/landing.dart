import 'package:flutter/material.dart';
import 'login.dart';
import 'account.dart';
import 'pwd.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    // Trigger the animation when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isAnimated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Animated circle in top-right with image
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              curve: Curves.easeOut,
              top: _isAnimated ? -50 : MediaQuery.of(context).size.height / 2 - 100,
              right: _isAnimated ? -50 : MediaQuery.of(context).size.width / 2 - 100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Color(0xFFB99A45).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/th1.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo
                  Image.asset(
                    'assets/lg_whitebg.png', // Path to your logo image
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 20.0),
                  // Catchphrase
                  Text(
                    'CraftedHope',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB99A45),
                      fontFamily: 'Gabriela-Regular',
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 60.0),
                  // Login button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB99A45),
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
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
                  SizedBox(height: 20.0),
                  // Sign Up button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateAccountForm()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB99A45),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'Gabriela-Regular',
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // Forgot Password link
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Gabriela-Regular',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Animated circle in bottom-right with resized image
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              curve: Curves.easeOut,
              top: _isAnimated ? 790 : MediaQuery.of(context).size.height / 2 - 100,
              right: _isAnimated ? 250 : MediaQuery.of(context).size.width / 2 - 100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Color(0xFFB99A45).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: SizedBox(
                    width: 50,  
                    height: 50,  
                    child: Image.asset(
                      'assets/button1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}