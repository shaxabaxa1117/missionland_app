import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

part 'video_player_event.dart';
part 'video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  VideoPlayerController? _controller;

  VideoPlayerBloc() : super(VideoPlayerInitial()) {
    on<VideoPlayerLoadEvent>(_onLoadVideo);
    on<TogglePlayPauseEvent>(_onTogglePlayPause);
  }

  Future<void> _onLoadVideo(
    VideoPlayerLoadEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(VideoPlayerLoading());

    try {
      _controller = VideoPlayerController.asset(
        'assets/videos/video_${event.videoIndex}.mp4',
      );

      await _controller!.initialize();
      _controller!.play();

      emit(VideoPlayerLoaded(videoController: _controller!));
    } catch (error) {
      emit(VideoPlayerError(message: error.toString()));
    }
  }

  Future<void> _onTogglePlayPause(
    TogglePlayPauseEvent event,
    Emitter<VideoPlayerState> emit,
  ) async {
    if (_controller != null && _controller!.value.isInitialized) {
      if (_controller!.value.isPlaying) {
        await _controller!.pause();
      } else {
        await _controller!.play();
      }

      emit(
        VideoPlayerLoaded(videoController: _controller!),
      ); // триггерим rebuild
    }
  }

  @override
  Future<void> close() async {
    await _controller?.dispose(); // 🧼 освобождаем ресурсы
    return super.close();
  }
}
