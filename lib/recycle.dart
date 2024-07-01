import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'bottom.dart';
import 'top.dart';
import 'rform.dart';
void main() {
  runApp(MaterialApp(
    home: rec(),
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


class rec extends StatelessWidget {
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
              Image.asset('assets/r1.png'), // Replace with your image
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "We have tie-up with",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Gabriela-Regular'),
                ),
              ),
              ListTile(
                title: Text(
                  'SMART Association',
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
                      builder: (context) => WebViewPage('https://smartassociations.in/'),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Planet Aid',
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
                      builder: (context) => WebViewPage('https://www.planetaid.org/'), 
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'worn again technologies',
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
                      builder: (context) => WebViewPage('https://wornagain.co.uk/'),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'evrnu',
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
                      builder: (context) => WebViewPage('https://www.evrnu.com/'),
                    ),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => rform()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB99A45), // Set the button color
                ),
                child: Text(
                  'RECYCLE NOW',
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
