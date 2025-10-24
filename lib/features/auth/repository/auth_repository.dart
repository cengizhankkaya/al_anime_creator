import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:al_anime_creator/features/profile/model/profile_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Firebase spesifik hataları daha kullanıcı dostu mesajlara çevir
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı.';
          break;
        case 'wrong-password':
          errorMessage = 'Şifre yanlış. Lütfen tekrar deneyin.';
          break;
        case 'invalid-email':
          errorMessage = 'Geçersiz e-posta adresi.';
          break;
        case 'user-disabled':
          errorMessage = 'Bu kullanıcı hesabı devre dışı bırakılmış.';
          break;
        case 'too-many-requests':
          errorMessage = 'Çok fazla başarısız giriş denemesi. Lütfen daha sonra tekrar deneyin.';
          break;
        case 'network-request-failed':
          errorMessage = 'İnternet bağlantınızı kontrol edin.';
          break;
        default:
          errorMessage = 'Giriş yapılırken bir hata oluştu: ${e.message}';
      }
      throw Exception(errorMessage);
    }
  }

  Future<User?> register(String email, String password, String name) async {
    try {
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = credential.user;
      if (user != null) {
        // Firestore'a kullanıcı profilini kaydet
        await _createUserProfile(user, name);
      }
      
      return user;
    } on FirebaseAuthException catch (e) {
      // Firebase spesifik hataları daha kullanıcı dostu mesajlara çevir
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Şifre çok zayıf. En az 6 karakter olmalı.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Bu e-posta adresi zaten kullanımda.';
          break;
        case 'invalid-email':
          errorMessage = 'Geçersiz e-posta adresi.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'E-posta/şifre ile kayıt olma özelliği devre dışı.';
          break;
        case 'network-request-failed':
          errorMessage = 'İnternet bağlantınızı kontrol edin.';
          break;
        default:
          errorMessage = 'Kayıt olurken bir hata oluştu: ${e.message}';
      }
      throw Exception(errorMessage);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> get user => _firebaseAuth.authStateChanges();
  
  /// Kullanıcı profilini Firestore'a kaydet
  Future<void> _createUserProfile(User user, String name) async {
    try {
      final userProfile = UserProfile(
        id: user.uid,
        name: name,
        email: user.email ?? '',
        avatarUrl: user.photoURL,
        createdAt: DateTime.now(),
        settings: const UserSettings(
          language: 'Türkçe',
          theme: 'Koyu',
          notificationsEnabled: true,
          soundEnabled: true,
        ),
      );
      
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userProfile.toMap());
    } catch (e) {
      // Profil kaydetme hatası Firebase Auth kaydını etkilemesin
      // Hata loglanabilir ama Firebase Auth kaydını etkilememeli
    }
  }
}