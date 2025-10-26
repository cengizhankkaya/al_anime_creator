import 'package:al_anime_creator/features/data/repository/auth_repository.dart';
import 'package:al_anime_creator/features/data/repository/profile_repository.dart';
import 'package:al_anime_creator/features/data/repository/story_generation_repository.dart';
import 'package:al_anime_creator/features/data/repository/story_repository.dart';
import 'package:al_anime_creator/features/core/network/firestore_service.dart';
import 'package:al_anime_creator/features/presentation/storyhistory/cubit/story_firestore_cubit.dart';
import 'package:al_anime_creator/features/presentation/entryPoint/cubit/sidebar_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:al_anime_creator/firebase_options.dart';
import 'package:al_anime_creator/features/core/network/ai_service.dart';
import 'package:al_anime_creator/features/presentation/storygeneration/cubit/story_generation_cubit.dart';


final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Firebase Core initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final GenerativeModel aiModel = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.0-flash-001',
  );

  // Firestore Service
  getIt.registerSingleton<FirestoreService>(
    FirestoreService(),
  );

  // AI Service
  getIt.registerSingleton<AIService>(
    AIServiceImpl(aiModel),
  );

  // Story Repository
  getIt.registerSingleton<StoryRepository>(
    StoryRepositoryImpl(getIt<FirestoreService>()),
  );

  // Story Firestore Cubit: factory olmalı, ekranlar arası kapatılan singleton sorun çıkarır
  getIt.registerFactory<StoryFirestoreCubit>(
    () => StoryFirestoreCubit(getIt<StoryRepository>()),
  );

  // Story History ViewModel removed

  // Story Generation Repository
  getIt.registerSingleton<StoryGenerationRepository>(
    StoryGenerationRepositoryImpl(
      getIt<AIService>(),
      getIt<FirestoreService>(),
    ),
  );

  // Story Generation Cubit
  getIt.registerFactory<StoryGenerationCubit>(
    () => StoryGenerationCubit(getIt<StoryGenerationRepository>()),
  );

  // Profile Repository
  getIt.registerSingleton<ProfileRepository>(
    ProfileRepositoryImpl(),
  );

  // Auth Repository
  getIt.registerSingleton<AuthRepository>(
    AuthRepository(),
  );

  // Sidebar Cubit
  getIt.registerFactory<SidebarCubit>(
    () => SidebarCubit(getIt<ProfileRepository>()),
  );

}

