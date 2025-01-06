import 'package:flutter/material.dart';
import 'package:testapp/colors.dart';

class Stringdata extends StatelessWidget {
  final Map<String, dynamic>? response;

  const Stringdata({
    Key? key,
    this.response,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stringInfo =
        response?['INDIVDIUAL_INVERTER_DATA_SOLAR']?[0]?['STRING_INFO'] ?? [];

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Card(
            elevation: 4,
            color: primaryColor, // Ensure this is defined in colors.dart
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                width: double.infinity, // Take up the full width
                child: const Text(
                  'String data',
                  textAlign: TextAlign.center, // Center the text
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
          // Use Wrap instead of Column
          Wrap(
            spacing: 8.0, // Space between cards horizontally
            runSpacing: 8.0, // Space between cards vertically
            children: stringInfo.map<Widget>((item) {
              final valueAvgToday = item['VALUE'];
              final statusColor = item['STATUS_COLOUR_BACKGROUND'];

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
        ],
      ),
    );
  }
}
