import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/features/comments/infurastructure/comments_repository.dart';

class CommentsScreen extends ConsumerWidget {
  const CommentsScreen(this.postId, {super.key});

  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comments = ref.watch(commentsRepositoryProvider).getComments(postId);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder(
          future: comments,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final comments = snapshot.data!;
              return ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(comments.elementAt(index).content),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
