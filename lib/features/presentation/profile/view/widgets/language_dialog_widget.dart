
import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../utils/profile_constants.dart';

/// Dil seçimi için dialog widget'ı
class LanguageDialogWidget extends StatelessWidget {
  final String currentLanguage;
  final Function(String) onLanguageSelected;

  const LanguageDialogWidget({
    super.key,
    required this.currentLanguage,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.of(context).sidebarColor.withValues(alpha: 0.9),
      title:  Text(
        ProfileConstants.selectLanguageTitle,
        style: TextStyle(color: AppColors.of(context).white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: ProfileConstants.supportedLanguages.map((language) {
          return ListTile(
            title: Text(
              language,
              style:  TextStyle(color: AppColors.of(context).white),
            ),
            trailing: language == currentLanguage
                ?  Icon(
                    Icons.check,
                    color: AppColors.of(context).limegreen,
                  )
                : null,
            onTap: () {
              onLanguageSelected(language);
              Navigator.of(context).pop();
            },
          );
        }).toList(),
      ),
    );
  }
}
