import 'package:missionland_app/feature/posts/domain/repository/post_repository.dart';

class ToggleLikeUseCase {
  final PostRepository repository;

  ToggleLikeUseCase({required this.repository});

  Future<void> call(String postId, bool isLiked) async {
    await repository.toggleLike(postId, isLiked);
  }
}