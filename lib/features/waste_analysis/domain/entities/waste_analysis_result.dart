import "package:equatable/equatable.dart";

import "detected_item.dart";
import "item_recyclability.dart";
import "item_weight.dart";

class WasteAnalysisResult extends Equatable {
  const WasteAnalysisResult({
    required this.detectedItem,
    required this.itemWeight,
    required this.itemRecyclability,
    required this.warnings,
  });
  final DetectedItem detectedItem;
  final ItemWeight itemWeight;
  final ItemRecyclability itemRecyclability;
  final List<String> warnings;

  @override
  List<Object?> get props => [
    detectedItem,
    itemWeight,
    itemRecyclability,
    warnings,
  ];
}
