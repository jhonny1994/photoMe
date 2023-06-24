import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/features/posts/domain/like.dart';
import 'package:photome/features/posts/domain/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostsNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  PostsNotifier(this.client) : super(const AsyncValue.loading()) {
    getPosts();
  }

  final SupabaseClient client;

  Future<void> getPosts() async {
    state = const AsyncValue.loading();

    final postsQuery = await client
        .from('posts')
        .select<List<Map<String, dynamic>>>(
          'id, caption, created_at, image_url, profiles (id, username, profile_image)',
        )
        .order('created_at');

    final likesQuery = await client
        .from('likes')
        .select<List<Map<String, dynamic>>>(
          'id, created_at, post_id, profile_id',
        )
        .order('created_at');

    final likes = likesQuery.map(Like.fromMap).toList();

    final posts = postsQuery
        .map(
          (e) => Post.fromMap(e)
            ..likes =
                likes.where((element) => element.postId == e['id']).toList(),
        )
        .toList();

    state = AsyncValue.data(posts);
  }
}
