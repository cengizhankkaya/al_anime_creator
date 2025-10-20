import 'package:get_it/get_it.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:al_anime_creator/firebase_options.dart';
import 'package:al_anime_creator/features/storygeneration/service/ai_service.dart';
import 'package:al_anime_creator/features/storygeneration/repository/story_generation_repository.dart';
import 'package:al_anime_creator/features/storyHistory/view_model/story_history_viewmodel.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Firebase AI Service
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final GenerativeModel aiModel = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.0-flash-001',
  );

  getIt.registerSingleton<AIService>(
    AIServiceImpl(aiModel),
  );

  // Story History ViewModel
  getIt.registerSingleton<StoryHistoryViewModel>(
    StoryHistoryViewModel(),
  );

  // Story Generation Repository
  getIt.registerSingleton<StoryGenerationRepository>(
    StoryGenerationRepositoryImpl(
      getIt<AIService>(),
      getIt<StoryHistoryViewModel>(),
    ),
  );
}
