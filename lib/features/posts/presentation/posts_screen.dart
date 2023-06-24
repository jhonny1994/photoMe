import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/core/loading_screen.dart';
import 'package:photome/core/providers.dart';
import 'package:photome/core/test_screen.dart';
import 'package:photome/features/posts/domain/post.dart';
import 'package:photome/features/posts/presentation/actions_row.dart';
import 'package:photome/features/posts/presentation/avatar_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostsScreen extends ConsumerWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: posts.when(
        data: (data) => ListView.separated(
          itemCount: data.length,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
          itemBuilder: (BuildContext context, int index) {
            final post = data[index];
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AvatarImage(post.profile.profileImage!),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '@${post.profile.username}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              timeago.format(post.createdAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(Icons.more_horiz),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(post.caption),
                  Container(
                    height: 200,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(post.imageUrl),
                      ),
                    ),
                  ),
                  ActionsRow(post: post),
                ],
              ),
            );
          },
        ),
        error: (error, stackTrace) => TestScreen(message: 'failure $error'),
        loading: () => const LoadingScreen(),
      ),
    );
  }
}
