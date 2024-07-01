import 'package:flutter/material.dart';
import 'package:sls/goldtop.dart';
import 'bottom.dart';
import 'product_detail_page.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final String orderId;

  const OrderDetailsPage({Key? key, required this.orderData, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic>? orderItems = orderData['orderItems'];
    print("Order Items: $orderItems");

    if (orderItems == null || orderItems.isEmpty) {
      return Scaffold(
        appBar: Goldtop(),
        body: Center(
          child: Text(
            'No items in this order',
            style: TextStyle(fontSize: 18, fontFamily: 'Gabriela-Regular'),
          ),
        ),
        bottomNavigationBar: BottomNavigation(pageBackgroundColor: Colors.white,currentIndex: 0),
      );
    }

    return Scaffold(
      appBar: Goldtop(),
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
                  print("Order Item: $orderItem");
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(product: orderItem),
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
                                  image: NetworkImage(orderItem['image']),
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
                                    orderItem['name'],
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
                                    'Size: ${orderItem['size'] ?? 'N/A'}',
                                    style: TextStyle(fontSize: 14, fontFamily: 'Gabriela-Regular'),
                                  ),
                                  Text(
                                    'Color: ${orderItem['color'] ?? 'N/A'}',
                                    style: TextStyle(fontSize: 14, fontFamily: 'Gabriela-Regular'),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Price: ₹${orderItem['price']-orderItem['discount']}',
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
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(pageBackgroundColor: Colors.white,currentIndex: 0),
    );
  }
}
