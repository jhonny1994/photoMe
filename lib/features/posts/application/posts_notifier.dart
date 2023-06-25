import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:photome/features/posts/domain/post.dart';
import 'package:photome/features/posts/infurastructure/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'posts_notifier.g.dart';

@riverpod
class PostNotifier extends _$PostNotifier {
  @override
  Future<List<Post>> build() {
    _initPostsChannel();
    return ref.read(postRepositoryProvider).getPosts();
  }

  Future<Either<String, void>> addPost(Post post) async {
    return ref.read(postRepositoryProvider).addPost(post);
  }

  Future<Either<String, void>> deletePost(int id) async {
    return ref.read(postRepositoryProvider).deletePost(id);
  }

  Future<Either<String, void>> updatePost(Post post) async {
    return ref.read(postRepositoryProvider).updatePost(post);
  }

  Future<Either<String, String>> uploadImage(File image, String userId) async {
    return ref.read(postRepositoryProvider).uploadImage(image, userId);
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
}
