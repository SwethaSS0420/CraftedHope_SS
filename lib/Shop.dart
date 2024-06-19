import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'top.dart';
import 'bottom.dart';
import 'product_detail_page.dart';

class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  String _sortOption = 'Low to High';
  String searchQuery = '';
  String selectedFilter = 'All';
  bool isSearching = false; // Flag to indicate if user is currently searching

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), 
      // Your custom app bar
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                
                Container(
                  width: 150, // Adjust the width as needed
                  decoration: BoxDecoration(
                    color: Color(0xFFB99A45), // Background color for the dropdown
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: DropdownButton<String>(
                    value: _sortOption,
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          'Price: Low to High',
                          style: TextStyle(color: Colors.black),
                        ),
                        value: 'Low to High',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Price: High to Low',
                          style: TextStyle(color: Colors.black),
                        ),
                        value: 'High to Low',
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _sortOption = value!;
                      });
                    },
                    dropdownColor: Colors.white,
                    iconEnabledColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    underline: Container(),
                  ),
                ),
                if (!isSearching)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.white, // Set the color to white
                    ),
                  ),
                if (isSearching) // Show text field only if searching is active
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 8), // Adjust padding to move text field to the left of the search icon
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ),
                if (isSearching) // Show search button only if searching is active
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = false;
                        searchQuery = '';
                      });
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white, // Set the color to white
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                var products = snapshot.data!.docs.map((doc) {
                  return {
                    'name': doc['name'],
                    'image': doc['image'],
                    'designer': doc['designer'],
                    'color': doc['color'],
                    'sizes': List<String>.from(doc['sizes']),
                    'price': doc['price'] is num ? doc['price'] : int.tryParse(doc['price'].toString()) ?? 0.0,
                    'description': doc['description'],
                    'discount': doc['discount'],
                  };
                }).toList();

                // Filter products based on the search query
                products = products.where((product) {
                  final productName = product['name'].toString().toLowerCase();
                  return searchQuery.isEmpty || productName.contains(searchQuery.toLowerCase());
                }).toList();
                
                // Sort products based on the selected sorting option
                if (_sortOption == 'Low to High') {
                  products.sort((a, b) => a['price'].compareTo(b['price']));
                } else {
                  products.sort((a, b) => b['price'].compareTo(a['price']));
                }

                return GridView.builder(
                  padding: EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    int discountedPrice = products[index]['price'] - products[index]['discount'];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(product: products[index]),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 180,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),
                                    ),
                                    child: Image.network(
                                      products[index]['image'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Center(child: Icon(Icons.error));
                                      },
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    products[index]['name'],
                                    style: TextStyle(
                                      fontFamily: 'Gabriela-Regular',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    products[index]['designer'],
                                    style: TextStyle(
                                      fontFamily: 'Gabriela-Regular',
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Price: ₹${products[index]['price']}',
                                    style: TextStyle(
                                      fontFamily: 'Gabriela-Regular',
                                      decoration: products[index]['discount'] > 0 ? TextDecoration.lineThrough : null,
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (products[index]['discount'] > 0)
                                    Text(
                                      'Discounted Price: ₹${discountedPrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontFamily: 'Gabriela-Regular',
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),  
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
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
}
