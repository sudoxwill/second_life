class Failure {}

class NetworkFailure extends Failure {}

class ServerFailure extends Failure {}

class UnExpectedFailure extends Failure {}

class UnauthenticatedFailure extends Failure {}

class NotRelayAgentFailure extends Failure {}

class TicketNotFoundFailure extends Failure {}

class TicketAlreadyProcessedFailure extends Failure {}

class TicketExpiredFailure extends Failure {}

class InvalidTicketCodeFailure extends Failure {}

class InvalidWeightFailure extends Failure {}

class CommentRequiredFailure extends Failure {}

class CommentTooLongFailure extends Failure {}

class InsufficientPointsFailure extends Failure {}

class RewardOutOfStockFailure extends Failure {}

class RewardUnavailableFailure extends Failure {}
