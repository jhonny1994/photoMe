import 'package:photome/core/shared/providers.dart';
import 'package:photome/features/comments/domain/comment.dart';
import 'package:photome/features/comments/infurastructure/comments_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

final commentsProvider =
    FutureProvider.family<List<Comment>, int>((ref, postId) async {
  return ref.read(commentsRepositoryProvider).getComments(postId);
});

@riverpod
Stream<CommentInfo> commentsCount(CommentsCountRef ref, int postId) async* {
  final commentsStream = ref.read(commentsRepositoryProvider).comments;
  final userId = ref.read(supabaseClientProvider).auth.currentUser!.id;
  await for (final comments in commentsStream) {
    yield CommentInfo(
      hasCommented: comments.any(
        (comment) => comment.postId == postId && comment.profileId == userId,
      ),
      count: comments.where((comment) => comment.postId == postId).length,
      comments: comments.where((comment) => comment.postId == postId).toList(),
    );
  }
}
