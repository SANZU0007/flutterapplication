import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:testapp/colors.dart';

class DashboardCard extends StatelessWidget {
  final String value1;
  final String value2;
  final String displayLabal;

  const DashboardCard({
    Key? key,
    required this.value1,
    required this.value2,
    required this.displayLabal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse the values to ensure they are valid numbers
    double currentValue1 = double.tryParse(value1) ?? 0.0;
    double currentValue2 = double.tryParse(value2) ?? 0.0;

    // Ensure the maximum is 100% for both circles
    currentValue1 = currentValue1.clamp(0.0, 100.0);
    currentValue2 = currentValue2.clamp(0.0, 100.0);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Value 1: $value1",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Value 2: $value2",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            // Separate Circular Gauges for Value 1 and Value 2
            Tooltip(
              message: '${currentValue1.toStringAsFixed(2)}%',
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  // First Circle Gauge for Value 1 (Full 360 degrees)
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    startAngle: 270, // Start from the bottom (270 degrees)
                    endAngle: 630, // 360 degrees (opposite side)
                    radiusFactor: 0.75, // Reduced gap between the two circles
                    showTicks: false,
                    showLabels: false,
                    axisLineStyle: const AxisLineStyle(
                      thickness: 0.07,
                      color: transparentWhite,
                      thicknessUnit: GaugeSizeUnit.factor,
                    ),
                    pointers: <GaugePointer>[
                      RangePointer(
                        value: currentValue1,
                        color: Colors.orange,
                        width: 0.1,
                        sizeUnit: GaugeSizeUnit.factor,
                        cornerStyle: CornerStyle.bothCurve,
                      ),
                    ],
                    annotations: <GaugeAnnotation>[],
                  ),
                  // Second Circle Gauge for Value 2 (Full 360 degrees)
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    startAngle: 270, // Start from the bottom (270 degrees)
                    endAngle: 630, // 360 degrees (opposite side)
                    radiusFactor:
                        0.69, // Adjusted to make it closer to the first circle
                    showTicks: false,
                    showLabels: false,
                    axisLineStyle: const AxisLineStyle(
                      thickness: 0.08,
                      color: transparentWhite,
                      thicknessUnit: GaugeSizeUnit.factor,
                    ),
                    pointers: <GaugePointer>[
                      RangePointer(
                        value: currentValue2,
                        color: Colors.orange.withOpacity(0.6),
                        width: 0.08,
                        sizeUnit: GaugeSizeUnit.factor,
                        cornerStyle: CornerStyle.bothCurve,
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Center(
                          child: Text(
                            '${displayLabal}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        angle: 270, // Start from the bottom for annotation
                        positionFactor: 0.1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
