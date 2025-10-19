
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:al_anime_creator/firebase_options.dart';
import 'package:al_anime_creator/product/model/story.dart';
import 'package:al_anime_creator/features/storyHistory/view_model/story_history_viewmodel.dart';
import 'package:uuid/uuid.dart';

@RoutePage(
  name: 'StoryGenerationRoute',
)
class StoryGenerationView extends StatefulWidget {
  const StoryGenerationView({super.key});

  @override
  State<StoryGenerationView> createState() => _StoryGenerationViewState();
}

class _StoryGenerationViewState extends State<StoryGenerationView> {
  int selectedLength = 0; // 0: Short, 1: Mid, 2: Long
  double sliderValue = 0; // -1: Standard, 0: Complex, 1: Creative
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;
  bool isExpanded4 = false;

  // AI Model and Story Generation
  late GenerativeModel _model;
  bool _isLoading = false;
  String _generatedStory = '';
  bool _showStory = false;

  // Text Controllers for expandable sections
  final TextEditingController _characterController = TextEditingController();
  final TextEditingController _settingController = TextEditingController();
  final TextEditingController _plotController = TextEditingController();
  final TextEditingController _emotionController = TextEditingController();

  // Story History için ViewModel
  late StoryHistoryViewModel _storyHistoryViewModel;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _storyHistoryViewModel = StoryHistoryViewModel();
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.0-flash-001',
      );
    } catch (e) {
      print('Firebase initialization error: $e');
    }
  }

  Future<void> _generateStory() async {
    // Kullanıcı hiç input vermediyse uyarı ver
    final String characterDetails = _characterController.text.trim();
    final String settingDetails = _settingController.text.trim();
    final String plotDetails = _plotController.text.trim();
    final String emotionDetails = _emotionController.text.trim();

    if (characterDetails.isEmpty &&
        settingDetails.isEmpty &&
        plotDetails.isEmpty &&
        emotionDetails.isEmpty) {
      _showErrorSnackBar('Lütfen en az bir hikaye detayı girin');
      return;
    }

    setState(() {
      _isLoading = true;
      _showStory = false;
    });

    try {
      // Kullanıcı girdilerini topla
      final String characterDetails = _characterController.text.trim();
      final String settingDetails = _settingController.text.trim();
      final String plotDetails = _plotController.text.trim();
      final String emotionDetails = _emotionController.text.trim();

      // Hikaye uzunluğunu belirle
      final Map<int, String> lengthMap = {
        0: 'kısa',
        1: 'orta uzunlukta',
        2: 'uzun'
      };
      final String storyLength = lengthMap[selectedLength] ?? 'orta uzunlukta';

      // Yaratıcılık seviyesini belirle
      String creativityLevel;
      if (sliderValue <= -0.3) {
        creativityLevel = 'standart';
      } else if (sliderValue >= 0.3) {
        creativityLevel = 'yaratıcı';
      } else {
        creativityLevel = 'karmaşık';
      }

      // Hikaye oluşturma prompt'unu hazırla
      final String prompt = '''
      Türkçe bir hikaye oluştur. Hikaye şu özelliklerde olsun:

      Hikaye Uzunluğu: $storyLength
      Yaratıcılık Seviyesi: $creativityLevel

      ${characterDetails.isNotEmpty ? 'Karakter Detayları: $characterDetails' : ''}
      ${settingDetails.isNotEmpty ? 'Mekan ve Ortam: $settingDetails' : ''}
      ${plotDetails.isNotEmpty ? 'Olay Örgüsü: $plotDetails' : ''}
      ${emotionDetails.isNotEmpty ? 'Duygu ve Ton: $emotionDetails' : ''}

      Hikaye anime tarzında, sürükleyici ve görsel olarak zengin olsun. Türkçe yaz.
      ''';

      // Gemini AI'ye gönder
      final Content content = Content.text(prompt);
      final response = await _model.generateContent([content])
          .timeout(const Duration(seconds: 30));

      final String aiResponse = response.text ?? "Üzgünüm, bir hikaye oluşturamadım.";

      // Hikayeyi kaydet
      _saveStoryToHistory(aiResponse);

      setState(() {
        _generatedStory = aiResponse;
        _showStory = true;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'Hikaye oluşturulurken hata oluştu: ';
      if (e.toString().contains('timeout')) {
        errorMessage += 'İstek zaman aşımına uğradı. Lütfen tekrar deneyin.';
      } else if (e.toString().contains('network')) {
        errorMessage += 'İnternet bağlantınızı kontrol edin.';
      } else {
        errorMessage += e.toString();
      }

      _showErrorSnackBar(errorMessage);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  TextEditingController _getControllerForSection(String title) {
    switch (title) {
      case 'character details':
        return _characterController;
      case 'setting and environment':
        return _settingController;
      case 'plot structure':
        return _plotController;
      case 'emotions and tone':
        return _emotionController;
      default:
        return TextEditingController();
    }
  }

  void _saveStoryToHistory(String storyContent) {
    try {
      // Hikaye başlığını oluştur (ilk cümleden)
      String title = 'AI Generated Story';
      if (storyContent.length > 50) {
        final firstSentence = storyContent.split('.').first;
        if (firstSentence.length > 10) {
          title = firstSentence.substring(0, firstSentence.length > 50 ? 50 : firstSentence.length) + '...';
        }
      }

      // Hikaye ayarlarını topla
      final Map<int, String> lengthMap = {
        0: 'Short',
        1: 'Mid',
        2: 'Long'
      };
      final String storyLength = lengthMap[selectedLength] ?? 'Mid';

      String creativityLevel;
      if (sliderValue <= -0.3) {
        creativityLevel = 'Standard';
      } else if (sliderValue >= 0.3) {
        creativityLevel = 'Creative';
      } else {
        creativityLevel = 'Complex';
      }

      // Yeni hikaye oluştur
      final Story newStory = Story(
        id: const Uuid().v4(),
        title: title,
        chapters: [
          Chapter(
            id: const Uuid().v4(),
            title: 'Chapter 1',
            content: storyContent,
            chapterNumber: 1,
          ),
        ],
        createdAt: DateTime.now(),
        settings: StorySettings(
          length: storyLength,
          complexity: creativityLevel,
          characterDetails: _characterController.text.trim(),
          settingEnvironment: _settingController.text.trim(),
          plotStructure: _plotController.text.trim(),
          emotionsTone: _emotionController.text.trim(),
        ),
      );

      // Hikayeyi kaydet
      _storyHistoryViewModel.addStory(newStory);

      // Başarı mesajı göster
      _showSuccessSnackBar('Hikaye başarıyla kaydedildi!');

    } catch (e) {
      _showErrorSnackBar('Hikaye kaydedilirken hata oluştu: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF24FF00),
      ),
    );
  }

  @override
  void dispose() {
    _characterController.dispose();
    _settingController.dispose();
    _plotController.dispose();
    _emotionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Result Image',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Length Selection Buttons
              Row(
                children: [
                  _buildLengthButton('Short', 0),
                  const SizedBox(width: 8),
                  _buildLengthButton('Mid', 1),
                  const SizedBox(width: 8),
                  _buildLengthButton('Long', 2),
                ],
              ),

              const SizedBox(height: 30),

              // Expandable Sections
              _buildExpandableSection(
                'character details',
                'Name, age, personality, appearance.',
                isExpanded1,
                () => setState(() => isExpanded1 = !isExpanded1),
              ),

              const SizedBox(height: 16),

              _buildExpandableSection(
                'setting and environment',
                'Location, atmosphere.',
                isExpanded2,
                () => setState(() => isExpanded2 = !isExpanded2),
              ),

              const SizedBox(height: 16),

              _buildExpandableSection(
                'plot structure',
                'Beginning, development, conflict, resolution.',
                isExpanded3,
                () => setState(() => isExpanded3 = !isExpanded3),
              ),

              const SizedBox(height: 16),

              _buildExpandableSection(
                'emotions and tone',
                "Character's feeling, overall mood of the story.",
                isExpanded4,
                () => setState(() => isExpanded4 = !isExpanded4),
              ),

              const SizedBox(height: 40),

              // Slider Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Standard',
                        style: TextStyle(
                          color: sliderValue <= -0.3 ? Colors.white : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Complex',
                        style: TextStyle(
                          color: sliderValue.abs() <= 0.3 ? Colors.white : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Creative',
                        style: TextStyle(
                          color: sliderValue >= 0.3 ? Colors.white : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 6,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.grey.shade800,
                      thumbColor: Colors.white,
                      overlayColor: Colors.white.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: sliderValue,
                      min: -1,
                      max: 1,
                      divisions: 2,
                      onChanged: (value) {
                        setState(() {
                          sliderValue = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Generate Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _generateStory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLoading
                        ? Colors.grey.shade700
                        : const Color(0xFF24FF00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Text(
                          'Generate',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 40),

              // Generated Story Section
              if (_showStory) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF24FF00),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_stories,
                            color: Color(0xFF24FF00),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Generated Story',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _showStory = false;
                                _generatedStory = '';
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 200),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            _generatedStory,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLengthButton(String text, int index) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedLength = index;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedLength == index
              ? const Color(0xFF24FF00)
              : Colors.grey.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selectedLength == index ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableSection(String title, String subtitle, bool isExpanded, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded ? const Color(0xFF24FF00) : Colors.grey.shade800,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: isExpanded ? const Color(0xFF24FF00) : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              width: double.infinity,
              height: 100,
              margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _getControllerForSection(title),
                decoration: InputDecoration(
                  hintText: 'Enter $title details...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
              ),
            ),
        ],
      ),
    );
  }
}