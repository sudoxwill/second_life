import "package:equatable/equatable.dart";

enum AppNotificationType {
  welcome,
  depositValidated,
  depositRejected,
  voucherRedeemed,
  unknown;

  static AppNotificationType fromName(String? name) =>
      values.asNameMap()[name] ?? AppNotificationType.unknown;
}

// Notification in-app. Seuls le type et ses données sont stockés : le texte
// est traduit au moment de l'affichage.
class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.type,
    required this.data,
    required this.read,
    required this.createdAt,
  });

  final String id;
  final AppNotificationType type;
  final Map<String, dynamic> data;
  final bool read;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, type, read, createdAt];
}
