import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/profile_cubit.dart';
import '../../model/profile_model.dart';
import '../../utils/profile_constants.dart';
import 'language_dialog_widget.dart';
import 'theme_dialog_widget.dart';

/// Genel ayarlar bölümünü gösteren widget
class SettingsSectionWidget extends StatelessWidget {
  final UserProfile user;

  const SettingsSectionWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(ProfileConstants.generalSectionTitle),
        _buildLanguageSetting(context),
        const SizedBox(height: ProfileConstants.smallPadding),
        _buildThemeSetting(context),
        const SizedBox(height: ProfileConstants.defaultPadding),
        _buildSectionTitle(ProfileConstants.contentSectionTitle),
        _buildAboutSetting(context),
        const SizedBox(height: ProfileConstants.smallPadding),
        _buildPrivacySetting(context),
        const SizedBox(height: ProfileConstants.smallPadding),
        _buildTermsSetting(context),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: ProfileConstants.defaultPadding,
        bottom: ProfileConstants.smallPadding,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: ProfileConstants.sectionTitleFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLanguageSetting(BuildContext context) {
    return _buildSettingTile(
      icon: Icons.translate,
      title: ProfileConstants.languageTitle,
      subtitle: user.settings.language,
      onTap: () => _showLanguageDialog(context),
    );
  }

  Widget _buildThemeSetting(BuildContext context) {
    return _buildSettingTile(
      icon: Icons.dark_mode,
      title: ProfileConstants.themeTitle,
      subtitle: user.settings.theme,
      onTap: () => _showThemeDialog(context),
    );
  }

  Widget _buildAboutSetting(BuildContext context) {
    return _buildSettingTile(
      icon: Icons.info_outline,
      title: ProfileConstants.aboutTitle,
      onTap: () {
        // Hakkımızda sayfasına git
      },
    );
  }

  Widget _buildPrivacySetting(BuildContext context) {
    return _buildSettingTile(
      icon: Icons.privacy_tip,
      title: ProfileConstants.privacyTitle,
      onTap: () {
        // Gizlilik politikası sayfasına git
      },
    );
  }

  Widget _buildTermsSetting(BuildContext context) {
    return _buildSettingTile(
      icon: Icons.description,
      title: ProfileConstants.termsTitle,
      onTap: () {
        // Kullanım koşulları sayfasına git
      },
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ProfileConstants.defaultPadding),
      decoration: BoxDecoration(
        color: const Color(ProfileConstants.secondaryBackgroundColor),
        borderRadius: BorderRadius.circular(ProfileConstants.borderRadius),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(color: Colors.grey),
              )
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: ProfileConstants.smallIconSize,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LanguageDialogWidget(
        currentLanguage: user.settings.language,
        onLanguageSelected: (language) {
          context.read<ProfileCubit>().updateLanguage(language);
        },
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ThemeDialogWidget(
        currentTheme: user.settings.theme,
        onThemeSelected: (theme) {
          context.read<ProfileCubit>().updateTheme(theme);
        },
      ),
    );
  }
}
