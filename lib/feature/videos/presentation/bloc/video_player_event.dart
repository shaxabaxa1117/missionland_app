part of 'video_player_bloc.dart';

sealed class VideoPlayerEvent extends Equatable {
  const VideoPlayerEvent();

  @override
  List<Object> get props => [];
}

final class VideoPlayerLoadEvent extends VideoPlayerEvent {
  final int videoIndex;

  const VideoPlayerLoadEvent({required this.videoIndex});

}
final class TogglePlayPauseEvent extends VideoPlayerEvent {}
