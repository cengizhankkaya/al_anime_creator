import 'package:al_anime_creator/features/core/index.dart';
import 'package:flutter/material.dart';

class StoryFilterDialog extends StatelessWidget {
  final bool showOnlyFavorites;
  final ValueChanged<bool> onFilterChanged;

  const StoryFilterDialog({
    super.key,
    required this.showOnlyFavorites,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      title: Text(
        'Filtrele',
        style: TextStyle(color: AppColors.of(context).white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              'Tüm Hikayeler',
              style: TextStyle(color: AppColors.of(context).white),
            ),
            leading: Radio<bool>(
              value: false,
              groupValue: showOnlyFavorites,
              onChanged: (value) {
                onFilterChanged(value!);
                Navigator.of(context).pop();
              },
              activeColor: AppColors.of(context).limegreen,
            ),
          ),
          ListTile(
            title: Text(
              'Sadece Favoriler',
              style: TextStyle(color: AppColors.of(context).white),
            ),
            leading: Radio<bool>(
              value: true,
              groupValue: showOnlyFavorites,
              onChanged: (value) {
                onFilterChanged(value!);
                Navigator.of(context).pop();
              },
              activeColor: AppColors.of(context).limegreen,
            ),
          ),
        ],
      ),
    );
  }

  static void show(BuildContext context, {
    required bool showOnlyFavorites,
    required ValueChanged<bool> onFilterChanged,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StoryFilterDialog(
          showOnlyFavorites: showOnlyFavorites,
          onFilterChanged: onFilterChanged,
        );
      },
    );
  }
}

