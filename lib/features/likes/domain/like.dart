class Like {
  Like({
    required this.postId,
    required this.profileId,
    this.createdAt,
    this.id,
  });

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      createdAt: DateTime.parse(map['created_at'] as String),
      id: map['id'] as int,
      postId: map['post_id'] as int,
      profileId: map['profile_id'] as String,
    );
  }

  DateTime? createdAt;
  int? id;
  final int postId;
  final String profileId;

  Like copyWith({
    DateTime? createdAt,
    int? id,
    int? postId,
    String? profileId,
  }) {
    return Like(
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      postId: postId ?? this.postId,
      profileId: profileId ?? this.profileId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'post_id': postId,
      'profile_id': profileId,
    };
  }
}

class LikeInfo {
  LikeInfo({
    required this.count,
    required this.hasLiked,
  });

  factory LikeInfo.fromMap(Map<String, dynamic> map) {
    return LikeInfo(
      count: map['count'] as int,
      hasLiked: map['hasLiked'] as bool,
    );
  }

  final int count;
  final bool hasLiked;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': count,
      'hasLiked': hasLiked,
    };
  }
}
