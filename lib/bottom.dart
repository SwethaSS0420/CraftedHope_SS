import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavigation extends StatelessWidget {
  final Color pageBackgroundColor;
  final int currentIndex;

  BottomNavigation({
    required this.pageBackgroundColor,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    bool isWhiteBackground = pageBackgroundColor == Colors.white;
    Color iconColor = isWhiteBackground ? Colors.black : Colors.white;

    return CurvedNavigationBar(
      index: currentIndex,
      backgroundColor: pageBackgroundColor,
      color: Color(0xFFB99A45),
      buttonBackgroundColor: Color(0xFFB99A45),
      height: 50,
      items: <Widget>[
        Icon(Icons.home, size: 30, color: iconColor),
        Icon(Icons.message, size: 30, color: iconColor),
        Icon(Icons.shopping_cart, size: 30, color: iconColor),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/about_us');
            break;
          case 1:
            // Define the action for the message icon here
            break;
          case 2:
            Navigator.pushNamed(context, '/cart');
            break;
        }
      },
    );
  }
}