part of 'splash_cubit.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashAuthenticated extends SplashState {}
class SplashUnauthenticated extends SplashState {}
class SplashFirstOpen extends SplashState {}
