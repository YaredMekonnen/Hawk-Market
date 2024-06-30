import 'package:flutter/widgets.dart';

@immutable
class User {
  final String id;
  final String username;
  final String email;
  final String bio;
  final String profileUrl;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.bio,
    required this.profileUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      bio: json['bio'],
      profileUrl: json['profileUrl'],
    );
  }
}
