class User {
  final int id;
  final String name;
  final String email;
  final String? googleId;
  final String? appleId;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.googleId,
    this.appleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'User',
      email: json['email'] as String? ?? '',
      googleId: json['google_id'] as String?,
      appleId: json['apple_id'] as String?,
    );
  }

  /// First letter of name for the avatar circle.
  String get initial {
    if (name.isEmpty) return '?';
    return name[0].toUpperCase();
  }

  /// Which provider this account uses, if any.
  String get provider {
    if (googleId != null) return 'Google';
    if (appleId != null) return 'Apple';
    return 'Email';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'google_id': googleId,
        'apple_id': appleId,
      };
}