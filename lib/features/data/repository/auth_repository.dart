import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:al_anime_creator/features/data/models/profile_model.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .timeout(const Duration(seconds: 20));
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
    } on TimeoutException {
      throw Exception('Sunucuya bağlanılamadı. Lütfen internetinizi kontrol edin.');
    }
  }

  Future<User?> register(String email, String password, String name) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .timeout(const Duration(seconds: 20));
      
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
    } on TimeoutException {
      throw Exception('Sunucuya bağlanılamadı. Lütfen internetinizi kontrol edin.');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    try {
      // Google ile giriş yapılmışsa sağlayıcı oturumunu da kapat
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
        await googleSignIn.disconnect();
      }
    } catch (_) {
      // Sağlayıcı çıkışında hata olsa bile ana oturum kapatılmıştır; yutulabilir
    }
  }

  Stream<User?> get user => _firebaseAuth.authStateChanges();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Google ile giriş iptal edildi.');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth
          .signInWithCredential(credential)
          .timeout(const Duration(seconds: 20));

      final user = userCredential.user;
      if (user != null) {
        // Profil yoksa oluştur
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (!doc.exists) {
          await _createUserProfile(user, user.displayName ?? '');
        }
      }
      return user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'Bu e-posta başka bir yöntemle zaten kayıtlı.';
          break;
        case 'invalid-credential':
          errorMessage = 'Geçersiz kimlik bilgisi. Lütfen tekrar deneyin.';
          break;
        case 'user-disabled':
          errorMessage = 'Bu kullanıcı hesabı devre dışı bırakılmış.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Google ile giriş izni devre dışı.';
          break;
        case 'user-not-found':
          errorMessage = 'Kullanıcı bulunamadı.';
          break;
        case 'network-request-failed':
          errorMessage = 'İnternet bağlantınızı kontrol edin.';
          break;
        default:
          errorMessage = 'Google ile girişte hata oluştu: ${e.message}';
      }
      throw Exception(errorMessage);
    } on TimeoutException {
      throw Exception('Sunucuya bağlanılamadı. Lütfen internetinizi kontrol edin.');
    }
  }
  
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