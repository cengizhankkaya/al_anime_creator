import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/profile_failure.dart';
import '../model/profile_model.dart';
import '../repository/profile_repository.dart';
import '../utils/profile_error_handler.dart';
import '../utils/profile_constants.dart';
import 'profile_state.dart';

// AuthCubit'e erişim için import
import 'package:al_anime_creator/features/auth/repository/auth_repository.dart';
import 'package:get_it/get_it.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(const ProfileInitial()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    emit(const ProfileLoading());

    try {
      // Önce kullanıcı kimlik doğrulamasını kontrol et
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        emit(const ProfileError(ProfileAuthFailure()));
        return;
      }

      final user = await _profileRepository.getCurrentUserProfile();
      emit(ProfileLoaded(user));
    } catch (e) {
      final failure = ProfileErrorHandler.handleLoadException(e);
      emit(ProfileError(failure));
    }
  }

  Future<void> updateLanguage(String language) async {
    await _updateSettings(
      (settings) => settings.copyWith(language: language),
      'Dil güncellenirken hata oluştu',
    );
  }

  Future<void> updateTheme(String theme) async {
    await _updateSettings(
      (settings) => settings.copyWith(theme: theme),
      'Tema güncellenirken hata oluştu',
    );
  }

  Future<void> updateNotifications(bool enabled) async {
    await _updateSettings(
      (settings) => settings.copyWith(notificationsEnabled: enabled),
      'Bildirimler güncellenirken hata oluştu',
    );
  }

  Future<void> updateSound(bool enabled) async {
    await _updateSettings(
      (settings) => settings.copyWith(soundEnabled: enabled),
      'Ses ayarları güncellenirken hata oluştu',
    );
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }

  /// Kullanıcı çıkış işlemi
  Future<void> logout() async {
    try {
      final authRepository = GetIt.instance<AuthRepository>();
      await authRepository.signOut();
    } catch (e) {
      emit(ProfileError(ProfileLoadFailure(message: 'Çıkış yapılırken bir hata oluştu')));
    }
  }

  /// Generic settings update method
  Future<void> _updateSettings(
    UserSettings Function(UserSettings) updateFunction,
    String customErrorMessage,
  ) async {
    if (state is! ProfileLoaded) return;

    final currentState = state as ProfileLoaded;
    final updatedSettings = updateFunction(currentState.user.settings);
    final updatedUser = currentState.user.copyWith(settings: updatedSettings);

    // Optimistic update
    emit(ProfileLoaded(updatedUser));

    try {
      await _profileRepository.updateUserSettings(updatedSettings);
    } catch (e) {
      final failure = ProfileErrorHandler.handleSettingsUpdateException(e);
      emit(ProfileError(failure));
      
      // Hata durumunda eski state'e geri dön ve tekrar yükle
      await Future.delayed(ProfileConstants.errorRetryDelay);
      loadProfile();
    }
  }
}