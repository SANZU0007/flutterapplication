import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:testapp/dashboard/Grid_export_card_design.dart';
import 'package:testapp/dashboard/solar_dashboard_card_data.dart';

class Gridexport extends StatelessWidget {
  final String value2;
  final String displayLabel;
  final Map<String, dynamic>? response;

  const Gridexport({
    Key? key,
    required this.value2,
    required this.displayLabel,
    this.response,
  }) : super(key: key);

  // WEATHER_IRRADIATION
  // IRRADIATION_TODAY
  // PR_TODAY

  @override
  Widget build(BuildContext context) {
    // Parse the value to ensure it's a valid number
    double currentValue2 = double.tryParse(value2) ?? 0.0;

    // Ensure the value is within the range of 0 to 100
    currentValue2 = currentValue2.clamp(0.0, 100.0);

    String WEATHER_IRRADIATION = response?['WEATHER_IRRADIATION'] ?? "No data";

    String IRRADIATION = response?['IRRADIATION_TODAY'] ?? "No data";
    String PR_TODAY = response?['PR_TODAY'] ?? "No data";
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: <Widget>[
            // First row with two cards
            Row(
              children: <Widget>[
                // Left side circular gauge
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 205,
                    padding: const EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Displaying "Left" text at top-left and bottom-left
                        Positioned(
                          top: 10,
                          left: 10, // Position "Left" text on the top-left
                          child: Text(
                            WEATHER_IRRADIATION,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        // Displaying "Right" text at top-right and bottom-right
                        Positioned(
                          top: 10,
                          right: 10, // Position "Right" text on the top-right
                          child: Text(
                            '${double.parse(IRRADIATION).toStringAsFixed(1)} Kw/m2',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right:
                              10, // Position "Right" text on the bottom-right
                          child: Text(
                            'PR = $PR_TODAY',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Tooltip(
                          message: '${currentValue2.toStringAsFixed(2)}%',
                          child: SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum: 100,
                                startAngle: 270,
                                endAngle: 630,
                                radiusFactor: 0.75,
                                showTicks: false,
                                showLabels: false,
                                axisLineStyle: AxisLineStyle(
                                  thickness: 0.99,
                                  color: Colors.grey.withOpacity(0.3),
                                  thicknessUnit: GaugeSizeUnit.factor,
                                ),
                                pointers: <GaugePointer>[
                                  RangePointer(
                                    value: currentValue2,
                                    color: Colors.orange,
                                    width: 0.99,
                                    sizeUnit: GaugeSizeUnit.factor,
                                  ),
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                    widget: Center(
                                      child: Text(
                                        '$displayLabel%',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    angle: 270,
                                    positionFactor: 0.5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 5), // Spacing between the cards

                // Right side text container with SolarDashboardCardData
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 220,
                    padding: const EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: GridExportCardData(
                      value1: '20',
                      Apiresponse: response,
                    ),
                  ),
                ),
              ],
            ),

            // Second row with two cards
          ],
        ),
      ),
    );
  }
}
