import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path/path.dart';
import 'package:photome/core/providers.dart';
import 'package:photome/core/utils.dart';
import 'package:photome/features/posts/domain/post.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'post_repository.g.dart';

@riverpod
PostRepository postRepository(PostRepositoryRef ref) =>
    PostRepository(ref.read(supabaseClientProvider));

class PostRepository {
  PostRepository(this.client);

  final SupabaseClient client;

  RealtimeChannel get postsChannel => client.channel('publicPosts');

  Future<List<Post>> getPosts() async {
    final postsQuery = await client
        .from('posts')
        .select<List<Map<String, dynamic>>>(
          'id, caption, created_at, image_url, profiles (id, username, profile_image)',
        )
        .order('created_at');

    return postsQuery.map(Post.fromMap).toList();
  }

  Future<Either<String, void>> addPost(Post post) async {
    try {
      await client.from('posts').insert(post.toMap());
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, void>> deletePost(int postId, String imageUrl) async {
    try {
      await client.from('posts').delete().match({'id': postId});
      await deleteImage(imageUrl);
      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, void>> updatePost(Post post) async {
    try {
      await client.from('posts').update({
        'image_url': post.imageUrl,
        'caption': post.caption,
      }).match({'id': post.id});

      return right(null);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, String>> uploadImage(File image, String userId) async {
    try {
      final path =
          '$userId/${generateRandomString(20)}${extension(image.path)}';
      final upload = await client.storage.from('posts').upload(path, image);
      return right(upload);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<void> deleteImage(String imageUrl) =>
      client.storage.from('posts').remove([imageUrl.substring(6)]);
}
