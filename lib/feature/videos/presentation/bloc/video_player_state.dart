part of 'video_player_bloc.dart';

sealed class VideoPlayerState extends Equatable {
  const VideoPlayerState();
  
  @override
  List<Object> get props => [];
}

final class VideoPlayerInitial extends VideoPlayerState {}

final class VideoPlayerLoading extends VideoPlayerState {}

final class VideoPlayerLoaded extends VideoPlayerState {
  final VideoPlayerController videoController;

  const VideoPlayerLoaded({required this.videoController});

  @override
  List<Object> get props => [videoController];
}

final class VideoPlayerError extends VideoPlayerState {
  final String message;

  const VideoPlayerError({required this.message});

  @override
  List<Object> get props => [message];
}