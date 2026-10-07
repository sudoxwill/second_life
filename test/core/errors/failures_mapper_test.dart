import "package:flutter_test/flutter_test.dart";
import "package:second_life/core/errors/exception.dart";
import "package:second_life/core/errors/failure.dart";
import "package:second_life/core/errors/failures_mapper.dart";

void main() {
  test("chaque exception métier a sa Failure", () {
    expect(failureMapper(NetworkException()), isA<NetworkFailure>());
    expect(
      failureMapper(TicketExpiredException()),
      isA<TicketExpiredFailure>(),
    );
    expect(
      failureMapper(InsufficientPointsException()),
      isA<InsufficientPointsFailure>(),
    );
    expect(
      failureMapper(RewardOutOfStockException()),
      isA<RewardOutOfStockFailure>(),
    );
    expect(
      failureMapper(RewardUnavailableException()),
      isA<RewardUnavailableFailure>(),
    );
  });
}
