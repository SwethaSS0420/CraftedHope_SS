import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:animations/animations.dart';
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
  int _currentImageIndex = 0;

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
    int discountedPrice = widget.product['price'] - widget.product['discount'];

    // Ensure images is a list of strings
    List<String> images = widget.product['productimages'] is List
        ? List<String>.from(widget.product['productimages'] ?? [])
        : [];

    // Debug print
    print("Images List: $images");
    print("Product Data: ${widget.product}");
    print("Images Field: ${widget.product['images']}");


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
                  child: Stack(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 200.0,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                        ),
                        items: images.isNotEmpty
                            ? images.map<Widget>((imageUrl) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Center(child: Icon(Icons.error, color: Colors.white));
                                      },
                                    );
                                  },
                                );
                              }).toList()
                            : [Center(child: Text("No images available", style: TextStyle(color: Colors.white)))],
                      ),
                      if (images.isNotEmpty)
                        Positioned(
                          bottom: 8.0,
                          left: 8.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: images.asMap().entries.map<Widget>((entry) {
                              int index = entry.key;
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentImageIndex == index
                                      ? Color.fromRGBO(0, 0, 0, 0.9)
                                      : Color.fromRGBO(0, 0, 0, 0.4),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.product['name'],
                style: TextStyle(
                  fontFamily: 'Gabriela-Regular',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Designer: ${widget.product['designer']}',
                style: TextStyle(
                  fontFamily: 'Gabriela-Regular',
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Color: ${widget.product['color']}',
                style: TextStyle(
                  fontFamily: 'Gabriela-Regular',
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Price: ₹${widget.product['price'].toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: 'Gabriela-Regular',
                  fontSize: 18,
                  color: Colors.white70,
                  decoration: widget.product['discount'] > 0 ? TextDecoration.lineThrough : null,
                ),
              ),
              if (widget.product['discount'] > 0)
                Text(
                  'Discounted Price: ₹${discountedPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontFamily: 'Gabriela-Regular',
                    fontSize: 18,
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
              Wrap(
                spacing: 8.0,
                children: (widget.product['sizes'] as List<String>).map<Widget>((size) {
                  return ChoiceChip(
                    label: Text(size),
                    selected: selectedSize == size,
                    onSelected: (selected) {
                      setState(() {
                        selectedSize = selected ? size : null;
                      });
                    },
                    selectedColor: Color(0xFFB99A45),
                    backgroundColor: Colors.white70,
                    labelStyle: TextStyle(color: Colors.black),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text(
                'Quantity:',
                style: TextStyle(
                  fontFamily: 'Gabriela-Regular',
                  fontSize: 20,
                  color: Colors.white,
                ),
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
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
              Divider(color: Colors.white24),
              SizedBox(height: 20),
              Text(
                'Ratings & Reviews:',
                style: TextStyle(
                  fontFamily: 'Gabriela-Regular',
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
              RatingBar.builder(
                initialRating: 4.5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  // Handle rating update
                },
              ),
              SizedBox(height: 16),
              Center(
                child: OpenContainer(
                  closedElevation: 0,
                  transitionType: ContainerTransitionType.fadeThrough,
                  closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  openBuilder: (context, _) {
                    return Scaffold(
                      appBar: AppBar(title: Text('Cart')),
                      body: Center(child: Text('Cart Page')),
                    );
                  },
                  closedBuilder: (context, openContainer) {
                    return ElevatedButton(
                      onPressed: addToCart,
                      child: Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB99A45),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        minimumSize: Size(double.infinity, 50), // Full-width button
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(pageBackgroundColor: Colors.black, currentIndex: 0),
    );
  }
}
