import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ThriftPage extends StatefulWidget {
  @override
  _ThriftPageState createState() => _ThriftPageState();
}

class _ThriftPageState extends State<ThriftPage> {
  String searchQuery = "";
  String selectedFilter = "All";
  final List<String> filters = ["All", "Color", "Type", "Size", "Price", "Condition"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thrift'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          _buildFeaturedItems(),
          Expanded(child: _buildProductListings()),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) => _buildFilterChip(filter)).toList(),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: selectedFilter == label,
        onSelected: (bool selected) {
          setState(() {
            selectedFilter = selected ? label : "All";
          });
        },
      ),
    );
  }

  Widget _buildFeaturedItems() {
    return Container(
      height: 150.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildFeaturedItem('Featured 1'),
          _buildFeaturedItem('Featured 2'),
          _buildFeaturedItem('Featured 3'),
        ],
      ),
    );
  }

  Widget _buildFeaturedItem(String label) {
    return Container(
      width: 100.0,
      margin: EdgeInsets.all(8.0),
      color: Colors.grey[300],
      child: Center(child: Text(label)),
    );
  }

  Widget _buildProductListings() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data!.docs.where((product) {
          final productName = product['name'].toString().toLowerCase();
          return selectedFilter == "All" || product[selectedFilter.toLowerCase()] != null;
        }).where((product) {
          final productName = product['name'].toString().toLowerCase();
          return searchQuery.isEmpty || productName.contains(searchQuery.toLowerCase());
        }).toList();

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: product),
                  ),
                );
              },
              child: _buildProductItem(product),
            );
          },
        );
      },
    );
  }

  Widget _buildProductItem(DocumentSnapshot product) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              product['image'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Icon(Icons.error));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product['name'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Price: \$${product['price']}'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: 'Search for items...'),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Search'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final DocumentSnapshot product;

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product['image']),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product['name'],
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Price: \$${product['price']}',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product['description'],
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Implement add to cart functionality
                },
                child: Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}