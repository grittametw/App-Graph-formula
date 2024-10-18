import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class GraphPage extends StatefulWidget {
  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  final TextEditingController _tmsController = TextEditingController();
  final TextEditingController _iController = TextEditingController();
  final TextEditingController _isController = TextEditingController();

  double? _calculatedT;
  double? _calculatedIr; // For storing Ir value
  int _selectedFormula = 0;
  List<FlSpot> _spots = []; // Store (Ir, t) for plotting

  void _calculateT() {
    double tms = double.tryParse(_tmsController.text) ?? 0;
    double I = double.tryParse(_iController.text) ?? 0;
    double Is = double.tryParse(_isController.text) ?? 1;
    double ir = I / Is; // Calculate Ir
    double t = 0;

    switch (_selectedFormula) {
      case 0:
        t = tms * (0.14 / (pow(ir, 0.02) - 1));
        break;
      case 1:
        t = tms * (13.5 / (ir - 1));
        break;
      case 2:
        t = tms * (80 / (pow(ir, 2) - 1));
        break;
      case 3:
        t = tms * (120 / (ir - 1));
        break;
    }

    setState(() {
      _calculatedT = t;
      _calculatedIr = ir;

      // Generate data points for plotting (Ir, t)
      _spots = List.generate(
        100, // Adjust this value to increase/decrease the number of points
        (index) {
          double currentIr = (I / (Is + index * 0.1))
              .clamp(0.01, 100.0); // Avoid extremely small or large values
          double currentT = 0;

          // Calculate t for currentIr using the selected formula
          switch (_selectedFormula) {
            case 0:
              currentT = tms * (0.14 / (pow(currentIr, 0.02) - 1));
              break;
            case 1:
              currentT = tms * (13.5 / (currentIr - 1));
              break;
            case 2:
              currentT = tms * (80 / (pow(currentIr, 2) - 1));
              break;
            case 3:
              currentT = tms * (120 / (currentIr - 1));
              break;
          }

          // Avoid plotting NaN or Infinity values
          if (currentT.isNaN || currentT.isInfinite) {
            return null; // Skip invalid points
          }
          return FlSpot(currentIr, currentT);
        },
      )
          .where((spot) => spot != null)
          .toList()
          .cast<FlSpot>(); // Remove null points
    });
  }

  Widget _buildGraph() {
    return _calculatedT == null
        ? Container()
        : LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: _spots,
                  isCurved: false,
                  barWidth: 3,
                  color: Colors.blue,
                )
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toStringAsFixed(2)); // X-axis (Ir)
                      }),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toStringAsFixed(2)); // Y-axis (t)
                      }),
                ),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inverse formula'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tmsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'TMS'),
            ),
            TextField(
              controller: _iController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'I'),
            ),
            TextField(
              controller: _isController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Is'),
            ),
            SizedBox(height: 20),
            DropdownButton<int>(
              value: _selectedFormula,
              onChanged: (value) {
                setState(() {
                  _selectedFormula = value!;
                });
              },
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Text('Formula 1: TMS * [0.14 / [(Ir^0.02) - 1]]'),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text('Formula 2: TMS * [13.5 / (Ir - 1)]'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Formula 3: TMS * [80 / [(Ir^2) - 1]]'),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text('Formula 4: TMS * [120 / (Ir - 1)]'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateT,
              child: Text('Calculate t and Plot Graph'),
            ),
            SizedBox(height: 20),
            if (_calculatedT != null && _calculatedIr != null)
              Text(
                't = ${_calculatedT!.toStringAsFixed(2)}, Ir = ${_calculatedIr!.toStringAsFixed(2)}',
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 0.4),
              ),
            SizedBox(height: 20),
            Expanded(
              child: _buildGraph(),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GraphPage(),
    debugShowCheckedModeBanner: false,
  ));
}
