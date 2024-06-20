import 'package:flutter/material.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: Stack(
        children: [
          Positioned(
            left: 0,
            top: 35.0,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/about_us');
              },
            child: Image.asset(
              'assets/lg_whitebg.png',
              height: 60,
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
            top: 40.0,
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
              icon: Image.asset(
                'assets/lines.png',
                height: 30,
                width: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}