import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/core/error_screen.dart';
import 'package:photome/core/loading_screen.dart';
import 'package:photome/core/providers.dart';
import 'package:photome/features/auth/providers.dart';
import 'package:photome/features/posts/application/posts_notifier.dart';
import 'package:photome/features/posts/presentation/add_post_screen.dart';
import 'package:photome/features/posts/presentation/wigets/actions_row.dart';
import 'package:photome/features/posts/presentation/wigets/avatar_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostsScreen extends ConsumerStatefulWidget {
  const PostsScreen({super.key});

  @override
  ConsumerState<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends ConsumerState<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postNotifierProvider);
    return Scaffold(
      drawer: Drawer(
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SizedBox(
              width: 100,
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: () => ref.read(authNotifierProvider.notifier).signOut(),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<Widget>(
                builder: (context) => const AddPostScreen(),
              ),
            ),
            icon: const Icon(Icons.add_a_photo),
          )
        ],
      ),
      body: posts.when(
        data: (data) => Padding(
          padding: const EdgeInsets.all(8),
          child: data.isEmpty
              ? const Center(
                  child: Text(
                    'There are no posts right now, add a post to start!',
                  ),
                )
              : ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final post = data[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AvatarImage(post.profile!.profileImage!),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '@${post.profile!.username}',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    timeago.format(post.createdAt!),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
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
                              image: CachedNetworkImageProvider(
                                ref.read(
                                  imageUrlProvider(
                                    userId: post.profileId,
                                    fileName: post.imageUrl,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ActionsRow(post: post),
                      ],
                    );
                  },
                ),
        ),
        error: (error, stackTrace) => ErrorScreen(message: 'failure $error'),
        loading: () => const LoadingScreen(),
      ),
    );
  }
}
