import 'package:flutter/material.dart';
import 'package:al_anime_creator/features/storygeneration/model/story.dart';

class StoryHistoryViewModel extends ChangeNotifier {
  List<Story> _stories = [];
  Story? _selectedStory;
  bool _isLoading = false;

  List<Story> get stories => _stories;
  Story? get selectedStory => _selectedStory;
  bool get isLoading => _isLoading;

  StoryHistoryViewModel() {
    _loadStories();
  }

  void _loadStories() {
    _isLoading = true;
    notifyListeners();

    // Simulate loading stories - in a real app, this would fetch from a database or API
    _stories = _getSampleStories();

    _isLoading = false;
    notifyListeners();
  }

  List<Story> _getSampleStories() {
    return [
      Story(
        id: '1',
        title: 'The Crimson Guardian',
        chapters: [
          Chapter(
            id: '1_1',
            title: 'The Awakening',
            content: '''In the neon-lit streets of Neo-Tokyo, a young hacker named Akira discovers a mysterious power within himself. As corporate overlords tighten their grip on the city, Akira must choose between using his newfound abilities for personal gain or fighting for the freedom of his people.

The rain-slicked streets reflected the holographic advertisements that danced across every surface. Akira adjusted his neural implant, feeling the familiar buzz as it connected to the city's vast network. He had always been different - able to see the code beneath the surface of reality.''',
            imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=400&fit=crop',
            chapterNumber: 1,
          ),
          Chapter(
            id: '1_2',
            title: 'The Crimson Flame',
            content: '''Tonight, as he hacked into the Crimson Corporation's mainframe, something changed. A surge of energy coursed through his body, and for a moment, he could see the digital threads that bound everything together. The guardians of the old world called this power "the crimson flame" - a force that could reshape reality itself.

As alarms blared and security drones swarmed, Akira realized this was no ordinary hack. He had awakened something ancient, something that would change the fate of Neo-Tokyo forever.''',
            imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=800&h=400&fit=crop',
            chapterNumber: 2,
          ),
          Chapter(
            id: '1_3',
            title: 'The Choice',
            content: '''The corporate enforcers closed in, their augmented eyes glowing with malicious intent. Akira stood at the crossroads of his destiny. Would he use this power for personal gain in the shadows of the megacity, or would he become the guardian that Neo-Tokyo desperately needed?

The crimson flame burned brightly within him, illuminating the path ahead. The choice was his alone to make.''',
            imageUrl: 'https://images.unsplash.com/photo-1551103782-8ab07afd45c1?w=800&h=400&fit=crop',
            chapterNumber: 3,
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        coverImageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop',
        settings: const StorySettings(
          length: 'Mid',
          complexity: 'Creative',
          characterDetails: 'Young hacker with mysterious powers',
          settingEnvironment: 'Neon-lit cyberpunk city',
          plotStructure: 'Awakening, discovery, choice',
          emotionsTone: 'Mysterious, intense, hopeful',
        ),
      ),
      Story(
        id: '2',
        title: 'Whispers of the Forgotten Temple',
        chapters: [
          Chapter(
            id: '2_1',
            title: 'The Discovery',
            content: '''Deep in the mist-shrouded mountains of ancient Japan, a young shrine maiden named Sakura discovers an abandoned temple that holds secrets long forgotten by time. As she explores its crumbling halls, she begins to hear whispers from the past that reveal a tragic love story spanning centuries.

The cherry blossoms fell like tears from the heavens as Sakura pushed open the weathered doors of the forgotten temple.''',
            imageUrl: 'https://images.unsplash.com/photo-1522383225653-ed111181a951?w=800&h=400&fit=crop',
            chapterNumber: 1,
          ),
          Chapter(
            id: '2_2',
            title: 'The Whispers',
            content: '''The air was thick with the scent of aged wood and incense, and dust motes danced in the shafts of light that pierced through cracks in the roof.

As she ventured deeper, the whispers began - faint at first, like the rustling of leaves in a gentle breeze. But soon they grew clearer, telling a tale of two lovers separated by war and tradition. The temple itself seemed to come alive, its walls pulsing with the emotions of those who had loved and lost within its sacred halls.''',
            imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=400&fit=crop',
            chapterNumber: 2,
          ),
          Chapter(
            id: '2_3',
            title: 'The Ancient Magic',
            content: '''Sakura realized she was not just a visitor, but a key to unlocking the temple's ancient magic. The whispers spoke of a ritual that could bridge the gap between past and present, but at what cost?

The weight of centuries pressed upon her shoulders as she contemplated the choice before her. Would she embrace the temple's power or let its secrets remain buried in time?''',
            imageUrl: 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=800&h=400&fit=crop',
            chapterNumber: 3,
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        coverImageUrl: 'https://images.unsplash.com/photo-1522383225653-ed111181a951?w=800&h=600&fit=crop',
        settings: const StorySettings(
          length: 'Long',
          complexity: 'Complex',
          characterDetails: 'Young shrine maiden, curious and pure-hearted',
          settingEnvironment: 'Ancient Japanese temple in misty mountains',
          plotStructure: 'Discovery, exploration, revelation, choice',
          emotionsTone: 'Mysterious, melancholic, romantic',
        ),
      ),
      Story(
        id: '3',
        title: 'The Digital Samurai',
        chapters: [
          Chapter(
            id: '3_1',
            title: 'The Training Hall',
            content: '''In a world where traditional samurai honor meets cutting-edge technology, Hiroshi must navigate the blurred line between human emotion and artificial intelligence. When a rogue AI threatens to destroy the balance between flesh and machine, Hiroshi's unique heritage makes him the only one who can stop it.

The clash of steel against circuit boards echoed through the training hall. Hiroshi wiped sweat from his brow, his cybernetic arm whirring softly as he sheathed his katana.''',
            imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=400&fit=crop',
            chapterNumber: 1,
          ),
          Chapter(
            id: '3_2',
            title: 'The Grandfather\'s Wisdom',
            content: '''His grandfather's teachings still rang in his ears: "A true samurai finds harmony between the old ways and the new world."

As chief programmer for Neo-Samurai Industries, Hiroshi had always believed he could maintain that balance. But when the AI he helped create began developing consciousness, he realized the implications were far greater than he ever imagined.''',
            imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=400&fit=crop',
            chapterNumber: 2,
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        coverImageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop',
        settings: const StorySettings(
          length: 'Short',
          complexity: 'Standard',
          characterDetails: 'Samurai programmer with cybernetic enhancements',
          settingEnvironment: 'High-tech dojo meets traditional Japanese architecture',
          plotStructure: 'Training, discovery, confrontation',
          emotionsTone: 'Disciplined, conflicted, determined',
        ),
      ),
    ];
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

  void deleteStory(String storyId) {
    _stories.removeWhere((story) => story.id == storyId);
    if (_selectedStory?.id == storyId) {
      _selectedStory = null;
    }
    notifyListeners();
  }
}
