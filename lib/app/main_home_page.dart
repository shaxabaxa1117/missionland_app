import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:missionland_app/app/drawer/custom_drawer.dart';
import 'package:missionland_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:missionland_app/feature/posts/presentation/bloc/post_bloc.dart';
import 'package:missionland_app/feature/posts/presentation/bloc/post_event.dart';
import 'package:missionland_app/feature/posts/presentation/pages/post_list_page.dart';
import 'package:missionland_app/feature/videos/presentation/bloc/video_player_bloc.dart';
import 'package:missionland_app/feature/videos/presentation/pages/video_page.dart';

import 'package:missionland_app/injection_container.dart'; 

class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  final List<String> imageItems = const [
    'assets/top_scroll_images/sad_cloud.png',
    'assets/top_scroll_images/sun.png',
    'assets/top_scroll_images/sad_flower.png',
    'assets/top_scroll_images/water_waste.png',
    'assets/top_scroll_images/rubbish.png',
    'assets/top_scroll_images/lion.png',
    'assets/top_scroll_images/lamp.png',
    'assets/top_scroll_images/sad_cloud.png',
    'assets/top_scroll_images/sad_cloud.png',
    'assets/top_scroll_images/sad_cloud.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Main Home Page'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 96, 167, 224),
            height: 60.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => VideoPlayerBloc()
                              ..add(VideoPlayerLoadEvent(videoIndex: index + 1)),
                            child: VideoPage(videoIndex: index + 1),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        image: DecorationImage(
                          image: AssetImage(imageItems[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// ✅ Используем BlocProvider для PostListScreen
          Expanded(
            child: BlocProvider(
              create: (_) => sl<PostBloc>()..add(LoadPostsEvent()),
              child: const PostListScreen(),
            ),
          ),
        ],
      ),
    );
  }
}
