class AuthUserEntity {
  final String id;
  final String email;
  final bool isVerified;
  final String? displayName;
  final String? avatarUrl;

  const AuthUserEntity({
    required this.id,
    required this.email,
    required this.isVerified,
    this.displayName,
    this.avatarUrl,
  });
}
