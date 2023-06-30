import 'package:photome/features/profile/domain/profile.dart';

class Post {
  Post({
    required this.caption,
    required this.imageUrl,
    required this.profileId,
    this.createdAt,
    this.id,
    this.profile,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      caption: map['caption'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      id: map['id'] as int,
      imageUrl: map['image_url'] as String,
      profile: Profile.fromMap(map['profiles'] as Map<String, dynamic>),
      profileId: Profile.fromMap(map['profiles'] as Map<String, dynamic>).id,
    );
  }

  final String caption;
  DateTime? createdAt;
  int? id;
  final String imageUrl;
  Profile? profile;
  final String profileId;

  Post copyWith({
    String? caption,
    DateTime? createdAt,
    int? id,
    String? imageUrl,
    Profile? profile,
    String? profileId,
  }) {
    return Post(
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      profile: profile ?? this.profile,
      profileId: profileId ?? this.profileId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'caption': caption,
      'image_url': imageUrl,
      'profile_id': profileId,
    };
  }
}
