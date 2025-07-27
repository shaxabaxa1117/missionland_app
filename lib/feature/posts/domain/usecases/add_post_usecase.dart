


import 'package:missionland_app/feature/posts/domain/entity/post_entity.dart';
import 'package:missionland_app/feature/posts/domain/repository/post_repository.dart';

class AddPostUseCase {
  final PostRepository repository;

  AddPostUseCase({required this.repository});

  Future<void> call(Post post) async {
    await repository.addPost(post);
  }
}