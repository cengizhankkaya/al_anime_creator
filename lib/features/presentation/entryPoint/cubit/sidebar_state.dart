import 'package:al_anime_creator/features/data/models/profile_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
sealed class SidebarState extends Equatable {
  const SidebarState();

  @override
  List<Object?> get props => [];
}

final class SidebarInitial extends SidebarState {
  const SidebarInitial();
}

final class SidebarLoading extends SidebarState {
  const SidebarLoading();
}

final class SidebarLoaded extends SidebarState {
  final UserProfile userProfile;

  const SidebarLoaded(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

final class SidebarError extends SidebarState {
  final String message;

  const SidebarError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Kullanıcı çıkış yaptığında
final class SidebarUnauthenticated extends SidebarState {
  const SidebarUnauthenticated();
}
