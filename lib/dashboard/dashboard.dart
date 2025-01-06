import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testapp/colors.dart';
import 'package:testapp/dashboard/dashboard_card.dart';
import 'package:testapp/dashboard/gridExport.dart';
import 'package:testapp/dashboard/gridImport.dart';
import 'package:testapp/dashboard/inverterDashboard.dart';
import 'package:testapp/dashboard/stringdata.dart';
import 'dashboard_appbar.dart';

class Dashboard extends StatefulWidget {
  final String name;
  final String key1;
  final String key2;
  final String key3;
  final String apiKey;

  const Dashboard({
    super.key,
    required this.name,
    required this.key1,
    required this.key2,
    required this.key3,
    required this.apiKey,
  });

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic>? _inverterData;
  String? _solarinverterData;
  String? _SOLAR_TOTAL_POWER_LIVE_DASHBOARD;
  String? _SOLAR_TOTAL_POWER_LIVE_DASHBOARD_PL;
  String? _IRRADIATION_LIVE_PERCENT_DASHBOARD;
  int? _NO_OF_SOLAR_STRINGS;
  String? _SYS_ID;
  String? _LAST_UPDATED;
  Map<String, dynamic>? _TotalApiResponse;

  // Fetch data from the API
  Future<void> fetchData() async {
    final url =
        'https://esenz.live/esenzMobileAPIMainDataRedirect.aspx?KEY=${widget.apiKey}';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _TotalApiResponse = data;
          _inverterData = data['INDIVDIUAL_INVERTER_DATA_SOLAR'] ?? [];
          _solarinverterData = data['SOLAR_TOTAL_POWER_LIVE_DASHBOARD'] ?? '0';
          _SOLAR_TOTAL_POWER_LIVE_DASHBOARD =
              data['SOLAR_TOTAL_POWER_LIVE_PERCENT'] ?? '0';
          _SOLAR_TOTAL_POWER_LIVE_DASHBOARD_PL =
              data['SOLAR_TOTAL_POWER_LIVE_PERCENT'] ?? '0';
          _IRRADIATION_LIVE_PERCENT_DASHBOARD =
              data['IRRADIATION_LIVE_PERCENT_DASHBOARD'] ?? '0';
          _NO_OF_SOLAR_STRINGS = data['NO_OF_SOLAR_STRINGS'] ?? 0;
          _SYS_ID = data['SYS_ID'] ?? '0';
          _LAST_UPDATED = data['LAST_UPDATED'] ?? '0';
        });
        print(data);
        // print(data['LAST_UPDATED'] ?? '0');
        // print(_IRRADIATION_LIVE_PERCENT_DASHBOARD);
        // print(_SOLAR_TOTAL_POWER_LIVE_DASHBOARD_PL);
        // print(_SOLAR_TOTAL_POWER_LIVE_DASHBOARD);
        // print(_solarinverterData);
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardAppBar(
        fetchData: fetchData,
        displayID: _SYS_ID ?? '0',
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: _inverterData == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // User name card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '${widget.name},  | $_LAST_UPDATED',
                          textAlign: TextAlign.center, // Center the text
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Card(
                      elevation: 4,
                      color: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          width: double.infinity, // Take up the full width
                          child: Text(
                            'Solar',
                            textAlign: TextAlign.center, // Center the text
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: primaryColorbg,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Dashboard card data
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: DashboardCard(
                          value2: _SOLAR_TOTAL_POWER_LIVE_DASHBOARD ?? "0",
                          displayLabel:
                              _SOLAR_TOTAL_POWER_LIVE_DASHBOARD ?? "0",
                          // Provide an appropriate label
                          response: _TotalApiResponse,
                        )),

                    // Display inverter data
                    if (_inverterData != null && _inverterData!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Inverterdashboard(
                        value1: _SOLAR_TOTAL_POWER_LIVE_DASHBOARD_PL ?? '0',
                        value2: _IRRADIATION_LIVE_PERCENT_DASHBOARD ?? '0',
                        displayLabal: _solarinverterData ?? '0',
                        inverterData: _inverterData ?? [],
                        no_Of_Solar_Strings: _NO_OF_SOLAR_STRINGS ?? 0,
                      ),
                    ],

                    if (_inverterData != null && _inverterData!.isNotEmpty) ...[
                      Stringdata(
                        response: _TotalApiResponse,
                      ),
                    ],
                    Card(
                      elevation: 4,
                      color: importColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          width: double.infinity, // Take up the full width
                          child: Text(
                            'Grid Import',
                            textAlign: TextAlign.center, // Center the text
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColorbg,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Gridimport(
                          value2: _SOLAR_TOTAL_POWER_LIVE_DASHBOARD ?? "0",
                          displayLabel:
                              _SOLAR_TOTAL_POWER_LIVE_DASHBOARD ?? "0",
                          // Provide an appropriate label
                          response: _TotalApiResponse,
                        )),
                    Card(
                      elevation: 4,
                      color: exportColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          width: double.infinity, // Take up the full width
                          child: Text(
                            'Grid Export',
                            textAlign: TextAlign.center, // Center the text
                            style: const TextStyle(
                              fontSize: 18,
                              color: primaryColorbg,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Gridexport(
                          value2: _SOLAR_TOTAL_POWER_LIVE_DASHBOARD ?? "0",
                          displayLabel:
                              _SOLAR_TOTAL_POWER_LIVE_DASHBOARD ?? "0",
                          // Provide an appropriate label
                          response: _TotalApiResponse,
                        )),
                  ],
                ),
              ),
      ),
    );
  }
}
