import 'package:hawk_app/auth/models/user.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final num price;
  final List<String> photos;
  final String tags;
  final User owner;
  final bool isBookmarked;
  final bool isOwn;
  final bool isStory;
  DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.photos,
    required this.tags,
    required this.owner,
    required this.isBookmarked,
    required this.isOwn,
    required this.isStory,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      photos: List<String>.from(json['photos']),
      owner: User.fromJson(json['owner']),
      tags: json['tags'],
      isBookmarked: json['isBookmarked'] ?? false,
      isOwn: json['isOwn'] ?? false,
      isStory: json['story'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "name": name,
      "description": description,
      "price": price,
      "photos": photos,
      "tags": tags
    };
  }
}
