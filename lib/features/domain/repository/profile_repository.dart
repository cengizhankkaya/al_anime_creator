import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity?> getProfile(String userId);
  Future<void> saveProfile(ProfileEntity profile);
  Future<void> updateProfile(ProfileEntity profile);
  Future<void> deleteProfile(String userId);
}
