import 'package:flutter/material.dart';

class StringDataChart extends StatelessWidget {
  final Map<String, dynamic>? response;

  const StringDataChart({
    Key? key,
    this.response,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Print the response to the console (for debugging)
    print(response);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          "New Start",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
