import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sls/top.dart';
import 'cart_provider.dart';
import 'bottom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'payment.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Fetch cart items for the logged-in user
      Provider.of<CartProvider>(context, listen: false).fetchCartItems(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: CustomAppBar(),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (user == null) {
            return Center(
              child: Text(
                'Please log in to view your cart',
                style: TextStyle(fontSize: 24),
              ),
            );
          }

          if (cart.items.isEmpty) {
            return Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 24),
              ),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.itemCount,
                    itemBuilder: (context, index) {
                      var item = cart.items[index];
                      int price = item['price'] ?? 0;
                      int quantity = item['quantity'] ?? 0;
                      int discount = item['discount'] ?? 0;
                      int discountedAmount = discount * quantity;
                      int itemTotal = (price * quantity) - discountedAmount;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  item['image'],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error);
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Quantity: $quantity'),
                                    Text('Size: ${item['size'] ?? 'N/A'}'),
                                    Text('Amount: ₹${itemTotal.toStringAsFixed(2)}'),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      Provider.of<CartProvider>(context, listen: false).increaseItem(item);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      Provider.of<CartProvider>(context, listen: false).reduceItem(item);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      Provider.of<CartProvider>(context, listen: false).removeItem(item);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Total: ₹${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PaymentPage(totalAmount:cart.totalAmount)),
                            
                          );
                        },
                        child: Text('Proceed to Payment'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}