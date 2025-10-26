import '../entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<AuthUserEntity?> getCurrentUser();
  Future<AuthUserEntity> signIn(String email, String password);
  Future<AuthUserEntity> register(String email, String password);
  Future<void> signOut();
  Future<void> sendVerificationEmail();
}
