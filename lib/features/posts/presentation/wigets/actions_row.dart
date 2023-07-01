import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/features/auth/providers.dart';
import 'package:photome/features/comments/presentation/comments_screen.dart';
import 'package:photome/features/comments/providers.dart';
import 'package:photome/features/likes/infurastructure/likes_repository.dart';
import 'package:photome/features/likes/providers.dart';
import 'package:photome/features/posts/application/posts_notifier.dart';
import 'package:photome/features/posts/domain/post.dart';
import 'package:photome/features/posts/presentation/edit_post_screen.dart';

class ActionsRow extends ConsumerWidget {
  const ActionsRow({required this.post, super.key});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesQuery = ref.watch(likesQueryProvider(post.id!));
    final likesInfo = likesQuery.asData?.value;
    final likesCount = likesInfo?.count ?? 0;
    final hasLiked = likesInfo?.hasLiked ?? false;

    final commentsQuery = ref.watch(commentsQueryProvider(post.id!));
    final commentsInfo = commentsQuery.asData?.value;
    final commentsCount = commentsInfo?.count ?? 0;
    final hasCommented = commentsInfo?.hasCommented ?? false;
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: const IconThemeData(color: Colors.grey, size: 18),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.grey),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () => likesQuery.isLoading
                ? null
                : ref.read(likesRepositoryProvider).toggleLike(post.id!),
            icon: Icon(
              hasLiked ? Icons.favorite : Icons.favorite_border,
              color: hasLiked ? Colors.red : null,
            ),
            label: Text(likesCount.toString()),
          ),
          TextButton.icon(
            label: Text(commentsCount.toString()),
            icon: Icon(
              hasCommented ? Icons.comment : Icons.comment_outlined,
              color: hasCommented ? Colors.grey.shade800 : null,
            ),
            onPressed: commentsQuery.isLoading
                ? null
                : commentsInfo == null
                    ? null
                    : () => Navigator.of(context).push(
                          MaterialPageRoute<Widget>(
                            builder: (context) => CommentsScreen(
                              post: post,
                              comments: commentsInfo.comments,
                            ),
                          ),
                        ),
          ),
          if (post.profileId == ref.read(userProvider)!.id)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<Widget>(
                  builder: (context) => EditPostScreen(post),
                ),
              ),
            ),
          if (post.profileId == ref.read(userProvider)!.id)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final operation = await ref
                    .read(postNotifierProvider.notifier)
                    .deletePost(post.id!, post.imageUrl);
                operation.fold(
                  (l) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l),
                    ),
                  ),
                  (r) => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Post deleted successfully'),
                    ),
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
