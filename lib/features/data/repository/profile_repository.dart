import 'package:al_anime_creator/features/data/models/profile_failure.dart';
import 'package:al_anime_creator/features/data/models/profile_model.dart';
import 'package:al_anime_creator/features/presentation/profile/utils/profile_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';


abstract class ProfileRepository {
  Future<UserProfile> getCurrentUserProfile();
  Future<void> updateUserProfile(UserProfile user);
  Future<void> updateUserSettings(UserSettings settings);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  firebase_auth.User? get _currentFirebaseUser => _auth.currentUser;

  @override
  Future<UserProfile> getCurrentUserProfile() async {
    if (_userId.isEmpty) {
      throw const ProfileAuthFailure();
    }

    try {
      final doc = await _firestore.collection(ProfileConstants.usersCollection).doc(_userId).get();

      if (doc.exists) {
        return UserProfile.fromMap(doc.data()!);
      } else {
        // Kullanıcı profili yoksa varsayılan profil oluştur
        final firebaseUser = _currentFirebaseUser;
        final defaultProfile = UserProfile(
          id: _userId,
          name: firebaseUser?.displayName ?? 'Kullanıcı',
          email: firebaseUser?.email ?? '',
          avatarUrl: firebaseUser?.photoURL,
          createdAt: DateTime.now(),
          settings: const UserSettings(
            language: ProfileConstants.defaultLanguage,
            theme: ProfileConstants.defaultTheme,
            notificationsEnabled: ProfileConstants.defaultNotificationsEnabled,
            soundEnabled: ProfileConstants.defaultSoundEnabled,
          ),
        );

        // Varsayılan profili kaydet
        await _firestore.collection(ProfileConstants.usersCollection).doc(_userId).set(defaultProfile.toMap());
        return defaultProfile;
      }
    } catch (e) {
      if (e is ProfileFailure) {
        rethrow;
      }
      throw ProfileLoadFailure(message: '${ProfileConstants.loadErrorMessage}: $e');
    }
  }

  @override
  Future<void> updateUserProfile(UserProfile user) async {
    if (_userId.isEmpty) {
      throw const ProfileAuthFailure();
    }

    try {
      await _firestore.collection(ProfileConstants.usersCollection).doc(_userId).update(user.toMap());
    } catch (e) {
      if (e is ProfileFailure) {
        rethrow;
      }
      throw ProfileUpdateFailure(message: '${ProfileConstants.updateErrorMessage}: $e');
    }
  }

  @override
  Future<void> updateUserSettings(UserSettings settings) async {
    if (_userId.isEmpty) {
      throw const ProfileAuthFailure();
    }

    try {
      await _firestore
          .collection(ProfileConstants.usersCollection)
          .doc(_userId)
          .update({'settings': settings.toMap()});
    } catch (e) {
      if (e is ProfileFailure) {
        rethrow;
      }
      throw ProfileSettingsUpdateFailure(message: '${ProfileConstants.settingsUpdateErrorMessage}: $e');
    }
  }
}
