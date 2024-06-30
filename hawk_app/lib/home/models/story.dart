import 'package:hawk_app/auth/models/user.dart';

class Story {
  final String id;
  final String name;
  final List<String> photos;
  final User owner;

  Story(
      {required this.id,
      required this.name,
      required this.photos,
      required this.owner});

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
        id: json['id'],
        name: json['name'],
        photos: List<String>.from(json['photos']),
        owner: User.fromJson(json['owner']));
  }
}
