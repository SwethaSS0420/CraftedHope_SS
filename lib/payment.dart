import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sls/cart_provider.dart';

import 'about.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CustomAppBar1 extends AppBar {
  CustomAppBar1({Key? key, String? title})
      : super(
          key: key,
          title: Text(title ?? "Payment"),
        );
}

class PaymentPage extends StatefulWidget {
  final int totalAmount;

  const PaymentPage({Key? key, required this.totalAmount}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentErrorResponse);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccessResponse);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWalletSelected);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _openCheckout() {
    if (_formKey.currentState!.validate()) {
      var options = {
        'key': 'rzp_live_ILgsfZCZoFIKMb',
        'amount': widget.totalAmount * 100, // Amount is in paise
        'name': 'CraftedHope',
        'description': 'Fine T-Shirt',
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'prefill': {
          'contact': _contactController.text,
          'email': 'test@razorpay.com',
        },
        'external': {
          'wallets': ['paytm']
        }
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        debugPrint('Error: $e');
      }
    }
  }

  void _handlePaymentErrorResponse(PaymentFailureResponse response) {
    _showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata: ${response.error.toString()}");
  }

  void _handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    _showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");

    // Navigate to order placed screen
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OrderPlacedScreen(),
        ),
      );
    });
  }

  void _handleExternalWalletSelected(ExternalWalletResponse response) {
    _showAlertDialog(context, "External Wallet Selected",
        "${response.walletName}");
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        ElevatedButton(
          child: const Text("Continue"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _handleCOD() {
    if (_formKey.currentState!.validate()) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      Provider.of<CartProvider>(context, listen: false).clearCartAndPlaceOrder(userId, widget.totalAmount);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OrderPlacedScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Delivering to',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    labelText: 'Contact',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _openCheckout,
                  child: Text(
                    'Pay with RazorPay',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Gabriela-Regular',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB99A45), // Set the button color
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _handleCOD,
                  child: Text(
                    'Cash On Delivery',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Gabriela-Regular',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB99A45), // Set the button color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderPlacedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Delayed navigation logic
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AboutUsPage(),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Placed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'Order Placed Successfully!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
