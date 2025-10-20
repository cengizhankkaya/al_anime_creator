import 'package:al_anime_creator/features/auth/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository ;
  late final Stream<User?> _authStateChanges;
  AuthCubit(this.authRepository) : super(AuthInitial()) {

    _authStateChanges = authRepository.user;
    _authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthInitial());
      }
    });
  } 

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signIn(email, password);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure('Giriş başarısız.'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.register(email, password);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure('Kayıt başarısız.'));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    await authRepository.signOut();
    emit(AuthInitial());
  }



  
}
