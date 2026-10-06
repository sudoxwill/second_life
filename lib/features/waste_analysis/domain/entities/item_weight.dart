import "package:equatable/equatable.dart";

class ItemWeight extends Equatable {
  const ItemWeight({
    required this.estimatedWeight,
    required this.estimatedMinWeight,
    required this.estimatedMaxWeight,
    required this.estimationBasis,
  });
  final double estimatedWeight;
  final double estimatedMinWeight;
  final double estimatedMaxWeight;
  final String estimationBasis;

  @override
  List<Object?> get props => [
    estimatedWeight,
    estimatedMinWeight,
    estimatedMaxWeight,
    estimationBasis,
  ];
}
