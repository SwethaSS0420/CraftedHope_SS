import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'top.dart';
import 'bottom.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailPage({required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String? selectedSize;
  int quantity = 1;

  void addToCart() {
    if (selectedSize != null) {
      final productWithDetails = {
        ...widget.product,
        'size': selectedSize,
        'quantity': quantity,
      };
      Provider.of<CartProvider>(context, listen: false).addItem(productWithDetails);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to cart'),
          duration: Duration(seconds: 2),
        ),
      );

      setState(() {
        selectedSize = null;
        quantity = 1;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a size.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    int discountedPrice = widget.product['price'] - widget.product['discount'] ;

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(
                    widget.product['image'],
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Icon(Icons.error));
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.product['name'],
                style: TextStyle(
                  fontFamily: 'Gabriela-Regular',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Designer: ${widget.product['designer']}',
                style: TextStyle(
                  fontFamily: 'Gabriela-Regular',
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Color: ${widget.product['color']}',
                style: TextStyle(
                  fontFamily: 'Gabriela-Regular',
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Price: ₹${widget.product['price'].toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: 'Gabriela-Regular',
                  fontSize: 16,
                  color: Colors.white70,
                  decoration: widget.product['discount'] > 0 ? TextDecoration.lineThrough : null,
                ),
              ),
              if (widget.product['discount'] > 0)
                Text(
                  'Discounted Price: ₹${discountedPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontFamily: 'Gabriela-Regular',
                    fontSize: 16,
                    color: Colors.greenAccent,
                  ),
                ),
              SizedBox(height: 20),
              Text(
                'Description:',
                style: TextStyle(
                  fontFamily: 'Gabriela-Regular',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.product['description'],
                style: TextStyle(
                  fontFamily: 'Gabriela-Regular',
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Select Size:',
                style: TextStyle(
                  fontFamily: 'Gabriela-Regular',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              DropdownButton<String>(
                value: selectedSize,
                hint: Text(
                  'Choose Size',
                  style: TextStyle(color: Colors.white70),
                ),
                items: widget.product['sizes'].map<DropdownMenuItem<String>>((size) {
                  return DropdownMenuItem<String>(
                    value: size,
                    child: Text(size),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSize = value;
                  });
                },
                dropdownColor: Colors.black,
                style: TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, color: Colors.white),
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                  ),
                  Text(
                    '$quantity',
                    style: TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: addToCart,
                  child: Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB99A45),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(pageBackgroundColor: Colors.black,currentIndex: 0),   
    );
  }
}
