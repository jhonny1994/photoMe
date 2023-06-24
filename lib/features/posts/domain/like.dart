class Like {
  Like({
    required this.id,
    required this.createdAt,
    required this.postId,
    required this.profileId,
  });

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      id: map['id'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      postId: map['post_id'] as int,
      profileId: map['profile_id'] as String,
    );
  }

  final DateTime createdAt;
  final int id;
  final int postId;
  final String profileId;

  Like copyWith({
    int? id,
    DateTime? createdAt,
    int? postId,
    String? profileId,
  }) {
    return Like(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      profileId: profileId ?? this.profileId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'created_at': createdAt,
      'post_id': postId,
      'profile_id': profileId,
    };
  }
}
