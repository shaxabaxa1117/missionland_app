import 'package:missionland_app/feature/posts/domain/repository/post_repository.dart';

class ToggleThumbsUpUseCase {
  final PostRepository repository;

  ToggleThumbsUpUseCase({required this.repository});

  Future<void> call(String postId, bool isThumbsUp) async {
    await repository.toggleThumbsUp(postId, isThumbsUp);
  }
}