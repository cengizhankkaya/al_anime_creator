import 'package:al_anime_creator/features/profile/model/profile_model.dart';
import 'package:al_anime_creator/features/profile/utils/profile_constants.dart';
import 'package:flutter/material.dart';

/// Kullanıcı profil bilgilerini gösteren header widget'ı
class ProfileHeaderWidget extends StatelessWidget {
  final UserProfile user;

  const ProfileHeaderWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(ProfileConstants.defaultPadding),
      padding: const EdgeInsets.all(ProfileConstants.defaultPadding),
      decoration: BoxDecoration(
        color: const Color(ProfileConstants.secondaryBackgroundColor),
        borderRadius: BorderRadius.circular(ProfileConstants.largeBorderRadius),
      ),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: ProfileConstants.defaultPadding),
          Expanded(
            child: _buildUserInfo(),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: ProfileConstants.avatarSize,
      height: ProfileConstants.avatarSize,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: ProfileConstants.avatarIconSize,
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: ProfileConstants.nameFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          user.email,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: ProfileConstants.subtitleFontSize,
          ),
        ),
      ],
    );
  }
}
