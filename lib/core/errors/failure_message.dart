import "failure.dart";

// Message affiché à l'utilisateur pour une Failure.
String failureMessage(Object error) {
  return switch (error) {
    NetworkFailure() => "Connexion impossible. Vérifiez votre réseau.",
    ServerFailure() => "Le service est indisponible. Réessayez plus tard.",
    UnauthenticatedFailure() => "Session expirée. Relancez l’application.",
    NotRelayAgentFailure() => "Ce compte n’est pas un agent relais actif.",
    TicketNotFoundFailure() => "Dépôt introuvable.",
    TicketAlreadyProcessedFailure() => "Ce dépôt a déjà été traité.",
    TicketExpiredFailure() => "Ce dépôt a expiré (plus de 48 h).",
    InvalidTicketCodeFailure() => "Ce QR code n’est pas un dépôt.",
    InvalidWeightFailure() => "Poids invalide (entre 0 et 50 kg).",
    CommentRequiredFailure() => "Un commentaire est obligatoire.",
    CommentTooLongFailure() => "Commentaire trop long (500 caractères max).",
    _ => "Une erreur inattendue est survenue.",
  };
}
