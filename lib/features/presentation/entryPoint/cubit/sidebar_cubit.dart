import 'package:al_anime_creator/features/data/repository/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sidebar_state.dart';

class SidebarCubit extends Cubit<SidebarState> {
  final ProfileRepository _profileRepository;
  
  SidebarCubit(this._profileRepository) : super(const SidebarInitial()) {
    _listenToAuthChanges();
  }

  /// Firebase Auth durum değişikliklerini dinle
  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        emit(const SidebarUnauthenticated());
      } else {
        loadUserProfile();
      }
    });
  }

  /// Kullanıcı profilini yükle
  Future<void> loadUserProfile() async {
    emit(const SidebarLoading());
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const SidebarUnauthenticated());
        return;
      }

      final profile = await _profileRepository.getCurrentUserProfile();
      emit(SidebarLoaded(profile));
    } catch (e) {
      emit(SidebarError('Profil yüklenemedi: $e'));
    }
  }
}
