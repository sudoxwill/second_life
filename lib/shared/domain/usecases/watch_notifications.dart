import "../entities/app_notification.dart";
import "../repositories/notifications_repository.dart";
import "usecase.dart";

// Notifications de l'utilisateur connecté, les plus récentes d'abord.
class WatchNotifications
    implements StreamUsecase<List<AppNotification>, NoParam> {
  new(this.repository);
  final NotificationsRepository repository;

  @override
  Stream<List<AppNotification>> call(NoParam p) => repository.watchMine();
}
