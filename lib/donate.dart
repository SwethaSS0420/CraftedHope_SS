import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dform.dart';
import 'bottom.dart';
import 'top.dart';
void main() {
  runApp(MaterialApp(
    home: Donate(),
  ));
}

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CraftedHope',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Gabriela-Regular',
          ),
        ),
        backgroundColor: Colors.white,
      ),
    body: WebView(
      initialUrl: url,
      javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class Donate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/people.png'), // Replace with your image
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "NGO's we have tie up with",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Gabriela-Regular'),
                ),
              ),
              ListTile(
                title: Text(
                  'CARE India',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontFamily: 'Gabriela-Regular',
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage('https://www.careindia.org/'),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Goonj',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontFamily: 'Gabriela-Regular',
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage('https://goonj.org/'),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Smile Foundation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontFamily: 'Gabriela-Regular',
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage('https://www.smilefoundationindia.org/'),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Cherish Foundation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontFamily: 'Gabriela-Regular',
                    
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage('https://www.cherishfoundation.org/'),
                    ),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DonationForm()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB99A45), // Set the button color
                ),
                child: Text(
                  'DONATE',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Gabriela-Regular',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(pageBackgroundColor: Colors.black,currentIndex: 0),
    );
  }
}
