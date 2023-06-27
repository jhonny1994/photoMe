import 'package:photome/features/likes/domain/like.dart';
import 'package:photome/features/likes/infurastructure/likes_repository.dart';

class LikeNotifer {
  LikeNotifer(this.likeRepository);

  final LikeRepository likeRepository;

  Stream<List<Like>> get likes => likeRepository.likes;

  Future<void> toggleLike(int postId) => likeRepository.toggleLike(postId);
}
