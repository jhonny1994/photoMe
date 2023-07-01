import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/features/posts/application/posts_notifier.dart';
import 'package:photome/features/posts/domain/post.dart';

final postProvider = FutureProvider.family<Post, int>((ref, postId) async {
  return ref.read(postNotifierProvider.notifier).getPost(postId);
});

final getProfilePostsProvider =
    FutureProvider.family<List<Post>, String>((ref, profileId) async {
  return ref.read(postNotifierProvider.notifier).getProfilePost(profileId);
});

final getProfilePostsCountProvider =
    FutureProvider.family<int?, String>((ref, profileId) async {
  return ref
      .read(postNotifierProvider.notifier)
      .getProfilePostsCount(profileId);
});
