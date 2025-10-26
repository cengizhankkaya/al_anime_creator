import 'package:flutter/material.dart';
import '../../utils/profile_constants.dart';

/// Tema seçimi için dialog widget'ı
class ThemeDialogWidget extends StatelessWidget {
  final String currentTheme;
  final Function(String) onThemeSelected;

  const ThemeDialogWidget({
    super.key,
    required this.currentTheme,
    required this.onThemeSelected,
  });
 
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      title: Text(
        ProfileConstants.selectThemeTitle,
        style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: ProfileConstants.supportedThemes.map((theme) {
          return ListTile(
            title: Text(
              theme,
              style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
            trailing: theme == currentTheme
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : null,
            onTap: () {
              onThemeSelected(theme);
              Navigator.of(context).pop();
            },
          );
        }).toList(),
      ),
    );
  }
}
