import 'package:flutter/material.dart';
import 'package:sls/top.dart';
import 'bottom.dart';
import 'about.dart';
import 'package:confetti/confetti.dart';

class ThankYouPage extends StatefulWidget {
  @override
  _ThankYouPageState createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: Duration(seconds: 15));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Stack(
        children: [
          Container(
            color: Colors.black, // Set background color to black
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // Center the text horizontally
                children: [
                  Text(
                    'Thank you for your contribution!',
                    textAlign: TextAlign.center, // Center the text horizontally
                    style: TextStyle(
                      fontFamily: 'Gabriela-Regular',
                      fontSize: 24,
                      color: Color(0xFFB99A45), // Set text color to B99A45
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your generosity will make a difference',
                    textAlign: TextAlign.center, // Center the text horizontally
                    style: TextStyle(
                      fontFamily: 'Gabriela-Regular',
                      fontSize: 18,
                      color: Color(0xFFB99A45), // Set text color to B99A45
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'We will contact you via email for further instructions',
                    textAlign: TextAlign.center, // Center the text horizontally
                    style: TextStyle(
                      fontFamily: 'Gabriela-Regular',
                      fontSize: 18,
                      color: Color(0xFFB99A45), // Set text color to B99A45
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      _controller.stop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutUsPage()),
                      );
                    },
                    child: Text(
                      'CONTINUE',
                      style: TextStyle(
                        fontFamily: 'Gabriela-Regular',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB99A45),
                      foregroundColor: Colors.white, 
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: -3.14 / 2, // Blast from top
                emissionFrequency: 0.05, // Emission frequency
                numberOfParticles: 10, // Number of particles
                gravity: 0.2, // Gravity
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}