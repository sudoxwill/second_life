import "exception.dart";
import "failure.dart";

Failure failureMapper(CustomException e) {
  return switch (e) {
    NetworkException() => NetworkFailure(),
    ServerException() => ServerFailure(),
    UnauthenticatedException() => UnauthenticatedFailure(),
    NotRelayAgentException() => NotRelayAgentFailure(),
    TicketNotFoundException() => TicketNotFoundFailure(),
    TicketAlreadyProcessedException() => TicketAlreadyProcessedFailure(),
    TicketExpiredException() => TicketExpiredFailure(),
  };
}
