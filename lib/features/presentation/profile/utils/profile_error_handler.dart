import 'package:al_anime_creator/features/data/models/profile_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_constants.dart';

/// Profile işlemlerinde hata yönetimi için utility sınıfı
class ProfileErrorHandler {
  /// Firebase hatalarını ProfileFailure'a dönüştürür
  static ProfileFailure handleFirebaseException(FirebaseException e, {String? customMessage}) {
    switch (e.code) {
      case 'permission-denied':
        return ProfilePermissionFailure(
          message: customMessage ?? ProfileConstants.permissionErrorMessage,
        );
      case 'not-found':
        return ProfileNotFoundFailure(
          message: customMessage ?? ProfileConstants.notFoundErrorMessage,
        );
      case 'unavailable':
        return ProfileNetworkFailure(
          message: customMessage ?? ProfileConstants.networkErrorMessage,
        );
      default:
        return ProfileUnknownFailure(
          message: customMessage ?? '${ProfileConstants.unknownErrorMessage}: ${e.message}',
        );
    }
  }
  
  /// Genel hataları ProfileFailure'a dönüştürür
  static ProfileFailure handleGenericException(dynamic e, {String? customMessage}) {
    if (e is FirebaseException) {
      return handleFirebaseException(e, customMessage: customMessage);
    }
    
    return ProfileUnknownFailure(
      message: customMessage ?? '${ProfileConstants.unknownErrorMessage}: $e',
    );
  }
  
  /// Auth hatalarını ProfileFailure'a dönüştürür
  static ProfileFailure handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return ProfileAuthFailure(message: 'Kullanıcı bulunamadı');
        case 'invalid-credential':
          return ProfileAuthFailure(message: 'Geçersiz kimlik bilgileri');
        case 'user-disabled':
          return ProfileAuthFailure(message: 'Kullanıcı hesabı devre dışı');
        default:
          return ProfileAuthFailure(message: 'Kimlik doğrulama hatası: ${e.message}');
      }
    }
    
    return ProfileAuthFailure(message: 'Kimlik doğrulama hatası: $e');
  }
  
  /// Profil yükleme hatalarını işler
  static ProfileFailure handleLoadException(dynamic e) {
    return handleGenericException(e, customMessage: ProfileConstants.loadErrorMessage);
  }
  
  /// Profil güncelleme hatalarını işler
  static ProfileFailure handleUpdateException(dynamic e) {
    return handleGenericException(e, customMessage: ProfileConstants.updateErrorMessage);
  }
  
  /// Ayarlar güncelleme hatalarını işler
  static ProfileFailure handleSettingsUpdateException(dynamic e) {
    return handleGenericException(e, customMessage: ProfileConstants.settingsUpdateErrorMessage);
  }
}
