import "../../l10n/app_localizations.dart";
import "failure.dart";

// Message affiché à l'utilisateur pour une Failure.
String failureMessage(AppLocalizations l10n, Object error) {
  return switch (error) {
    NetworkFailure() => l10n.errorNetwork,
    ServerFailure() => l10n.errorServer,
    UnauthenticatedFailure() => l10n.errorUnauthenticated,
    NotRelayAgentFailure() => l10n.errorNotRelayAgent,
    TicketNotFoundFailure() => l10n.errorTicketNotFound,
    TicketAlreadyProcessedFailure() => l10n.errorTicketAlreadyProcessed,
    TicketExpiredFailure() => l10n.errorTicketExpired,
    InvalidTicketCodeFailure() => l10n.errorInvalidTicketCode,
    InvalidWeightFailure() => l10n.errorInvalidWeight,
    CommentRequiredFailure() => l10n.errorCommentRequired,
    CommentTooLongFailure() => l10n.errorCommentTooLong,
    InsufficientPointsFailure() => l10n.rewardsErrorInsufficient,
    RewardOutOfStockFailure() => l10n.rewardsErrorOutOfStock,
    RewardUnavailableFailure() => l10n.rewardsErrorGeneric,
    _ => l10n.errorUnexpected,
  };
}
