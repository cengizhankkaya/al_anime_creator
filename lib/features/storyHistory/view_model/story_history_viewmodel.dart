import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/storygeneration/model/story.dart';
import 'package:al_anime_creator/product/service/firestore_service.dart';

class StoryHistoryViewModel extends ChangeNotifier {
  List<Story> _stories = [];
  Story? _selectedStory;
  bool _isLoading = false;
  final FirestoreService _firestoreService;

  List<Story> get stories => _stories;
  Story? get selectedStory => _selectedStory;
  bool get isLoading => _isLoading;

  StoryHistoryViewModel(this._firestoreService) {
    _loadStories();
  }

  void _loadStories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _stories = await _firestoreService.getStories();
    } catch (e) {
      // Hata durumunda boş liste göster
      _stories = [];
      print('Hikayeler yüklenirken hata: $e');
    }

    _isLoading = false;
    notifyListeners();
  }


  void selectStory(Story story) {
    _selectedStory = story;
    notifyListeners();
  }

  void clearSelectedStory() {
    _selectedStory = null;
    notifyListeners();
  }

  void addStory(Story story) {
    _stories.insert(0, story); // Add to beginning of list
    notifyListeners();
  }

  void deleteStorySync(String storyId) {
    // Sadece UI'dan hikayeyi kaldır (Firestore silme işlemi Cubit tarafından yapıldı)
    _stories.removeWhere((story) => story.id == storyId);
    if (_selectedStory?.id == storyId) {
      _selectedStory = null;
    }
    notifyListeners();
  }
}
