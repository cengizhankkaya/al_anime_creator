class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;
  final UserSettings settings;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
    required this.settings,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    DateTime? createdAt,
    UserSettings? settings,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'settings': settings.toMap(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      settings: map['settings'] != null ? UserSettings.fromMap(map['settings']) : const UserSettings(
        language: 'Türkçe',
        theme: 'Koyu',
        notificationsEnabled: true,
        soundEnabled: true,
      ),
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, createdAt: $createdAt, settings: $settings)';
  }
}

class UserSettings {
  final String language;
  final String theme;
  final bool notificationsEnabled;
  final bool soundEnabled;

  const UserSettings({
    required this.language,
    required this.theme,
    required this.notificationsEnabled,
    required this.soundEnabled,
  });

  UserSettings copyWith({
    String? language,
    String? theme,
    bool? notificationsEnabled,
    bool? soundEnabled,
  }) {
    return UserSettings(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'language': language,
      'theme': theme,
      'notificationsEnabled': notificationsEnabled,
      'soundEnabled': soundEnabled,
    };
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      language: map['language'] ?? 'Türkçe',
      theme: map['theme'] ?? 'Koyu',
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      soundEnabled: map['soundEnabled'] ?? true,
    );
  }

  @override
  String toString() {
    return 'UserSettings(language: $language, theme: $theme, notificationsEnabled: $notificationsEnabled, soundEnabled: $soundEnabled)';
  }
}
