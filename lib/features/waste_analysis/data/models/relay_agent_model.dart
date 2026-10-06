import "../../domain/entities/relay_agent.dart";

class RelayAgentModel extends RelayAgent {
  const RelayAgentModel({
    required super.id,
    required super.displayName,
    required super.relayPointId,
    required super.relayPointName,
    super.serviceHours,
    super.relayPointDescription,
  });

  // Document relay_agents/{uid} : l'id est celui du document.
  factory RelayAgentModel.fromFirestore(String id, Map<String, dynamic> json) {
    return RelayAgentModel.fromJson({...json, "id": id});
  }

  // Copie de l'agent enregistrée dans le ticket.
  factory RelayAgentModel.fromJson(Map<String, dynamic> json) {
    return RelayAgentModel(
      id: json["id"] as String,
      displayName: json["displayName"] as String? ?? "",
      relayPointId: json["relayPointId"] as String? ?? "",
      relayPointName: json["relayPointName"] as String? ?? "",
      serviceHours: json["serviceHours"] as String?,
      relayPointDescription: json["relayPointDescription"] as String?,
    );
  }

  // Seulement les 4 champs autorisés par firestore.rules dans le ticket.
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "displayName": displayName,
      "relayPointId": relayPointId,
      "relayPointName": relayPointName,
    };
  }
}
