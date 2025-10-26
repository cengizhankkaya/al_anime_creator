class AppNotificationEntity {
  final String id;
  final String title;
  final String body;
  final DateTime sentAt;
  final bool isRead;

  const AppNotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.sentAt,
    this.isRead = false,
  });
}
