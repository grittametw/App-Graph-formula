import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FormulaGraphScreen(),
    );
  }
}

class FormulaGraphScreen extends StatefulWidget {
  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<FormulaGraphScreen> {
  double tms = 0;
  double i = 0;
  double isValue = 1; // Set initial value to avoid division by zero
  List<FlSpot> dataPoints = [];

  // Function to calculate t based on user inputs
  void calculateAndDrawGraph() {
    double ir = i / isValue;
    double t = tms * (80 / (ir * ir - 1));
    setState(() {
      dataPoints.add(FlSpot(ir, t));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Plotting'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input fields for TMS, I, and Is
            TextField(
              decoration: const InputDecoration(labelText: 'TMS'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  tms = double.tryParse(value) ?? 0;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'I'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  i = double.tryParse(value) ?? 0;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Is'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  isValue = double.tryParse(value) ?? 1;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateAndDrawGraph,
              child: const Text('Calculate & Draw Graph'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  minX: 0,
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: dataPoints,
                      isCurved: true,
                      color: Colors.blue,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toStringAsFixed(2));
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toStringAsFixed(2));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
