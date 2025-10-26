import '../entities/auth_user_entity.dart';
import '../repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<AuthUserEntity> call(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('E-posta ve şifre boş olamaz');
    }
    return await repository.signIn(email, password);
  }
}
