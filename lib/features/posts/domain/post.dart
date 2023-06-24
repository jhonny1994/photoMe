import 'package:photome/features/posts/domain/like.dart';
import 'package:photome/features/posts/domain/profile.dart';

class Post {
  Post({
    required this.caption,
    required this.createdAt,
    required this.id,
    required this.imageUrl,
    required this.likes,
    required this.profile,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      caption: map['caption'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      id: map['id'] as int,
      imageUrl: map['image_url'] as String,
      likes: map['likes'] as List<Like>? ?? [],
      profile: Profile.fromMap(map['profiles'] as Map<String, dynamic>),
    );
  }

  final String caption;
  final DateTime createdAt;
  final int id;
  final String imageUrl;
  List<Like> likes = [];
  final Profile profile;

  bool isLiked() => likes.any((element) => element.profileId == profile.id);

  Post copyWith({
    String? caption,
    DateTime? createdAt,
    int? id,
    String? imageUrl,
    List<Like>? likes,
    Profile? profile,
  }) {
    return Post(
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      profile: profile ?? this.profile,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'caption': caption,
      'created_at': createdAt,
      'id': id,
      'image_url': imageUrl,
      'likes': likes,
      'profiles': profile.toMap(),
    };
  }
}
