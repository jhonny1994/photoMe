import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/core/presentation/error_screen.dart';
import 'package:photome/core/presentation/loading_screen.dart';
import 'package:photome/core/shared/providers.dart';
import 'package:photome/features/comments/providers.dart';
import 'package:photome/features/posts/presentation/wigets/actions_row.dart';
import 'package:photome/features/posts/presentation/wigets/avatar_image.dart';
import 'package:photome/features/posts/providers.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostScreen extends ConsumerWidget {
  const PostScreen({required this.postId, super.key});
  final int postId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getPost = ref.watch(postProvider(postId));
    final comments =
        ref.watch(commentsCountProvider(postId)).asData?.value.comments;
    return Scaffold(
      appBar: AppBar(),
      body: getPost.when(
        data: (post) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AvatarImage(
                    ref.read(
                      imageUrlProvider(
                        userId: post.profileId,
                        fileName: post.profile!.profileImage!,
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
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          timeago.format(post.createdAt!),
                          style: Theme.of(context).textTheme.bodySmall,
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
              const Divider(),
              // TODO(jhonny1994):  finish the comments section or make it a bottomesheet
              if (comments != null)
                comments.isEmpty
                    ? const Text('There are no comments for this post yet.')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: comments.length,
                        itemBuilder: (context, index) => ListTile(
                          dense: true,
                          title: Text(comments.elementAt(index).profileId),
                          subtitle: Text(comments.elementAt(index).content),
                          trailing: comments.elementAt(index).profileId ==
                                  ref
                                      .read(supabaseClientProvider)
                                      .auth
                                      .currentUser!
                                      .id
                              ? const Icon(Icons.delete)
                              : null,
                        ),
                      )
              else
                Container(),
            ],
          ),
        ),
        error: (error, stackTrace) => ErrorScreen(message: error.toString()),
        loading: () => const LoadingScreen(),
      ),
    );
  }
}
