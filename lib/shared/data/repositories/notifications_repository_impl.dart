import "package:dartz/dartz.dart";
import "package:firebase_core/firebase_core.dart";

import "../../../core/errors/exception.dart";
import "../../../core/errors/exceptions_mapper.dart";
import "../../../core/errors/failure.dart";
import "../../../core/errors/failures_mapper.dart";
import "../../domain/entities/app_notification.dart";
import "../../domain/repositories/notifications_repository.dart";
import "../sources/notifications_remote_source.dart";

class NotificationsRepositoryImpl implements NotificationsRepository {
  new(this.remoteSource);
  final NotificationsRemoteSource remoteSource;

  @override
  Stream<List<AppNotification>> watchMine() => remoteSource.watchMine();

  @override
  Future<Either<Failure, Unit>> markRead(String id) =>
      _guard(() => remoteSource.markRead(id));

  @override
  Future<Either<Failure, Unit>> markAllRead(Iterable<String> ids) =>
      _guard(() => remoteSource.markAllRead(ids));

  Future<Either<Failure, Unit>> _guard(Future<void> Function() action) async {
    try {
      await action();
      return const Right(unit);
    } on CustomException catch (e) {
      return Left(failureMapper(e));
    } on FirebaseException catch (e) {
      return Left(failureMapper(firebaseExceptionMapper(e)));
    } catch (_) {
      return Left(UnExpectedFailure());
    }
  }
}
