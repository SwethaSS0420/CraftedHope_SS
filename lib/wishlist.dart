import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sls/goldtop.dart';
import 'bottom.dart';
import 'product_detail_page.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Goldtop(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Wishlist',
              style: TextStyle(
                fontFamily: 'Gabriela-Regular',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('wishlist')
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                var wishlistItems = snapshot.data!.docs.map((doc) {
                  return {
                    'id': doc.id,
                    ...doc.data() as Map<String, dynamic>,
                  };
                }).toList();

                if (wishlistItems.isEmpty) {
                  return Center(child: Text('Your wishlist is empty.'));
                }

                return ListView.builder(
                  itemCount: wishlistItems.length,
                  itemBuilder: (context, index) {
                    var product = wishlistItems[index];
                    return _buildWishlistItem(context, product);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget _buildWishlistItem(BuildContext context, Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 4,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                product['image'],
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      product['name'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,fontFamily: 'Gabriela-Regular'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Price: ₹${product['price']}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[800],fontFamily: 'Gabriela-Regular',),
                  ),
                  SizedBox(height: 8.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        _removeFromWishlist(product['id']);
                      },
                      icon: Icon(Icons.favorite, color: Colors.red),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeFromWishlist(String productId) {
    FirebaseFirestore.instance
        .collection('wishlist')
        .doc(productId)
        .delete()
        .then((_) => print('Item removed from wishlist'))
        .catchError((error) => print('Failed to remove item: $error'));
  }
}
