class Profile {
  Profile({
    required this.id,
    required this.username,
    this.profileImage,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as String,
      username: map['username'] as String,
      profileImage: map['profile_image'] != null
          ? map['profile_image'] as String
          : 'https://api.dicebear.com/6.x/avataaars-neutral/png?seed=${map['username']}',
    );
  }

  final String id;
  String? profileImage;
  final String username;

  Profile copyWith({
    String? id,
    String? username,
    String? profileImage,
  }) {
    return Profile(
      id: id ?? this.id,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'profile_image': profileImage,
    };
  }
}
