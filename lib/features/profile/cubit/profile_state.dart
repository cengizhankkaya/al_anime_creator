import 'package:al_anime_creator/features/profile/cubit/profile_cubit.dart';
import 'package:al_anime_creator/features/profile/repository/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(ProfileInitial()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    emit(ProfileLoading());

    try {
      // Önce kullanıcı kimlik doğrulamasını kontrol et
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        emit(ProfileError('Kullanıcı oturumu bulunamadı. Lütfen tekrar oturum açın.'));
        return;
      }

      final user = await _profileRepository.getCurrentUserProfile();
      emit(ProfileLoaded(user));
    } catch (e) {
      String errorMessage = 'Profil yüklenirken hata oluştu';

      if (e is FirebaseException) {
        switch (e.code) {
          case 'permission-denied':
            errorMessage = 'Profil bilgilerinize erişim izniniz yok. Lütfen tekrar oturum açın.';
            break;
          case 'not-found':
            errorMessage = 'Profil bilgileri bulunamadı.';
            break;
          case 'unavailable':
            errorMessage = 'Şu anda profil bilgilerinize erişilemiyor. Lütfen daha sonra tekrar deneyin.';
            break;
          default:
            errorMessage = 'Profil yüklenirken hata oluştu: ${e.message}';
        }
      } else {
        errorMessage = 'Profil yüklenirken hata oluştu: $e';
      }

      emit(ProfileError(errorMessage));
    }
  }

  Future<void> updateLanguage(String language) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedSettings = currentState.user.settings.copyWith(language: language);
      final updatedUser = currentState.user.copyWith(settings: updatedSettings);

      emit(ProfileLoaded(updatedUser));

      try {
        await _profileRepository.updateUserSettings(updatedSettings);
      } catch (e) {
        String errorMessage = 'Dil güncellenirken hata oluştu';

        if (e is FirebaseException) {
          switch (e.code) {
            case 'permission-denied':
              errorMessage = 'Dil ayarlarını güncelleme izniniz yok. Lütfen tekrar oturum açın.';
              break;
            case 'unavailable':
              errorMessage = 'Şu anda ayarlar güncellenemiyor. Lütfen daha sonra tekrar deneyin.';
              break;
            default:
              errorMessage = 'Dil güncellenirken hata oluştu: ${e.message}';
          }
        } else {
          errorMessage = 'Dil güncellenirken hata oluştu: $e';
        }

        // Hata durumunda eski state'e geri dön
        emit(ProfileError(errorMessage));
        // Kısa bir süre sonra tekrar yükle
        await Future.delayed(const Duration(seconds: 1));
        loadProfile();
      }
    }
  }

  Future<void> updateTheme(String theme) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedSettings = currentState.user.settings.copyWith(theme: theme);
      final updatedUser = currentState.user.copyWith(settings: updatedSettings);

      emit(ProfileLoaded(updatedUser));

      try {
        await _profileRepository.updateUserSettings(updatedSettings);
      } catch (e) {
        String errorMessage = 'Tema güncellenirken hata oluştu';

        if (e is FirebaseException) {
          switch (e.code) {
            case 'permission-denied':
              errorMessage = 'Tema ayarlarını güncelleme izniniz yok. Lütfen tekrar oturum açın.';
              break;
            case 'unavailable':
              errorMessage = 'Şu anda ayarlar güncellenemiyor. Lütfen daha sonra tekrar deneyin.';
              break;
            default:
              errorMessage = 'Tema güncellenirken hata oluştu: ${e.message}';
          }
        } else {
          errorMessage = 'Tema güncellenirken hata oluştu: $e';
        }

        // Hata durumunda eski state'e geri dön
        emit(ProfileError(errorMessage));
        // Kısa bir süre sonra tekrar yükle
        await Future.delayed(const Duration(seconds: 1));
        loadProfile();
      }
    }
  }

  Future<void> updateNotifications(bool enabled) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedSettings = currentState.user.settings.copyWith(notificationsEnabled: enabled);
      final updatedUser = currentState.user.copyWith(settings: updatedSettings);

      emit(ProfileLoaded(updatedUser));

      try {
        await _profileRepository.updateUserSettings(updatedSettings);
      } catch (e) {
        String errorMessage = 'Bildirimler güncellenirken hata oluştu';

        if (e is FirebaseException) {
          switch (e.code) {
            case 'permission-denied':
              errorMessage = 'Bildirim ayarlarını güncelleme izniniz yok. Lütfen tekrar oturum açın.';
              break;
            case 'unavailable':
              errorMessage = 'Şu anda ayarlar güncellenemiyor. Lütfen daha sonra tekrar deneyin.';
              break;
            default:
              errorMessage = 'Bildirimler güncellenirken hata oluştu: ${e.message}';
          }
        } else {
          errorMessage = 'Bildirimler güncellenirken hata oluştu: $e';
        }

        // Hata durumunda eski state'e geri dön
        emit(ProfileError(errorMessage));
        // Kısa bir süre sonra tekrar yükle
        await Future.delayed(const Duration(seconds: 1));
        loadProfile();
      }
    }
  }

  Future<void> updateSound(bool enabled) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedSettings = currentState.user.settings.copyWith(soundEnabled: enabled);
      final updatedUser = currentState.user.copyWith(settings: updatedSettings);

      emit(ProfileLoaded(updatedUser));

      try {
        await _profileRepository.updateUserSettings(updatedSettings);
      } catch (e) {
        String errorMessage = 'Ses ayarları güncellenirken hata oluştu';

        if (e is FirebaseException) {
          switch (e.code) {
            case 'permission-denied':
              errorMessage = 'Ses ayarlarını güncelleme izniniz yok. Lütfen tekrar oturum açın.';
              break;
            case 'unavailable':
              errorMessage = 'Şu anda ayarlar güncellenemiyor. Lütfen daha sonra tekrar deneyin.';
              break;
            default:
              errorMessage = 'Ses ayarları güncellenirken hata oluştu: ${e.message}';
          }
        } else {
          errorMessage = 'Ses ayarları güncellenirken hata oluştu: $e';
        }

        // Hata durumunda eski state'e geri dön
        emit(ProfileError(errorMessage));
        // Kısa bir süre sonra tekrar yükle
        await Future.delayed(const Duration(seconds: 1));
        loadProfile();
      }
    }
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }
}
