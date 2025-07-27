class Post {
  final String id;
  final String imageUrl;
  final String description;
  final DateTime createdAt;
  final String userId;
  final String? userEmail;
  final List<String> likedBy; 
  final List<String> thumbsUpBy; 

  Post({
    required this.id,
    required this.imageUrl,
    required this.description,
    required this.createdAt,
    required this.userId,
    required this.userEmail,
    required this.likedBy,
    required this.thumbsUpBy,
  });
}
