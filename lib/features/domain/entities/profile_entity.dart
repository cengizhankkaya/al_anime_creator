class ProfileEntity {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final UserSettingsEntity settings;
  final String? avatarUrl;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.settings,
    this.avatarUrl,
  });
}

class UserSettingsEntity {
  final String language;
  final String theme;
  final bool notificationsEnabled;
  final bool soundEnabled;

  const UserSettingsEntity({
    required this.language,
    required this.theme,
    required this.notificationsEnabled,
    required this.soundEnabled,
  });
}
