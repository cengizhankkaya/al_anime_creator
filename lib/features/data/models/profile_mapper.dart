import 'package:al_anime_creator/features/data/models/profile_model.dart';
import 'package:al_anime_creator/features/domain/entities/profile_entity.dart';

// Data -> Domain
extension UserProfileMapper on UserProfile {
  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      settings: settings.toEntity(),
    );
  }
}

extension UserSettingsMapper on UserSettings {
  UserSettingsEntity toEntity() {
    return UserSettingsEntity(
      language: language,
      theme: theme,
      notificationsEnabled: notificationsEnabled,
      soundEnabled: soundEnabled,
    );
  }
}

// Domain -> Data
extension ProfileEntityMapper on ProfileEntity {
  UserProfile toModel() {
    return UserProfile(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
      settings: settings.toModel(),
    );
  }
}

extension UserSettingsEntityMapper on UserSettingsEntity {
  UserSettings toModel() {
    return UserSettings(
      language: language,
      theme: theme,
      notificationsEnabled: notificationsEnabled,
      soundEnabled: soundEnabled,
    );
  }
}
