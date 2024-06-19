import 'package:flutter/material.dart';
import 'logout.dart';
import 'mydetails.dart';

class CustomAppBar1 extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFB99A45), // Set the background color
      flexibleSpace: Stack(
        children: [
          Positioned(
            left: 30.0,
            top: 40.0,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/about_us');
              },
            child: Image.asset(
              'assets/bamboo.png',
              height: 55,
              width: 100,
            ),
          ),
          ),
          Positioned(
            top: 50.0,
            left: MediaQuery.of(context).size.width / 2 - 70,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/about_us');
              },
            child: Text(
              'CraftedHope',
              style: TextStyle(
                fontFamily: 'Gabriela-Regular',
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          ),
          Positioned(
            top: 35.0,
            right: 12.0,
            child: IconButton(
              onPressed: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(1000, 100, 0, 0),
                  items: <PopupMenuEntry>[
                    PopupMenuItem(
                      child: ListTile(
                        title: Text(
                          'My Account',
                          style: TextStyle(
                            fontFamily: 'Gabriela-Regular',
                            fontSize: 18.0,
                          ),
                        ),
                        onTap: () {
                          Navigator.popAndPushNamed(context, '/myaccount');
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        title: Text(
                          'Shop',
                          style: TextStyle(
                            fontFamily: 'Gabriela-Regular',
                            fontSize: 18.0,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/shop');
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        title: Text(
                          'Donate',
                          style: TextStyle(
                            fontFamily: 'Gabriela-Regular',
                            fontSize: 18.0,
                          ),
                        ),
                        onTap: () {
                          Navigator.popAndPushNamed(context, '/Donate');
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        title: Text(
                          'Recycle',
                          style: TextStyle(
                            fontFamily: 'Gabriela-Regular',
                            fontSize: 18.0,
                          ),
                        ),
                        onTap: () {
                          Navigator.popAndPushNamed(context, '/recycle');
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        title: Text(
                          'Thrift',
                          style: TextStyle(
                            fontFamily: 'Gabriela-Regular',
                            fontSize: 18.0,
                          ),
                        ),
                        onTap: () {
                          Navigator.popAndPushNamed(context, '/thrift');
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        title: Text(
                          'Log Out',
                          style: TextStyle(
                            fontFamily: 'Gabriela-Regular',
                            fontSize: 18.0,
                          ),
                        ),
                        onTap: () {
                          Navigator.popAndPushNamed(context, '/logout');
                        },
                      ),
                    ),
                  ],
                );
              },
              icon: Icon(
                Icons.menu, // Use the menu icon from the Material Icons set
                color: Colors.black, // Set the color to black
                size: 50, // Set the size of the icon
              ),
            ),
          ),
        ],
      ),
    );
  }
}