import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:photome/core/shared/providers.dart';
import 'package:photome/core/shared/utils.dart';
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

  Future<Post> getPost(int postId) async {
    final postsQuery = await client
        .from('posts')
        .select<Map<String, dynamic>>(
          'id, caption, created_at, image_url, profiles (id, username, profile_image)',
        )
        .match({'id': postId}).single();
    return Post.fromMap(postsQuery);
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
      await deletePostImage(imageUrl);
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

  Future<Either<String, String>> uploadPostImage(
    File image,
    String userId,
  ) async {
    try {
      final upload = await uploadImage(
        bucket: 'posts',
        image: image,
        userId: userId,
        client: client,
      );
      return right(upload);
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<void> deletePostImage(String imageUrl) async {
    final index = imageUrl.indexOf('/');
    final imageName = imageUrl.substring(0, index);
    await deleteImage(
      bucket: 'posts',
      imageUrl: imageName,
      client: client,
    );
  }
}
