

import 'package:missionland_app/feature/posts/domain/entity/post_entity.dart';



abstract class PostRepository {
  Future<void> addPost(Post post);
  Future<List<Post>> getPosts();
  Future<void> toggleLike(String postId, bool isLiked);
  Future<void> toggleThumbsUp(String postId, bool isThumbsUp);
}

