import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:missionland_app/feature/videos/presentation/bloc/video_player_bloc.dart';
import 'package:video_player/video_player.dart';


class VideoPage extends StatelessWidget {
  final int videoIndex;

  const VideoPage({super.key, required this.videoIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video $videoIndex'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          /// Видео с фиксированным соотношением 2:1
          Expanded(
            flex: 2,
            child: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
              builder: (context, state) {
                if (state is VideoPlayerLoading) {
                  return const AspectRatio(
                    aspectRatio: 5,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is VideoPlayerLoaded) {
                  final controller = state.videoController;
            
                  if (!controller.value.isInitialized) {
                    return const AspectRatio(
                      aspectRatio: 2,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
            
                  return GestureDetector(
                    onTap: () {
                      context.read<VideoPlayerBloc>().add(TogglePlayPauseEvent());
                    },
                    child: AspectRatio(
                      aspectRatio: 2,
                      child: VideoPlayer(controller),
                    ),
                  );
                } else if (state is VideoPlayerError) {
                  return AspectRatio(
                    aspectRatio: 2,
                    child: Center(child: Text('Ошибка: ${state.message}')),
                  );
                } else {
                  return const AspectRatio(
                    aspectRatio: 2,
                    child: SizedBox.shrink(),
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 16),

          /// Текст на оставшейся части экрана
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Video content for video $videoIndex',
                style: const TextStyle(fontSize: 24, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
