import 'package:flutter/material.dart';
import 'bottom.dart';

class BuyThriftPage extends StatelessWidget {
  final String imagePath;
  final String costDetails;

  BuyThriftPage({required this.imagePath, required this.costDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy Thrift Clothes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imagePath), // Display the uploaded image
            SizedBox(height: 20),
            Text('Cost Details: $costDetails'), // Display the cost details
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Add your logic to handle GPay payment here
              },
              icon: Icon(Icons.payment), // Icon indicating payment
              label: Text('Pay using GPay'), // Button text
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // Set text color to white
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Set button border radius
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Set button padding
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(pageBackgroundColor: Colors.black,currentIndex: 0),
    );
  }
}
