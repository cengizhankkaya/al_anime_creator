import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import '../model/profile_model.dart';

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
      throw Exception('Kullanıcı oturumu bulunamadı');
    }

    try {
      final doc = await _firestore.collection('users').doc(_userId).get();

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
            language: 'Türkçe',
            theme: 'Koyu',
            notificationsEnabled: true,
            soundEnabled: true,
          ),
        );

        // Varsayılan profili kaydet
        await _firestore.collection('users').doc(_userId).set(defaultProfile.toMap());
        return defaultProfile;
      }
    } catch (e) {
      throw Exception('Profil yüklenirken hata oluştu: $e');
    }
  }

  @override
  Future<void> updateUserProfile(UserProfile user) async {
    if (_userId.isEmpty) {
      throw Exception('Kullanıcı oturumu bulunamadı');
    }

    try {
      await _firestore.collection('users').doc(_userId).update(user.toMap());
    } catch (e) {
      throw Exception('Profil güncellenirken hata oluştu: $e');
    }
  }

  @override
  Future<void> updateUserSettings(UserSettings settings) async {
    if (_userId.isEmpty) {
      throw Exception('Kullanıcı oturumu bulunamadı');
    }

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .update({'settings': settings.toMap()});
    } catch (e) {
      throw Exception('Ayarlar güncellenirken hata oluştu: $e');
    }
  }
}
