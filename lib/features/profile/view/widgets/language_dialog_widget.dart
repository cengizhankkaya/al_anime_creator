import 'package:flutter/material.dart';
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
      backgroundColor: const Color(ProfileConstants.secondaryBackgroundColor),
      title: const Text(
        ProfileConstants.selectLanguageTitle,
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: ProfileConstants.supportedLanguages.map((language) {
          return ListTile(
            title: Text(
              language,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: language == currentLanguage
                ? const Icon(
                    Icons.check,
                    color: Color(ProfileConstants.primaryAccentColor),
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
