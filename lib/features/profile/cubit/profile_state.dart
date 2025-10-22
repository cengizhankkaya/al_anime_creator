import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../model/profile_model.dart';
import '../model/profile_failure.dart';

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