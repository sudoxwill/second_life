import "package:dartz/dartz.dart";

import "../../../core/errors/failure.dart";
import "../repositories/notifications_repository.dart";
import "usecase.dart";

class MarkAllNotificationsRead
    implements Usecase<Either<Failure, Unit>, Iterable<String>> {
  new(this.repository);
  final NotificationsRepository repository;

  @override
  Future<Either<Failure, Unit>> call(Iterable<String> ids) =>
      repository.markAllRead(ids);
}
