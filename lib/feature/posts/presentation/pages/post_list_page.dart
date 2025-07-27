import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:missionland_app/feature/posts/presentation/bloc/post_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:missionland_app/feature/posts/presentation/bloc/post_event.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;


    return Scaffold(
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            if (state.posts.isEmpty) {
              return const Center(child: Text('No posts yet. Be first!'));
            }
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                final isLiked = userId != null && post.likedBy.contains(userId);
                final isThumbsUp = userId != null && post.thumbsUpBy.contains(userId);

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.green),
                          Text(
                            post.userEmail ?? 'Unknown User',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(
                          maxHeight: 400,
                        ),
                        child: Image.network(
                          post.imageUrl,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          post.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Published: ${post.createdAt.toString().substring(0, 16)}',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isLiked ? Icons.favorite : Icons.favorite_border,
                                    color: isLiked ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: () {
                                    context.read<PostBloc>().add(
                                          ToggleLikeEvent(post.id, isLiked),
                                        );
                                  },
                                ),
                                Text('${post.likedBy.length}'),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isThumbsUp ? Icons.thumb_up : Icons.thumb_up_outlined,
                                    color: isThumbsUp ? Colors.blue : Colors.grey,
                                  ),
                                  onPressed: () {
                                    context.read<PostBloc>().add(
                                          ToggleThumbsUpEvent(post.id, isThumbsUp),
                                        );
                                  },
                                ),
                                Text('${post.thumbsUpBy.length}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is PostError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<PostBloc>().add(LoadPostsEvent()),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No data'));
        },
      ),
    );
  }
}