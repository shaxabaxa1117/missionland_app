

import 'package:missionland_app/feature/posts/data/datasource/post_remote_data_source.dart';
import 'package:missionland_app/feature/posts/data/model/post_model.dart';
import 'package:missionland_app/feature/posts/domain/entity/post_entity.dart';
import 'package:missionland_app/feature/posts/domain/repository/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addPost(Post post) async {
    final model = PostModel(
      id: post.id,
      imageUrl: post.imageUrl,
      description: post.description,
      createdAt: post.createdAt,
      userId: post.userId,
      userEmail: post.userEmail,
      likedBy: post.likedBy,
      thumbsUpBy: post.thumbsUpBy,
    );
    await remoteDataSource.addPost(model, post.imageUrl);
  }

  @override
  Future<List<Post>> getPosts() async {
    final models = await remoteDataSource.fetchPosts();
    return models;
  }

  @override
  Future<void> toggleLike(String postId, bool isLiked) async {
    await remoteDataSource.toggleLike(postId, isLiked);
  }

  @override
  Future<void> toggleThumbsUp(String postId, bool isThumbsUp) async {
    await remoteDataSource.toggleThumbsUp(postId, isThumbsUp);
  }
}