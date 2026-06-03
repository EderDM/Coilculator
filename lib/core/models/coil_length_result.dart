class CoilLengthResult {
  const CoilLengthResult({
    required this.totalThickness,
    required this.subTotal,
    required this.estimatedLengthMillimeters,
    required this.estimatedLengthMeters,
  });

  final double totalThickness;
  final double subTotal;
  final double estimatedLengthMillimeters;
  final double estimatedLengthMeters;
}
