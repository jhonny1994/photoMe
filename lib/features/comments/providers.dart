import 'package:photome/core/shared/providers.dart';
import 'package:photome/features/comments/domain/comment.dart';
import 'package:photome/features/comments/infurastructure/comments_repository.dart';
import 'package:photome/features/profile/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
Stream<CommentInfo?> commentsQuery(CommentsQueryRef ref, int postId) async* {
  final commentsStream = ref.read(commentsRepositoryProvider).comments;
  final userId = ref.read(supabaseClientProvider).auth.currentUser!.id;
  await for (final comments in commentsStream) {
    final profile = ref.watch(profileProvider(userId));
    if (profile.isLoading) {
      yield null;
    } else {
      final newComments = comments
          .map(
            (comment) => comment.copyWith(
              profile: profile.asData!.value,
            ),
          )
          .toList();
      yield CommentInfo(
        hasCommented: newComments.any(
          (comment) =>
              comment.postId == postId && comment.profile!.id == userId,
        ),
        count: newComments.where((comment) => comment.postId == postId).length,
        comments:
            newComments.where((comment) => comment.postId == postId).toList(),
      );
    }
  }
}
