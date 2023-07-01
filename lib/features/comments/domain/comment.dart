import 'package:photome/features/profile/domain/profile.dart';

class Comment {
  Comment({
    required this.content,
    required this.postId,
    this.profile,
    this.createdAt,
    this.id,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      createdAt: DateTime.parse(map['created_at'] as String),
      id: map['id'] as int,
      postId: map['post_id'] as int,
      profile: map['profile'] != null ? map['profile'] as Profile : null,
      content: map['content'] as String,
    );
  }

  final String content;
  DateTime? createdAt;
  int? id;
  final int postId;
  Profile? profile;

  Comment copyWith({
    DateTime? createdAt,
    int? id,
    int? postId,
    Profile? profile,
    String? content,
  }) {
    return Comment(
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      postId: postId ?? this.postId,
      profile: profile ?? this.profile,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'post_id': postId,
      'profile_id': profile!.id,
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
