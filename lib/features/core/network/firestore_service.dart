import 'package:al_anime_creator/features/data/models/story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String get _userId => _auth.currentUser?.uid ?? 'anonymous';
  
  /// Hikayeyi Firebase'e kaydet
  Future<void> saveStory(Story story) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('stories')
          .doc(story.id)
          .set(story.toMap());
    } catch (e) {
      throw Exception('Hikaye kaydedilirken hata oluştu: $e');
    }
  }
  
  /// Kullanıcının tüm hikayelerini yükle
  Future<List<Story>> getStories() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('stories')
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => Story.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Hikayeler yüklenirken hata oluştu: $e');
    }
  }
  
  /// Belirli bir hikayeyi getir
  Future<Story?> getStory(String storyId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('stories')
          .doc(storyId)
          .get();
      
      if (doc.exists) {
        return Story.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Hikaye getirilirken hata oluştu: $e');
    }
  }
  
  /// Hikayeyi güncelle
  Future<void> updateStory(Story story) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('stories')
          .doc(story.id)
          .update(story.toMap());
    } catch (e) {
      throw Exception('Hikaye güncellenirken hata oluştu: $e');
    }
  }
  
  /// Hikayeyi sil
  Future<void> deleteStory(String storyId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('stories')
          .doc(storyId)
          .delete();
    } catch (e) {
      throw Exception('Hikaye silinirken hata oluştu: $e');
    }
  }
  
  /// Hikayeleri gerçek zamanlı dinle
  Stream<List<Story>> getStoriesStream() {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('stories')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Story.fromMap(doc.data()))
            .toList());
  }
}
