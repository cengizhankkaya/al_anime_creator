import 'package:al_anime_creator/features/data/models/profile_failure.dart';
import 'package:al_anime_creator/features/data/models/profile_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


@immutable
sealed class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  final UserProfile user;

  const ProfileLoaded(this.user);
  
  @override
  List<Object?> get props => [user];
}

final class ProfileError extends ProfileState {
  final ProfileFailure failure;

  const ProfileError(this.failure);
  
  @override
  List<Object?> get props => [failure];
}