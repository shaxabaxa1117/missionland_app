import 'package:missionland_app/feature/posts/domain/entity/post_entity.dart';

abstract class PostEvent {}

class AddPostEvent extends PostEvent {
  final Post post;

  AddPostEvent(this.post);
}

class LoadPostsEvent extends PostEvent {}

class ToggleLikeEvent extends PostEvent {
  final String postId;
  final bool isLiked;

  ToggleLikeEvent(this.postId, this.isLiked);
}

class ToggleThumbsUpEvent extends PostEvent {
  final String postId;
  final bool isThumbsUp;

  ToggleThumbsUpEvent(this.postId, this.isThumbsUp);
}