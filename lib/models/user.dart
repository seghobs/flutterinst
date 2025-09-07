class User {
  final String id;
  final String username;
  final String? profilePicture;
  final String? fullName;

  User({
    required this.id,
    required this.username,
    this.profilePicture,
    this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      profilePicture: json['profile_picture'],
      fullName: json['full_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profile_picture': profilePicture,
      'full_name': fullName,
    };
  }
}
