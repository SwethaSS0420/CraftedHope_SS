class Product {
  final String name;
  final String image;
  final String designer;
  final String color;
  final List<String> sizes;
  final String description;
  final int price;
  final int discount;

  Product({
    required this.name,
    required this.image,
    required this.designer,
    required this.color,
    required this.sizes,
    required this.description,
    required this.price,
    required this.discount,
  });

  factory Product.fromFirestore(Map<String, dynamic> data) {
    return Product(
      name: data['name'],
      image: data['image'],
      designer: data['designer'],
      color: data['color'],
      sizes: List<String>.from(data['sizes']),
      description: data['description'],
      price: data['price'].toDouble(),
      discount: data['discount'].toDouble(),
    );
  }
}
