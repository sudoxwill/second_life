import "package:dartz/dartz.dart";

import "../../../core/errors/failure.dart";
import "../entities/app_notification.dart";

abstract class NotificationsRepository {
  Stream<List<AppNotification>> watchMine();
  Future<Either<Failure, Unit>> markRead(String id);
  Future<Either<Failure, Unit>> markAllRead(Iterable<String> ids);
}
