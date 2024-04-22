class Product {
  final String name;
  final String description;
  final num price;
  final List<String> images;
  final String tags;

  Product({
    required this.name, 
    required this.description, 
    required this.price, 
    required this.images, 
    required this.tags
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      description: json['description'],
      price: json['price'],
      images: List<String>.from(json['photos']),
      tags: json['tags']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "price": price,
      "photos": images,
      "tags": tags
    };
  }
}