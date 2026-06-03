import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/models/coil_length_result.dart';
import '../../core/utils/coil_length_calculator.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _thicknessLeftController = TextEditingController(
    text: '60',
  );

  double _selectedSteelThickness = AppConstants.steelThicknessOptions[2];
  CoilLengthResult? _result;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _thicknessLeftController.dispose();
    super.dispose();
  }

  void _calculate() {
    final thicknessLeft = double.tryParse(_thicknessLeftController.text.trim());

    if (thicknessLeft == null || thicknessLeft <= 0) {
      setState(() {
        _result = null;
        _errorText = 'Enter a valid thickness left on coil value.';
      });
      return;
    }

    setState(() {
      _result = CoilLengthCalculator.calculate(
        thicknessLeftOnCoil: thicknessLeft,
        steelThickness: _selectedSteelThickness,
      );
      _errorText = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeaderCard(colorScheme: colorScheme),
                    const SizedBox(height: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Calculator',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _thicknessLeftController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Thickness left on coil (mm)',
                                hintText: 'Enter thickness left on coil',
                              ),
                              onChanged: (_) => _calculate(),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<double>(
                              value: _selectedSteelThickness,
                              decoration: const InputDecoration(
                                labelText: 'Steel thickness (mm)',
                              ),
                              items: AppConstants.steelThicknessOptions
                                  .map(
                                    (value) => DropdownMenuItem<double>(
                                      value: value,
                                      child: Text(value.toStringAsFixed(2)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }

                                setState(() {
                                  _selectedSteelThickness = value;
                                });
                                _calculate();
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _ConstantTile(
                                    label: 'Plastic thickness',
                                    value: AppConstants.plasticThickness
                                        .toStringAsFixed(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _ConstantTile(
                                    label: 'Air gap',
                                    value: AppConstants.airGap.toStringAsFixed(
                                      2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _ConstantTile(
                              label: 'Coil I.D. (mm)',
                              value: AppConstants.coilId.toStringAsFixed(0),
                            ),
                            const SizedBox(height: 20),
                            // FilledButton.icon(
                            //   onPressed: _calculate,
                            //   icon: const Icon(Icons.calculate_outlined),
                            //   label: const Text('Calculate length'),
                            // ),
                            if (_errorText != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                _errorText!,
                                style: TextStyle(
                                  color: colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      color: colorScheme.primaryContainer.withOpacity(0.55),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estimated Length',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _result == null
                                  ? '--'
                                  : '${_result!.estimatedLengthMeters.toStringAsFixed(2)} m',
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _MetricChip(
                                  label: 'Total thickness',
                                  value: _result == null
                                      ? '--'
                                      : _result!.totalThickness.toStringAsFixed(
                                          2,
                                        ),
                                ),
                                _MetricChip(
                                  label: 'Subtotal',
                                  value: _result == null
                                      ? '--'
                                      : _result!.subTotal.toStringAsFixed(2),
                                ),
                                _MetricChip(
                                  label: 'Length (mm)',
                                  value: _result == null
                                      ? '--'
                                      : _result!.estimatedLengthMillimeters
                                            .toStringAsFixed(2),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Version 1 keeps the calculator local and does not require login. Future versions can add save history, authentication, and synced records.',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coil Length Calculator',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Estimate coil length from thickness left.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.92),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConstantTile extends StatelessWidget {
  const _ConstantTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
