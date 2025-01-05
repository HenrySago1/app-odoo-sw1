
class User {
  final int? id;
  final String name;
  final String? email;
  final String username;
  final String? image;

  User({
    this.id,
    required this.name,
    this.email,
    required this.username,
    this.image
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      username: json['email'],
      image: json['image_1920']
    );
  }
}
