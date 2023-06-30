class Comment {
  Comment({
    required this.content,
    required this.postId,
    required this.profileId,
    this.createdAt,
    this.id,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      createdAt: DateTime.parse(map['created_at'] as String),
      id: map['id'] as int,
      postId: map['post_id'] as int,
      profileId: map['profile_id'] as String,
      content: map['content'] as String,
    );
  }

  final String content;
  DateTime? createdAt;
  int? id;
  final int postId;
  final String profileId;

  Comment copyWith({
    DateTime? createdAt,
    int? id,
    int? postId,
    String? profileId,
    String? content,
  }) {
    return Comment(
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      postId: postId ?? this.postId,
      profileId: profileId ?? this.profileId,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'post_id': postId,
      'profile_id': profileId,
      'content': content,
    };
  }
}

class CommentInfo {
  CommentInfo({
    required this.comments,
    required this.count,
    required this.hasCommented,
  });

  factory CommentInfo.fromMap(Map<String, dynamic> map) {
    return CommentInfo(
      count: map['count'] as int,
      hasCommented: map['hasCommented'] as bool,
      comments: map['comments'] as List<Comment>,
    );
  }

  final List<Comment> comments;
  final int count;
  final bool hasCommented;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': count,
      'hasCommented': hasCommented,
      'comments': comments,
    };
  }
}
