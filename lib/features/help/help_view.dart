import 'package:al_anime_creator/product/init/theme/index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.of(context).transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Yardım',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _HelpCard(
            icon: Icons.info_outline,
            title: 'Uygulama Hakkında',
            description: 'Bu uygulama ile kendi anime hikayelerinizi kolayca oluşturabilirsiniz.',
          ),
          const SizedBox(height: 18),
          _HelpCard(
            icon: Icons.help_outline,
            title: 'Nasıl Kullanılır?',
            description: 'Menüden hikaye oluşturucuya girerek hikayenizi başlatabilirsiniz. Adım adım yönergeleri takip edin.',
          ),
          const SizedBox(height: 18),
          _HelpCard(
            icon: Icons.security,
            title: 'Gizlilik',
            description: 'Verileriniz gizli tutulur ve üçüncü kişilerle paylaşılmaz.',
          ),
          const SizedBox(height: 18),
          _HelpCard(
            icon: Icons.contact_support,
            title: 'Destek',
            description: 'Herhangi bir sorun yaşarsanız bize ulaşın: destek@animeapp.com',
          ),
        ],
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const _HelpCard({
    required this.icon,
    required this.title,
    required this.description,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.of(context).bacgroundblue,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color:AppColors.of(context).limegreen, size: 32),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
