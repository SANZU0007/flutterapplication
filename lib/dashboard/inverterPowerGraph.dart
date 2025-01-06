import 'package:flutter/material.dart';

class Inverterpowergraph extends StatelessWidget {
  final String value1;
  final String value2;
  final String displayLabal;
  final int no_Of_Solar_Strings;

  final List<dynamic> inverterData;

  const Inverterpowergraph({
    Key? key,
    required this.value1,
    required this.value2,
    required this.displayLabal,
    required this.inverterData,
    required this.no_Of_Solar_Strings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text("new start"));
  }
}
