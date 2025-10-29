

import 'package:al_anime_creator/features/core/index.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class NotificationItem {
  final IconData icon;
  final String title;
  final String description;
  final String time;
  final bool isUnread;

  NotificationItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    this.isUnread = false,
  });
}

class _NotificationViewState extends State<NotificationView> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      icon: Icons.mail,
      title: 'Yeni Mesaj',
      description: 'Birisi sana mesaj gönderdi.',
      time: 'Az önce',
      isUnread: true,
    ),
    NotificationItem(
      icon: Icons.update,
      title: 'Güncelleme Başarılı',
      description: 'Uygulaman güncellendi.',
      time: '1 saat önce',
    ),
    NotificationItem(
      icon: Icons.person,
      title: 'Yeni Takipçi',
      description: 'Bir kullanıcı seni takip etti.',
      time: 'Dün',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.of(context).bacgroundblue,
      appBar: AppBar(
        backgroundColor: AppColors.of(context).transparent,
        elevation: 0,
        title: Text(
          'Bildirimler',
          style: TextStyle(
            color: AppColors.of(context).white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Icon(Icons.notifications_none, size: 64, color:AppColors.of(context).limegreen),
                  SizedBox(height: 16),
                  Text(
                    'Henüz bildirimin yok',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notif = _notifications[index];
                return Card(
                  color: AppColors.of(context).limegreen.withValues(alpha: 0.1),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: notif.isUnread 
                          ? AppColors.of(context).limegreen.withOpacity(0.3)
                          : Colors.grey.shade800,
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      notif.icon,
                      size: 32,
                      color: notif.isUnread
                          ? AppColors.of(context).limegreen
                          : Colors.grey,
                    ),
                    title: Text(
                      notif.title,
                      style: TextStyle(
                        color: AppColors.of(context).white,
                        fontWeight: notif.isUnread ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      notif.description,
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (notif.isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.of(context).limegreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          notif.time,
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                );
              },
            ),
    );
  }
}