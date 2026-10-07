import "package:dartz/dartz.dart";

import "../../../core/errors/failure.dart";
import "../repositories/notifications_repository.dart";
import "usecase.dart";

class MarkNotificationRead implements Usecase<Either<Failure, Unit>, String> {
  new(this.repository);
  final NotificationsRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String id) => repository.markRead(id);
}
