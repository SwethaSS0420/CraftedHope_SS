import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';  
import 'cart_provider.dart';
import 'login.dart';
import 'about.dart';
import 'donate.dart';
import 'dform.dart';
import 'Shop.dart';
import 'recycle.dart';
import 'rform.dart';
import 'thrift.dart';
import 'sell.dart';
import 'buy.dart';
import 'logout.dart';
import 'pwd.dart';
import 'mydetails.dart';
import 'cart.dart';
import 'cart_provider.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MyApp(),
    ),
    
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CraftedHope',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Set initial route
      routes: {
        '/': (context) => SplashScreen(),
        '/about_us': (context) => AboutUsPage(),
        '/Donate': (context) => Donate(),
        '/dform': (context) => DonationForm(),
        '/shop': (context) => Shop(),
        '/recycle': (context) => rec(),
        '/rform': (context) => rform(),
        '/thrift': (context) => ThriftPage(),
        '/logout': (context) => LogoutPage(),
        '/myaccount': (context) => MyDetailsPage(),
        '/login': (context) => LoginPage(),
        '/cart': (context) => CartPage(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/login');
    });

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Path to your logo image
        ),
      ),
    );
  }
}