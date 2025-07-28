import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:missionland_app/feature/videos/presentation/controller/video_provider.dart';
import 'package:provider/provider.dart';
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
        actions: [
          // Галочка в AppBar
          Consumer<VideoProvider>(
            builder: (context, videoProvider, child) {
              final isWatched = videoProvider.isVideoWatched(videoIndex);
              return IconButton(
                icon: Icon(
                  isWatched ? Icons.check_circle : Icons.check_circle_outline,
                  color: Colors.white,
                ),
                onPressed: () {
                  videoProvider.toggleVideoWatched(videoIndex);
                },
              );
            },
          ),
        ],
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
            child: Consumer<VideoProvider>(
              builder: (context, videoProvider, child) {
                final videoText = videoProvider.getVideoText(videoIndex);
                final isWatched = videoProvider.isVideoWatched(videoIndex);
                
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Индикатор просмотра
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isWatched ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: isWatched ? Colors.green : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isWatched ? 'Watched' : 'Not Watched',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isWatched ? Colors.green : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Текст видео
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            videoText,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Кнопка для переключения статуса
                      ElevatedButton.icon(
                        onPressed: () {
                          videoProvider.toggleVideoWatched(videoIndex);
                        },
                        icon: Icon(
                          isWatched ? Icons.remove_done : Icons.done,
                          color: Colors.white,
                        ),
                        label: Text(
                          isWatched ? 'Not Done' : 'Done',
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isWatched ? Colors.orange : Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}