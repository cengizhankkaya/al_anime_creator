import '../repository/notification_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationRepository repository;
  MarkNotificationReadUseCase(this.repository);

  Future<void> call(String userId, String notificationId) async {
    await repository.markAsRead(userId, notificationId);
  }
}
