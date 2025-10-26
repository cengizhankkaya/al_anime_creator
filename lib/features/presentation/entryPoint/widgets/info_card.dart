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
        backgroundColor: Colors.white24,
        backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
            ? NetworkImage(avatarUrl!)
            : null,
        child: avatarUrl == null || avatarUrl!.isEmpty
            ? const Icon(
                CupertinoIcons.person,
                color: Colors.white,
              )
            : null,
      ),
      title: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        bio,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
