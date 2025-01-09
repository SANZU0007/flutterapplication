import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:testapp/colors.dart'; // Import syncfusion_flutter_charts

class StringDataChart extends StatefulWidget {
  final Map<String, dynamic>? response;

  const StringDataChart({Key? key, this.response}) : super(key: key);

  @override
  _StringDataChartState createState() => _StringDataChartState();
}

class _StringDataChartState extends State<StringDataChart> {
  String apikey = '';
  String period = 'HOURS'; // Default to HOURLY
  String formuila = 'HOURS'; // Default to HOURLY
  List<String> strings = [];
  List<String> graphData = [];

  @override
  void initState() {
    super.initState();
    apikey = widget.response?['IDENTIFIER_STRING'] ?? "No data";
    _fetchGraphData();
  }

  void _updatePeriod(String newPeriod) {
    setState(() {
      period = newPeriod;
    });
    _fetchGraphData();
  }

  Future<void> _fetchGraphData() async {
    final url =
        'https://esenz.live/esenzMobileAPISolarPowerHourlyRedirect.aspx?KEY=$apikey&SOURCE=WEB&POINTS=20&PARA=SOLAR&PERIOD=$period';

    try {
      final response = await http.get(Uri.parse(url));
      print('Fetching data for period: $period');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          final legendData = List<String>.from(data['LEGEND'] ?? []);
          final graphDataPoints = List<String>.from(data['GRAPH_DATA'] ?? []);

          if (period == 'DAYS') {
            if (legendData.length > 10) {
              strings = legendData.sublist(legendData.length - 10);
              graphData = graphDataPoints.sublist(graphDataPoints.length - 10);
            } else {
              strings = legendData;
              graphData = graphDataPoints;
            }
          } else if (period == 'MONTHS') {
            if (legendData.length > 12) {
              strings = legendData.sublist(legendData.length - 12);
              graphData = graphDataPoints.sublist(graphDataPoints.length - 12);
            } else {
              strings = legendData;
              graphData = graphDataPoints;
            }
          } else {
            strings = legendData;
            graphData = graphDataPoints;
          }
        });
        print(strings);
        print(graphData);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = List.generate(strings.length, (index) {
      return ChartData(
        label: strings[index],
        value: double.tryParse(graphData[index].trim()) ?? 0,
      );
    });

    return Container(
      color: Colors.grey[200], // Set your desired background color here
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(),
              title: ChartTitle(
                text: 'Solar Power graph (Energy (kWh) v/s $period)',
                textStyle: TextStyle(fontSize: 10),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries>[
                ColumnSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.label,
                  yValueMapper: (ChartData data, _) => data.value,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  color: solarColor,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPeriodButton('HOURS'),
              SizedBox(width: 1),
              _buildPeriodButton('DAYS'),
              SizedBox(width: 1),
              _buildPeriodButton('MONTHS'),
              SizedBox(width: 1),
              _buildPeriodButton('YEARS'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String periodLabel) {
    bool isSelected = period == periodLabel;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      color: isSelected ? primaryColorbg : solarColor,
      elevation: isSelected ? 4 : 2,
      child: InkWell(
        onTap: () => _updatePeriod(periodLabel),
        splashColor: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(8.10),
          child: Text(
            periodLabel,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final String label;
  final double value;

  ChartData({required this.label, required this.value});
}
