import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Inverterdashboard extends StatelessWidget {
  final String value1;
  final String value2;
  final String displayLabal;
  final int no_Of_Solar_Strings;
  final List<dynamic> inverterData;

  const Inverterdashboard({
    Key? key,
    required this.value1,
    required this.value2,
    required this.displayLabal,
    required this.inverterData,
    required this.no_Of_Solar_Strings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: no_Of_Solar_Strings,
      itemBuilder: (context, index) {
        final item = inverterData[index];
        final powerValue =
            double.tryParse(item['POWER_GAUGE']?.toString() ?? '0') ?? 0;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 0.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 0.0), // Removed extra padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with inverter name and capacity
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(0.0),
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors
                        .blueAccent, // Use a slightly different blue or gradient
                    borderRadius: BorderRadius.circular(1), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    '${item['INVERTER_NAME'] ?? 'N/A'} | ${item['CAPACITY_DASHBAORD'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors
                          .white, // Ensure the text is readable on the blue background
                      letterSpacing: 1.2, // Spacing for better readability
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),

                // Row for Gauge and Text data
                Row(
                  children: [
                    // Column for Gauge
                    Expanded(
                      flex: 1,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Container(
                          height: 90, // Set a fixed height for the gauge card
                          child: SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum: 100,
                                startAngle:
                                    270, // Start from the bottom (270 degrees)
                                endAngle:
                                    630, // Full 360 degrees (opposite side)
                                radiusFactor: 0.75, // Size of the gauge
                                showTicks: false,
                                showLabels: false,
                                axisLineStyle: AxisLineStyle(
                                  thickness: 0.99,
                                  color: Colors.grey.withOpacity(
                                      0.3), // Background circle color
                                  thicknessUnit: GaugeSizeUnit.factor,
                                ),
                                pointers: <GaugePointer>[
                                  // Full circle that fills up
                                  RangePointer(
                                    value: powerValue,
                                    color: Colors.orange, // Full circle color
                                    width: 1.00,
                                    sizeUnit: GaugeSizeUnit.factor,
                                  ),
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                    widget: Center(
                                      child: Text(
                                        '${item['POWER_DASHBOARD']}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    angle:
                                        270, // Start from the bottom for annotation
                                    positionFactor: 0.5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Column for Text Data
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row 1 - Create 3 cards for 3 text items
                            LayoutBuilder(
                              builder: (context, constraints) {
                                bool isSmallScreen = constraints.maxWidth < 600;
                                return Wrap(
                                  alignment: isSmallScreen
                                      ? WrapAlignment.start
                                      : WrapAlignment.spaceBetween,
                                  spacing: isSmallScreen
                                      ? 8.0
                                      : 16.0, // Adjust spacing for smaller screens
                                  runSpacing: 8.0, // Adjust vertical spacing
                                  children: [
                                    // Card 1
                                    Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'PR',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[600]),
                                            ),
                                            Text(
                                              '${item['PR'] ?? 'N/A'}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Card 2
                                    Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'E Today:',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[600]),
                                            ),
                                            Text(
                                              '${item['ENERGY_TODAY_DASHBOARD'] ?? 'N/A'}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Card 3
                                    Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'E Month',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[600]),
                                            ),
                                            Text(
                                              '${item['ENERGY_THIS_MONTH_DASHBOARD'] ?? 'N/A'}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 2),
                            // Row 2 - Create 3 more cards for 3 more text items
                            LayoutBuilder(
                              builder: (context, constraints) {
                                bool isSmallScreen = constraints.maxWidth < 600;
                                return Wrap(
                                  alignment: isSmallScreen
                                      ? WrapAlignment.start
                                      : WrapAlignment.spaceBetween,
                                  spacing: isSmallScreen
                                      ? 8.0
                                      : 16.0, // Adjust spacing for smaller screens
                                  runSpacing: 8.0, // Adjust vertical spacing
                                  children: [
                                    // Card 4
                                    Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'GF',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[600]),
                                            ),
                                            Text(
                                              '${item['GF'] ?? 'N/A'}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Card 5
                                    Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'E Yesterday',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[600]),
                                            ),
                                            Text(
                                              '${item['ENERGY_YESTERDAY_DASHBOARD'] ?? 'N/A'}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Card 6
                                    Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'E Total',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[600]),
                                            ),
                                            Text(
                                              '${item['ENERGY_TOTAL_DASHBOARD'] ?? 'N/A'}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
