import 'package:missionland_app/feature/posts/domain/entity/post_entity.dart';
import 'package:missionland_app/feature/posts/domain/repository/post_repository.dart';

class GetPostsUseCase {
  final PostRepository repository;

  GetPostsUseCase({required this.repository});

  Future<List<Post>> call() async {
    return await repository.getPosts();
  }
}