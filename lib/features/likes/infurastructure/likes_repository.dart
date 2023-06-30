import 'package:photome/core/shared/providers.dart';
import 'package:photome/features/likes/domain/like.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'likes_repository.g.dart';

@riverpod
LikesRepository likesRepository(LikesRepositoryRef ref) =>
    LikesRepository(ref.read(supabaseClientProvider));

class LikesRepository {
  LikesRepository(this.client);

  final SupabaseClient client;

  Stream<List<Like>> get likes =>
      client.from('likes').stream(primaryKey: ['id']).map(
        (event) => event.map(Like.fromMap).toList(),
      );

  Future<void> toggleLike(int postId) async {
    final userId = client.auth.currentUser!.id;
    try {
      final query = await client
          .from('likes')
          .select<List<Map<String, dynamic>>>()
          .eq('post_id', postId)
          .eq('profile_id', userId);
      if (query.isNotEmpty) {
        await client
            .from('likes')
            .delete()
            .eq('post_id', postId)
            .eq('profile_id', userId);
      } else {
        await client
            .from('likes')
            .insert(Like(postId: postId, profileId: userId).toMap());
      }
    } catch (e) {
      rethrow;
    }
  }
}
