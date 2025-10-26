import '../entities/profile_entity.dart';
import '../repository/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);

  Future<void> call(ProfileEntity profile) async {
    if (profile.name.isEmpty || profile.email.isEmpty) {
      throw Exception('Kullanıcı adı ve e-posta boş bırakılamaz');
    }
    await repository.updateProfile(profile);
  }
}
