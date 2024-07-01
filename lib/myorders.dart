import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sls/goldtop.dart';
import 'bottom.dart';
import 'orderdetails.dart';
import 'package:intl/intl.dart'; // For date formatting

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: Goldtop(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Debugging output for connection state
          print("Connection State: ${snapshot.connectionState}");
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Print the error message for debugging
            print("Error: ${snapshot.error}");
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No orders yet.'));
          }

          // Debugging output for number of orders fetched
          print("Orders fetched: ${snapshot.data!.docs.length}");

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var orderDoc = snapshot.data!.docs[index];
              var orderData = orderDoc.data() as Map<String, dynamic>;

              // Debugging output for each order data
              print("Order Data: $orderData");
              int totalAmount = orderData['totalAmount'];
              var orderDate = orderData['timestamp'].toDate();
              var formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(orderDate);

              return Card(
                margin: EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    leading: Image.asset(
                      'assets/cart.png', 
                      width: 50,
                      height: 50,
                    ),
                    title: Text(
                      'Order Date: $formattedDate',
                      style: TextStyle(
                        fontFamily: 'Gabriola',
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    subtitle: Text(
                      'Total Amount: ₹${totalAmount.toString()}',
                      style: TextStyle(
                        fontFamily: 'Gabriola',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OrderDetailsPage(
                              orderData: orderData,
                              orderId: orderDoc.id,
                            ),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(
                            orderData: orderData,
                            orderId: orderDoc.id,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigation(pageBackgroundColor: Colors.black,currentIndex: 0),
    );
  }
}
