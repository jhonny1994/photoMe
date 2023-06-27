import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/features/auth/providers.dart';
import 'package:photome/features/likes/providers.dart';
import 'package:photome/features/posts/application/posts_notifier.dart';
import 'package:photome/features/posts/domain/post.dart';
import 'package:photome/features/posts/presentation/edit_post_screen.dart';

class ActionsRow extends ConsumerWidget {
  const ActionsRow({required this.post, super.key});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesCount = ref.watch(likesCountProvider(post.id!));
    final likes = likesCount.asData?.value;
    final count = likes?.count ?? 0;
    final hasLiked = likes?.hasLiked ?? false;
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
            onPressed: likesCount.isLoading
                ? null
                : () => ref.read(likeNotifierProvider).toggleLike(post.id!),
            icon: Icon(
              hasLiked ? Icons.favorite : Icons.favorite_border,
              color: hasLiked ? Colors.red : null,
            ),
            label: Text(count.toString()),
          ),
          TextButton.icon(
            label: const Text(''),
            icon: const Icon(Icons.comment),
            onPressed: () {},
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
