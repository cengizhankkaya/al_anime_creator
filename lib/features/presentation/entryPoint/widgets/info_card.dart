import 'package:al_anime_creator/features/core/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.name,
    required this.bio,
    this.avatarUrl,
  });

  final String name, bio;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.of(context).limegreen,
        backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
            ? NetworkImage(avatarUrl!)
            : null,
        child: avatarUrl == null || avatarUrl!.isEmpty
            ?  Icon(
                CupertinoIcons.person,
                color: AppColors.of(context).blackd,
              )
            : null,
      ),
        title: Text(
          name,
          style: TextStyle(color: AppColors.of(context).white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          bio,
          style: TextStyle(color: AppColors.of(context).white.withValues(alpha: 0.7)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
    );
  }
}
