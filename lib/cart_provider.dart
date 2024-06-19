import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class CartProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  Future<void> fetchCartItems(String userId) async {
    try {
      var snapshot = await _firestore.collection('carts').doc(userId).get();
      if (snapshot.exists) {
        _items = List<Map<String, dynamic>>.from(snapshot.data()!['items']);
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  Future<void> saveCartItems(String userId) async {
    try {
      await _firestore.collection('carts').doc(userId).set({'items': _items});
    } catch (e) {
      print('Error saving cart items: $e');
    }
  }

Future<void> clearCartAndPlaceOrder(String userId, int totalAmount) async {
  try {
    // Save the current cart items to orders collection
    await _firestore.collection('orders').add({
      'userId': userId,
      'orderItems': _items,
      'totalAmount': totalAmount, // Ensure this is correctly passed and stored
      'timestamp': Timestamp.now(),
    });

    // Clear the cart items after placing the order
    await _firestore.collection('carts').doc(userId).delete();
    _items.clear();
    notifyListeners();
  } catch (error) {
    print('Error clearing cart and placing order: $error');
  }
}



  void addItem(Map<String, dynamic> product) {
    bool productExists = false;
    for (var item in _items) {
      if (item['name'] == product['name'] && item['size'] == product['size']) {
        item['quantity'] += product['quantity'];
        productExists = true;
        break;
      }
    }
    if (!productExists) {
      _items.add(product);
    }
    saveCartItems(FirebaseAuth.instance.currentUser!.uid);
    notifyListeners();
  }

  void removeItem(Map<String, dynamic> product) {
    _items.removeWhere((item) => item['name'] == product['name'] && item['size'] == product['size']);
    saveCartItems(FirebaseAuth.instance.currentUser!.uid);
    notifyListeners();
  }

  void reduceItem(Map<String, dynamic> product) {
    for (var item in _items) {
      if (item['name'] == product['name'] && item['size'] == product['size']) {
        if (item['quantity'] > 1) {
          item['quantity']--;
        } else {
          _items.remove(item);
        }
        break;
      }
    }
    saveCartItems(FirebaseAuth.instance.currentUser!.uid);
    notifyListeners();
  }

  void increaseItem(Map<String, dynamic> product) {
    for (var item in _items) {
      if (item['name'] == product['name'] && item['size'] == product['size']) {
        item['quantity']++;
        break;
      }
    }
    saveCartItems(FirebaseAuth.instance.currentUser!.uid);
    notifyListeners();
  }

  int get totalAmount {
    int total = 0;
    for (var item in _items) {
      int price = item['price'] ?? 0;
      int quantity = item['quantity'] ?? 0;
      int discount = item['discount'] ?? 0;
      total += ((price - discount) * quantity);
    }
    return total;
  }

  int get itemCount => _items.length;
}
