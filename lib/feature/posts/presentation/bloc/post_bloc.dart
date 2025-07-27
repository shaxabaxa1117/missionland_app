import 'package:bloc/bloc.dart';
import 'package:missionland_app/feature/posts/domain/entity/post_entity.dart';
import 'package:missionland_app/feature/posts/domain/usecases/add_post_usecase.dart';
import 'package:missionland_app/feature/posts/domain/usecases/get_posts_usecase.dart';
import 'package:missionland_app/feature/posts/domain/usecases/toggle_like_usecase.dart';
import 'package:missionland_app/feature/posts/domain/usecases/toggle_thumbs_up_usecase.dart';
import 'package:missionland_app/feature/posts/presentation/bloc/post_event.dart';


part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final AddPostUseCase addPost;
  final GetPostsUseCase getPosts;
  final ToggleLikeUseCase toggleLike;
  final ToggleThumbsUpUseCase toggleThumbsUp;

  PostBloc({
    required this.addPost,
    required this.getPosts,
    required this.toggleLike,
    required this.toggleThumbsUp,
  }) : super(PostInitial()) {
    on<AddPostEvent>(_onAddPost);
    on<LoadPostsEvent>(_onLoadPosts);
    on<ToggleLikeEvent>(_onToggleLike);
    on<ToggleThumbsUpEvent>(_onToggleThumbsUp);
  }

  Future<void> _onAddPost(AddPostEvent event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      await addPost(event.post);
      add(LoadPostsEvent());
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onLoadPosts(LoadPostsEvent event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      final posts = await getPosts();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onToggleLike(ToggleLikeEvent event, Emitter<PostState> emit) async {
    try {
      await toggleLike(event.postId, event.isLiked);
      add(LoadPostsEvent()); // Refresh posts after toggling
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  Future<void> _onToggleThumbsUp(ToggleThumbsUpEvent event, Emitter<PostState> emit) async {
    try {
      await toggleThumbsUp(event.postId, event.isThumbsUp);
      add(LoadPostsEvent()); // Refresh posts after toggling
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}