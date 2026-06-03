import 'dart:math';

import '../constants/app_constants.dart';
import '../models/coil_length_result.dart';

class CoilLengthCalculator {
  const CoilLengthCalculator._();

  static CoilLengthResult calculate({
    required double thicknessLeftOnCoil,
    required double steelThickness,
    required double coilId,
    bool includePlasticThickness = true,
  }) {
    final plasticThickness = includePlasticThickness
        ? AppConstants.plasticThickness
        : 0;

    final totalThickness =
        steelThickness + plasticThickness + AppConstants.airGap;

    if (totalThickness <= 0) {
      return const CoilLengthResult(
        totalThickness: 0,
        subTotal: 0,
        estimatedLengthMillimeters: 0,
        estimatedLengthMeters: 0,
      );
    }

    final subTotal = (thicknessLeftOnCoil / totalThickness) * coilId;
    final estimatedLengthMillimeters = subTotal * pi;
    final estimatedLengthMeters = estimatedLengthMillimeters / 1000;

    return CoilLengthResult(
      totalThickness: totalThickness,
      subTotal: subTotal,
      estimatedLengthMillimeters: estimatedLengthMillimeters,
      estimatedLengthMeters: estimatedLengthMeters,
    );
  }
}
