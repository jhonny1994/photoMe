import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/core/shared/providers.dart';
import 'package:photome/core/shared/utils.dart';
import 'package:photome/features/comments/domain/comment.dart';
import 'package:photome/features/posts/domain/post.dart';
import 'package:timeago/timeago.dart' as timeago;

// TODO(jhonny1994): add delete comment button and impliment adding comments
class CommentsScreen extends ConsumerWidget {
  const CommentsScreen(this.comments, this.post, {super.key});

  final List<Comment> comments;
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: comments.length,
              itemBuilder: (context, index) => ListTile(
                leading: Image.network(
                  ref.read(
                    imageUrlProvider(
                      userId: post.profileId,
                      fileName: post.profile!.profileImage!,
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    Text(
                      comments.elementAt(index).profile!.username!,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    smallGap(
                      context,
                      isHeight: false,
                    ),
                    Text(
                      timeago.format(
                        comments.elementAt(index).createdAt!,
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ),
                subtitle: Text(
                  comments.elementAt(index).content,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            horizontalTitleGap: 0,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            title: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Add a comment',
                border: OutlineInputBorder(),
              ),
            ),
            trailing: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
