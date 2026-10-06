import "package:equatable/equatable.dart";

class DetectedItem extends Equatable {
  const DetectedItem({
    required this.itemLabel,
    required this.itemMainCategory,
    required this.itemsubCategory,
    required this.itemconfidenceScore,
  });
  final String itemLabel;
  final String itemMainCategory;
  final String itemsubCategory;
  final double itemconfidenceScore;

  @override
  List<Object?> get props => [
    itemLabel,
    itemMainCategory,
    itemsubCategory,
    itemconfidenceScore,
  ];
}
