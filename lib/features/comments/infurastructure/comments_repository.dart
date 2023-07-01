import 'package:dartz/dartz.dart';
import 'package:photome/core/shared/providers.dart';
import 'package:photome/features/comments/domain/comment.dart';
import 'package:photome/features/profile/domain/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'comments_repository.g.dart';

@riverpod
CommentsRepository commentsRepository(CommentsRepositoryRef ref) =>
    CommentsRepository(ref.read(supabaseClientProvider));

class CommentsRepository {
  CommentsRepository(this.client);

  final SupabaseClient client;

  Stream<List<Comment>> get comments => client
      .from('comments')
      .stream(primaryKey: ['id'])
      .order('created_at')
      .map(
        (event) => event.map(Comment.fromMap).toList(),
      );

  Future<Either<String, void>> addComment(
    int postId,
    Profile profile,
    String content,
  ) async {
    try {
      await client.from('comments').insert(
            Comment(
              postId: postId,
              profile: profile,
              content: content,
            ).toMap(),
          );
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, void>> deleteComment(int commentId) async {
    try {
      await client.from('comments').delete().match({'id': commentId});
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }
}
