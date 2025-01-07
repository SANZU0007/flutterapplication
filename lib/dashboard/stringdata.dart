import 'package:flutter/material.dart';
import 'package:testapp/colors.dart';
import 'package:testapp/dashboard/charts/string_data_chart.dart';

class Stringdata extends StatelessWidget {
  final Map<String, dynamic>? response;

  const Stringdata({
    Key? key,
    this.response,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> stringInfo =
        response?['INDIVDIUAL_INVERTER_DATA_SOLAR']?[0]?['STRING_INFO'] ?? [];

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          // Header Card
          Card(
            elevation: 4,
            color: primaryColor, // Ensure this is defined in colors.dart
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                child: const Text(
                  'String Data',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color:
                        primaryColorbg, // Ensure this is defined in colors.dart
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // String Info Cards
          Wrap(
            spacing: 8.0, // Space between cards horizontally
            runSpacing: 8.0, // Space between cards vertically
            children: stringInfo.map<Widget>((item) {
              final valueAvgToday = item['VALUE'] ?? 'N/A';
              final statusColor = item['STATUS_COLOUR_BACKGROUND'] ?? '#FFFFFF';

              return Card(
                elevation: 4,
                color: Color(int.parse(statusColor.replaceAll('#', '0xFF'))),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$valueAvgToday',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // String Data Chart
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: StringDataChart(
              response: response,
            ),
          ),
        ],
      ),
    );
  }
}
