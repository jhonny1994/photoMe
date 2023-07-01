// ignore_for_file: avoid_dynamic_calls

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:photome/features/posts/domain/post.dart';
import 'package:photome/features/posts/infurastructure/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'posts_notifier.g.dart';

@riverpod
class PostNotifier extends _$PostNotifier {
  Future<Either<String, void>> addPost(Post post) async {
    return ref.read(postRepositoryProvider).addPost(post);
  }

  Future<Either<String, void>> deletePost(int postId, String imageUrl) async {
    return ref.read(postRepositoryProvider).deletePost(postId, imageUrl);
  }

  Future<Post> getPost(int postId) async {
    return ref.read(postRepositoryProvider).getPost(postId);
  }

  Future<List<Post>> getProfilePost(String profileId) async {
    return ref.read(postRepositoryProvider).getProfilePosts(profileId);
  }

  Future<int?> getProfilePostsCount(String profileId) async {
    return ref.read(postRepositoryProvider).getProfilePostsCount(profileId);
  }

  Future<Either<String, void>> updatePost(Post post) async {
    return ref.read(postRepositoryProvider).updatePost(post);
  }

  Future<Either<String, String>> uploadImage(File image, String userId) async {
    return ref.read(postRepositoryProvider).uploadPostImage(image, userId);
  }

  Future<void> deleteImage(String imageUrl) async {
    return ref.read(postRepositoryProvider).deletePostImage(imageUrl);
  }

  void _initPostsChannel() {
    ref.read(postRepositoryProvider).postsChannel.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: '*',
        schema: 'public',
        table: 'posts',
      ),
      (payload, [_]) async {
        if (['INSERT', 'UPDATE', 'DELETE'].contains(payload['eventType'])) {
          state = await AsyncValue.guard(
            () async => ref.read(postRepositoryProvider).getPosts(),
          );
        }
      },
    ).subscribe();
  }

  @override
  Future<List<Post>> build() {
    _initPostsChannel();
    return ref.read(postRepositoryProvider).getPosts();
  }
}
