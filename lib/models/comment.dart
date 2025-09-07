import 'user.dart';

class Comment {
  final String id;
  final String text;
  final User user;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.text,
    required this.user,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'user': user.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
