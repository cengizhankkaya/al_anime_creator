import 'package:al_anime_creator/features/data/repository/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';
import 'utils/profile_constants.dart';
import 'view/widgets/profile_header_widget.dart';
import 'view/widgets/settings_section_widget.dart';

@RoutePage()
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Kullanıcı kimlik doğrulaması kontrolü
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return _buildUnauthenticatedView(context);
    }

    return BlocProvider(
      create: (context) => ProfileCubit(GetIt.instance<ProfileRepository>()),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            // Hata durumunda sadece hata göster, logout işlemi başarılı olursa
            // Firebase auth durum değişikliği onboarding'e yönlendirecek
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: _buildAppBar(context),
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return _buildLoadingView(context);
              }

              if (state is ProfileError) {
                return _buildErrorView(context, state.failure.message);
              }

              if (state is ProfileLoaded) {
                return _buildProfileContent(context, state.user);
              }

              return _buildUnknownStateView();
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      title: Text(
        ProfileConstants.profileTitle,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: ProfileConstants.titleFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildUnauthenticatedView(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: _buildAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              color: Colors.grey,
              size: ProfileConstants.largeIconSize,
            ),
            const SizedBox(height: ProfileConstants.defaultPadding),
            Text(
              ProfileConstants.signInRequiredTitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: ProfileConstants.nameFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: ProfileConstants.smallPadding),
            Text(
              ProfileConstants.signInRequiredMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
                fontSize: ProfileConstants.subtitleFontSize,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ProfileConstants.defaultPadding),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: ProfileConstants.defaultPadding * 1.6,
                  vertical: ProfileConstants.smallPadding * 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ProfileConstants.smallPadding),
                ),
              ),
              onPressed: () {
                // Oturum açma sayfasına yönlendir
                Navigator.of(context).pushNamed('/sign-in');
              },
              child: const Text(
                ProfileConstants.signInButtonText,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, dynamic user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeaderWidget(user: user),
          SettingsSectionWidget(user: user),
          const SizedBox(height: ProfileConstants.largePadding),
        ],
      ),
    );
  }

  Widget _buildUnknownStateView() {
    return const Center(
      child: Text(ProfileConstants.unknownStateMessage),
    );
  }
}