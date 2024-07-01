import 'package:flutter/material.dart';
import 'package:sls/top.dart';
import 'sell.dart';
import 'bottom.dart';

class ThriftPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black, // Set background color to black
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Image.asset('assets/buy.png', height: 200,width:200), // Add buy.png image above the Buy button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuyThriftPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB99A45), // Set button color to B99A45
                  ),
                  child: Text('Buy Thrift Clothes', style: TextStyle(color: Colors.white)), // Set text color to white
                ),
              ],
            ),
            SizedBox(height: 20), // Add some spacing between the buttons
            Column(
              children: [
                Image.asset('assets/sell.png', height: 200,width:200), // Add sell.png image above the Sell button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SellThriftPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB99A45), // Set button color to B99A45
                  ),
                  child: Text('Sell Thrift Clothes', style: TextStyle(color: Colors.white)), // Set text color to white
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(pageBackgroundColor: Colors.black,currentIndex: 0),
    );
  }
}


class BuyThriftPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black, // Set background color to black
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Images and Cost Details for Buying',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            // Add code here to display images and cost details for buying
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(pageBackgroundColor: Colors.black,currentIndex: 0),
    );
  }
}
