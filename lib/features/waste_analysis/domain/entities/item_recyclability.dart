import "package:equatable/equatable.dart";

class ItemRecyclability extends Equatable {
  const ItemRecyclability({
    required this.isRecyclable,
    required this.sortingInstructions,
    required this.co2SavedGrams,
    required this.pointsEarned,
  });
  final bool isRecyclable;
  final String sortingInstructions;
  final double co2SavedGrams;
  final double pointsEarned;

  @override
  List<Object?> get props => [
    isRecyclable,
    sortingInstructions,
    co2SavedGrams,
    pointsEarned,
  ];
}
