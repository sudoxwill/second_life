import "package:equatable/equatable.dart";

class RelayAgent extends Equatable {
  const RelayAgent({
    required this.id,
    required this.displayName,
    required this.relayPointId,
    required this.relayPointName,
    this.serviceHours,
    this.relayPointDescription,
  });
  final String id;
  final String displayName;
  final String relayPointId;
  final String relayPointName;
  // Facultatifs, lus seulement dans relay_agents/{uid} : ils ne sont pas
  // copiés dans le ticket (firestore.rules n'y accepte que les 4 champs).
  final String? serviceHours;
  final String? relayPointDescription;

  @override
  List<Object?> get props => [
    id,
    displayName,
    relayPointId,
    relayPointName,
    serviceHours,
    relayPointDescription,
  ];
}
