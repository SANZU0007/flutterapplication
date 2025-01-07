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
          chartData = List.generate(
            graphData.length,
            (index) => ChartData(
              x: index + 6, // X values start from 6
              y: double.parse(graphData[
                  index]), // Convert the string to double for the Y value
            ),
          );
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
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
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
                  minimum: 6, // Start the X axis from 6
                  maximum:
                      18, // Adjust the maximum value based on the new starting point
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
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // No border radius
                  ),
                  child: InkWell(
                    onTap: () => _updatePeriod('HOURS'),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "HOURLY",
                        style: TextStyle(
                          fontSize: 10, // Adjust font size
                          fontWeight:
                              FontWeight.bold, // Optional: Make text bold
                          color: Colors.black, // Text color
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // No border radius
                  ),
                  child: InkWell(
                    onTap: () => _updatePeriod('DAYS'),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "DAILY",
                        style: TextStyle(
                          fontSize: 10, // Adjust font size
                          fontWeight:
                              FontWeight.bold, // Optional: Make text bold
                          color: Colors.black, // Text color
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // No border radius
                  ),
                  child: InkWell(
                    onTap: () => _updatePeriod('MONTHLY'),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "MONTHLY",
                        style: TextStyle(
                          fontSize: 16, // Adjust font size
                          fontWeight:
                              FontWeight.bold, // Optional: Make text bold
                          color: Colors.black, // Text color
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // No border radius
                  ),
                  child: InkWell(
                    onTap: () => _updatePeriod('YEARLY'),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "YEARLY",
                        style: TextStyle(
                          fontSize: 16, // Adjust font size
                          fontWeight:
                              FontWeight.bold, // Optional: Make text bold
                          color: Colors.black, // Text color
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
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
