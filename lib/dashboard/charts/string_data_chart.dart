import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Correct import for charts
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding

class StringDataChart extends StatefulWidget {
  final Map<String, dynamic>? response;

  const StringDataChart({
    Key? key,
    this.response,
  }) : super(key: key);

  @override
  _StringDataChartState createState() => _StringDataChartState();
}

class _StringDataChartState extends State<StringDataChart> {
  List<ChartData> chartData = [];
  late String apikey;
  String period = 'HOURS'; // Default to HOURLY

  @override
  void initState() {
    super.initState();
    apikey = widget.response?['IDENTIFIER_STRING'] ?? "No data";
    _fetchGraphData();
  }

  // Function to update period and fetch new data
  void _updatePeriod(String newPeriod) {
    setState(() {
      period = newPeriod;
    });
    _fetchGraphData(); // Fetch data based on the selected period
  }

  Future<void> _fetchGraphData() async {
    final url =
        'https://esenz.live/esenzMobileAPISolarPowerHourlyRedirect.aspx?KEY=${apikey}&SOURCE=WEB&POINTS=20&PARA=SOLAR&PERIOD=$period';

    try {
      final response = await http.get(Uri.parse(url));
      print(period);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<String> graphData =
            List<String>.from(data['GRAPH_DATA'] ?? []);

        setState(() {
          if (period == 'DAYS') {
            final DateTime today = DateTime.now();
            chartData = List.generate(
              graphData.length,
              (index) => ChartData(
                x: today.day -
                    index, // Reverse order starting from today's date
                y: double.parse(graphData[index]),
              ),
            );
          } else {
            chartData = List.generate(
              graphData.length,
              (index) => ChartData(
                x: index + 6,
                y: double.parse(graphData[index]),
              ),
            );
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int minimumValue = 6;
    int maximumValue = 18;

    if (period == 'DAYS') {
      // Set minimum to today's date (day) and adjust maximum dynamically
      final DateTime today = DateTime.now();
      minimumValue = today.day;
      maximumValue = minimumValue + chartData.length - 1;
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Building-like Chart",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Bar chart with X and Y axes
            Container(
              height: 250,
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(
                  title: AxisTitle(
                    text: 'X Axis', // X Axis title
                    textStyle: TextStyle(
                      fontSize: 14, // Adjust size
                      color: Colors.black, // Adjust color
                      fontWeight: FontWeight.bold, // Bold title
                    ),
                  ),
                  minimum: minimumValue.toDouble(),
                  maximum: maximumValue.toDouble(),
                  interval: 1, // Set interval to show every value
                  labelStyle: TextStyle(
                    fontSize: 12, // Label font size
                    color: Colors.black, // Label color
                  ),
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(
                    text: 'Y Axis', // Y Axis title
                    textStyle: TextStyle(
                      fontSize: 14, // Adjust size
                      color: Colors.black, // Adjust color
                      fontWeight: FontWeight.bold, // Bold title
                    ),
                  ),
                ),
                series: <ChartSeries>[
                  ColumnSeries<ChartData, int>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(2),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true, // Show the data labels
                      textStyle: TextStyle(
                          fontSize: 12, color: Colors.black), // Label style
                      labelIntersectAction: LabelIntersectAction.shift,
                      offset: Offset(0,
                          -10), // Adjust the offset to position the label higher
                    ),
                  ),
                ],
              ),
            ),
            // Buttons to select the period
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPeriodButton('HOURS'),
                _buildPeriodButton('DAYS'),
                _buildPeriodButton('MONTHS'),
                _buildPeriodButton('YEARS'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String periodLabel) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: InkWell(
        onTap: () => _updatePeriod(periodLabel),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            periodLabel,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final int x;
  final double y;

  ChartData({required this.x, required this.y});
}
