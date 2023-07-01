import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/core/presentation/error_screen.dart';
import 'package:photome/core/presentation/loading_screen.dart';
import 'package:photome/core/shared/providers.dart';
import 'package:photome/core/shared/utils.dart';
import 'package:photome/features/posts/application/posts_notifier.dart';
import 'package:photome/features/posts/presentation/add_post_screen.dart';
import 'package:photome/features/posts/presentation/wigets/actions_row.dart';
import 'package:photome/features/posts/presentation/wigets/avatar_image.dart';
import 'package:photome/features/profile/presentation/profile_screen.dart';
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
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<Widget>(
              builder: (context) => ProfileScreen(
                profileId:
                    ref.read(supabaseClientProvider).auth.currentUser!.id,
              ),
            ),
          ),
          icon: const Icon(Icons.person),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<Widget>(
                builder: (context) => const AddPostScreen(),
              ),
            ),
          ),
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
                    return Column(
                      children: [
                        const Divider(height: 0),
                        smallGap(context),
                      ],
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final post = data[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<Widget>(
                                  builder: (context) => ProfileScreen(
                                    profileId: post.profile!.id,
                                  ),
                                ),
                              ),
                              child: AvatarImage(
                                ref.read(
                                  imageUrlProvider(
                                    userId: post.profileId,
                                    fileName: post.profile!.profileImage!,
                                  ),
                                ),
                              ),
                            ),
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
                        const SizedBox(height: 8),
                        CachedNetworkImage(
                          imageUrl: ref.read(
                            imageUrlProvider(
                              userId: post.profileId,
                              fileName: post.imageUrl,
                            ),
                          ),
                        ),
                        ActionsRow(post: post),
                      ],
                    );
                  },
                ),
        ),
        error: (error, stackTrace) => ErrorScreen(message: error.toString()),
        loading: () => const LoadingScreen(),
      ),
    );
  }
}
