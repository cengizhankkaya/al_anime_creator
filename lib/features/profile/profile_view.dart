import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';
import 'repository/profile_repository.dart';
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
      child: Scaffold(
        backgroundColor: const Color(ProfileConstants.primaryBackgroundColor),
        appBar: _buildAppBar(context),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return _buildLoadingView();
            }

            if (state is ProfileError) {
              return _buildErrorView(state.failure.message);
            }

            if (state is ProfileLoaded) {
              return _buildProfileContent(state.user);
            }

            return _buildUnknownStateView();
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        ProfileConstants.profileTitle,
        style: TextStyle(
          color: Colors.white,
          fontSize: ProfileConstants.titleFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildUnauthenticatedView(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(ProfileConstants.primaryBackgroundColor),
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
            const Text(
              ProfileConstants.signInRequiredTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: ProfileConstants.nameFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: ProfileConstants.smallPadding),
            const Text(
              ProfileConstants.signInRequiredMessage,
              style: TextStyle(
                color: Colors.grey,
                fontSize: ProfileConstants.subtitleFontSize,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ProfileConstants.defaultPadding),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(ProfileConstants.primaryAccentColor),
                foregroundColor: Colors.black,
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

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(ProfileConstants.primaryAccentColor),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildProfileContent(user) {
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