import '../entities/app_notification_entity.dart';

abstract class NotificationRepository {
  Future<List<AppNotificationEntity>> getNotifications(String userId);
  Future<void> markAsRead(String userId, String notificationId);
  Future<void> deleteNotification(String userId, String notificationId);
}
