import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/core/shared/providers.dart';
import 'package:photome/core/shared/utils.dart';
import 'package:photome/features/comments/domain/comment.dart';
import 'package:photome/features/comments/infurastructure/comments_repository.dart';
import 'package:photome/features/posts/domain/post.dart';
import 'package:photome/features/profile/infurastructure/profile_repository.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentsScreen extends ConsumerStatefulWidget {
  const CommentsScreen({
    required this.comments,
    required this.post,
    super.key,
  });

  final List<Comment> comments;
  final Post post;

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final comment = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
              itemCount: widget.comments.length,
              itemBuilder: (context, index) => Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) async {
                  final operation =
                      await ref.read(commentsRepositoryProvider).deleteComment(
                            widget.comments.elementAt(index).id!,
                          );
                  operation.fold(
                    (l) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l),
                      ),
                    ),
                    (r) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Comment deleted successfully'),
                      ),
                    ),
                  );
                },
                direction: widget.comments.elementAt(index).profile!.id !=
                        ref.read(supabaseClientProvider).auth.currentUser!.id
                    ? DismissDirection.none
                    : DismissDirection.endToStart,
                child: ListTile(
                  leading: Image.network(
                    ref.read(
                      imageUrlProvider(
                        userId: widget.comments.elementAt(index).profile!.id,
                        fileName: widget.comments
                            .elementAt(index)
                            .profile!
                            .profileImage!,
                      ),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.comments.elementAt(index).profile!.username!,
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
                          widget.comments.elementAt(index).createdAt!,
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    widget.comments.elementAt(index).content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            horizontalTitleGap: 0,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            title: Form(
              key: formKey,
              child: TextFormField(
                controller: comment,
                readOnly: isLoading,
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Add a comment',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            trailing: InkWell(
              onTap: isLoading
                  ? null
                  : () async {
                      if (formKey.currentState?.validate() ?? false) {
                        setState(() {
                          isLoading = !isLoading;
                        });
                        final operation = await ref
                            .read(commentsRepositoryProvider)
                            .addComment(
                              widget.post.id!,
                              await ref
                                  .read(profileRepositoryProvider)
                                  .currentUserProfile,
                              comment.text.trim(),
                            );
                        operation.fold(
                          (l) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l),
                            ),
                          ),
                          (r) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Comment added successfully'),
                              ),
                            );
                          },
                        );
                        setState(() {
                          isLoading = !isLoading;
                        });
                      }
                    },
              child: const Icon(Icons.save),
            ),
          ),
        ],
      ),
    );
  }
}
