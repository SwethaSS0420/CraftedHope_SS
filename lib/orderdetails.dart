import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bottom.dart';
import 'top.dart';
import 'product_detail_page.dart'; 

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final String orderId;

  const OrderDetailsPage({Key? key, required this.orderData, required this.orderId}) : super(key: key);

  Future<Map<String, dynamic>> _fetchItemDetails(String? itemId) async {
    if (itemId == null) {
      throw Exception('Item ID is null');
    }
    DocumentSnapshot itemSnapshot = await FirebaseFirestore.instance.collection('orders').doc(itemId).get();
    if (itemSnapshot.exists) {
      return itemSnapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Item not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> orderItems = orderData['orderItems'];

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Gabriela-Regular'),
            ),
            SizedBox(height: 16),
            Text(
              'Total Amount: ₹${orderData['totalAmount']}',
              style: TextStyle(fontSize: 18, fontFamily: 'Gabriela-Regular'),
            ),
            SizedBox(height: 16),
            Text(
              'Order Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Gabriela-Regular'),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: orderItems.length,
                itemBuilder: (context, index) {
                  var orderItem = orderItems[index];
                  String? itemId = orderItem?['orderId']; // Ensure itemId is not null
                  return FutureBuilder<Map<String, dynamic>>(
                    future: itemId != null ? _fetchItemDetails(itemId) : Future.error('Item ID is null'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return Center(child: Text('No item data found'));
                      } else {
                        var itemData = snapshot.data!;
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(product: itemData),
                              ),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      image: DecorationImage(
                                        image: NetworkImage(itemData['imageUrl']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          itemData['name'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Gabriela-Regular',
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Quantity: ${orderItem['quantity']}',
                                          style: TextStyle(fontSize: 14, fontFamily: 'Gabriela-Regular'),
                                        ),
                                        Text(
                                          'Size: ${itemData['size'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: 14, fontFamily: 'Gabriela-Regular'),
                                        ),
                                        Text(
                                          'Color: ${itemData['color'] ?? 'N/A'}',
                                          style: TextStyle(fontSize: 14, fontFamily: 'Gabriela-Regular'),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Price: ₹${itemData['price']}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Gabriela-Regular',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
