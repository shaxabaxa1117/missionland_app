import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:missionland_app/feature/posts/data/datasource/image_upload_service.dart';
import 'package:missionland_app/feature/posts/data/model/post_model.dart';

abstract class PostRemoteDataSource {
  Future<void> addPost(PostModel post);
  Future<List<PostModel>> fetchPosts();
  Future<void> toggleLike(String postId, bool isLiked);
  Future<void> toggleThumbsUp(String postId, bool isThumbsUp);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final FirebaseFirestore firestore;
  final ImageUploadService imageUploadService;

  PostRemoteDataSourceImpl({
    required this.firestore,
    required this.imageUploadService,
  });

  @override
  Future<void> addPost(PostModel post) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await firestore.collection('posts').doc(post.id).set(post.toMap());
    } catch (e) {
      throw Exception('Failed to add post: $e');
    }
  }

  @override
  Future<List<PostModel>> fetchPosts() async {
    try {
      final snapshot =
          await firestore
              .collection('posts')
              .orderBy('createdAt', descending: true)
              .get();
      return snapshot.docs.map((doc) => PostModel.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  @override
  Future<void> toggleLike(String postId, bool isLiked) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final postRef = firestore.collection('posts').doc(postId);
      if (isLiked) {
        await postRef.update({
          'likedBy': FieldValue.arrayRemove([userId]),
        });
      } else {
        await postRef.update({
          'likedBy': FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }

  @override
  Future<void> toggleThumbsUp(String postId, bool isThumbsUp) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final postRef = firestore.collection('posts').doc(postId);
      if (isThumbsUp) {
        await postRef.update({
          'thumbsUpBy': FieldValue.arrayRemove([userId]),
        });
      } else {
        await postRef.update({
          'thumbsUpBy': FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      throw Exception('Failed to toggle thumbs-up: $e');
    }
  }
}
