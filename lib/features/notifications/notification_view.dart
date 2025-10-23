

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
      appBar: AppBar(
        title: const Text('Bildirimler'),
        centerTitle: true,
        elevation: 1,
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey),
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
                  color: notif.isUnread ? Colors.blue[50] : null,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Icon(notif.icon, size: 32, color: notif.isUnread ? Colors.blue : Colors.grey),
                    title: Text(notif.title, style: TextStyle(fontWeight: notif.isUnread ? FontWeight.bold : FontWeight.normal)),
                    subtitle: Text(notif.description),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (notif.isUnread)
                          Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          ),
                        const SizedBox(height: 6),
                        Text(notif.time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
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