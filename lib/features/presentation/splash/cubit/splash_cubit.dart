import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
    if (isFirstLaunch) {
      await prefs.setBool('is_first_launch', false);
      emit(SplashFirstOpen());
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emit(SplashAuthenticated());
    } else {
      emit(SplashUnauthenticated());
    }
  }
}
