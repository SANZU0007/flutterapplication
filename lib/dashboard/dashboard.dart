import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testapp/dashboard/dashboard_card.dart';
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

  // Fetch data from the API
  Future<void> fetchData() async {
    final url =
        'https://esenz.live/esenzMobileAPIMainDataRedirect.aspx?KEY=${widget.apiKey}';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          // Extracting INDIVDIUAL_INVERTER_DATA_SOLAR from the response
          _inverterData = data['INDIVDIUAL_INVERTER_DATA_SOLAR'] ?? [];
          _solarinverterData = data['SOLAR_TOTAL_POWER_LIVE_DASHBOARD'] ?? '0';
          _SOLAR_TOTAL_POWER_LIVE_DASHBOARD =
              data['SOLAR_TOTAL_POWER_LIVE_PERCENT'] ?? '0';
          _SOLAR_TOTAL_POWER_LIVE_DASHBOARD_PL =
              data['SOLAR_TOTAL_POWER_LIVE_PERCENT'] ?? '0';
          _IRRADIATION_LIVE_PERCENT_DASHBOARD =
              data['IRRADIATION_LIVE_PERCENT_DASHBOARD'] ?? '0';
        });

        print(data['LAST_UPDATED'] ?? '0');
        print(_IRRADIATION_LIVE_PERCENT_DASHBOARD);
        print(_SOLAR_TOTAL_POWER_LIVE_DASHBOARD_PL);
        print(_SOLAR_TOTAL_POWER_LIVE_DASHBOARD);
        print(_solarinverterData);
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
      appBar: DashboardAppBar(fetchData: fetchData),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                          widget.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DashboardCard(
                          value1: _SOLAR_TOTAL_POWER_LIVE_DASHBOARD_PL ?? '0',
                          value2: _IRRADIATION_LIVE_PERCENT_DASHBOARD ?? '0',
                          displayLabal: _solarinverterData ?? '0',
                        ),
                      ),
                    ),

                    // Display inverter data from INDIVDIUAL_INVERTER_DATA_SOLAR
                    if (_inverterData != null && _inverterData!.isNotEmpty) ...[
                      const Text(
                        'Inverter Data',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _inverterData!.length,
                        itemBuilder: (context, index) {
                          final item = _inverterData![index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Inverter Name: ${item['INVERTER_NAME'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Model: ${item['MODEL'] ?? 'N/A'}'),
                                  Text(
                                      'Serial Number: ${item['SERIAL_NUMBER'] ?? 'N/A'}'),
                                  Text(
                                      'Capacity: ${item['CAPACITY_DASHBAORD'] ?? 'N/A'}'),
                                  Text(
                                      'Power: ${item['POWER_DASHBOARD'] ?? 'N/A'}'),
                                  Text(
                                      'Energy Today: ${item['ENERGY_TODAY_DASHBOARD'] ?? 'N/A'}'),
                                  Text(
                                      'Energy This Month: ${item['ENERGY_THIS_MONTH_DASHBOARD'] ?? 'N/A'}'),
                                  Text(
                                      'Energy This Year: ${item['ENERGY_THIS_YEAR_DASHBOARD'] ?? 'N/A'}'),
                                  Text(
                                      'Energy Total: ${item['ENERGY_TOTAL_DASHBOARD'] ?? 'N/A'}'),
                                  Text('GF: ${item['GF'] ?? 'N/A'}'),
                                  Text('CUF: ${item['CUF'] ?? 'N/A'}'),
                                  Text('PR: ${item['PR'] ?? 'N/A'}'),
                                  Text(
                                      'Inverter Performance: ${item['INVERTER_PERFORMANCE_PERCENT'] ?? 'N/A'}%'),
                                  Text(
                                      'Tool Tip: ${item['TOOL_TIP'] ?? 'N/A'}'),
                                  const SizedBox(height: 12),
                                  // Optionally display power and sensor info as needed
                                  Text(
                                      'Power PH1: ${item['POWER_PH1'] ?? 'N/A'}'),
                                  Text(
                                      'Volts PH1: ${item['VOLTS_PH1'] ?? 'N/A'}'),
                                  Text(
                                      'Amps PH1: ${item['AMPS_PH1'] ?? 'N/A'}'),
                                  Text(
                                      'Avg Freq: ${item['AVG_FREQ'] ?? 'N/A'}'),
                                  Text('Avg PF: ${item['AVG_PF'] ?? 'N/A'}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
