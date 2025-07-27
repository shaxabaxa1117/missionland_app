import 'package:missionland_app/feature/posts/domain/entity/post_entity.dart';

class PostModel extends Post {
  PostModel({
    required super.id,
    required super.imageUrl,
    required super.description,
    required super.createdAt,
    required super.userId,
    required super.userEmail,
    required super.likedBy,
    required super.thumbsUpBy,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as String,
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      userId: map['userId'] as String,
      userEmail: map['userEmail'] as String?,
      likedBy: List<String>.from(map['likedBy'] ?? []),
      thumbsUpBy: List<String>.from(map['thumbsUpBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
      'userEmail': userEmail,
      'likedBy': likedBy,
      'thumbsUpBy': thumbsUpBy,
    };
  }

  PostModel copyWith({
    String? id,
    String? imageUrl,
    String? description,
    DateTime? createdAt,
    String? userId,
    String? userEmail,
    List<String>? likedBy,
    List<String>? thumbsUpBy,
  }) {
    return PostModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      likedBy: likedBy ?? this.likedBy,
      thumbsUpBy: thumbsUpBy ?? this.thumbsUpBy,
    );
  }
}