class CastMember {
  final int id;
  final String name;
  final String character;
  final String? profileUrl;

  CastMember({
    required this.id,
    required this.name,
    required this.character,
    required this.profileUrl,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      character: json['character'] as String? ?? '',
      profileUrl: json['profile_url'] as String?,
    );
  }

  String get initial => name.isEmpty ? '?' : name[0].toUpperCase();
}