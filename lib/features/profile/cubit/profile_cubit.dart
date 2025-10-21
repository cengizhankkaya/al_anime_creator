import 'package:meta/meta.dart';
import '../model/profile_model.dart';


@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final UserProfile user;

  ProfileLoaded(this.user);
}

final class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
