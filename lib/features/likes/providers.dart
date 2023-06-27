import 'package:photome/core/shared/providers.dart';
import 'package:photome/features/likes/application/like_notifier.dart';
import 'package:photome/features/likes/domain/like.dart';
import 'package:photome/features/likes/infurastructure/likes_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'providers.g.dart';

final likeNotifierProvider = Provider<LikeNotifer>((ref) {
  return LikeNotifer(ref.read(likeRepositoryProvider));
});

@riverpod
Stream<LikeInfo> likesCount(LikesCountRef ref, int postId) async* {
  final likesStream = ref.read(likeNotifierProvider).likes;
  final userId = ref.read(supabaseClientProvider).auth.currentUser!.id;
  await for (final likes in likesStream) {
    yield LikeInfo(
      count: likes.where((like) => like.postId == postId).length,
      hasLiked: likes
          .any((like) => like.postId == postId && like.profileId == userId),
    );
  }
}
