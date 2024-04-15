class User {
  final String id;
  final String firstName;
  final String lastName;
  final String bio;
  final String profileUrl;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.profileUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    
    return User(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      bio: json['bio'],
      profileUrl: json['profileUrl'],
    );
  }
}