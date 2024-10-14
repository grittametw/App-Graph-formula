import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math'; // สำหรับการใช้งานฟังก์ชัน pow

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
  double isValue = 1;
  List<FlSpot> dataPoints = [];

  // Function to calculate t based on user inputs
  void calculateAndDrawGraph() {
    dataPoints.clear(); // เคลียร์ข้อมูลเก่าก่อน

    double ir = i / isValue;

    // ตรวจสอบเพื่อหลีกเลี่ยงค่าที่ไม่ถูกต้อง
    if (ir > 1) {
      double t = tms * (0.14 / (pow(ir, 0.2) - 1));
      if (t > 0) {
        dataPoints.add(FlSpot(ir, t));
      }
    }

    setState(() {});
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
                  minX: 1, // แกน X (Ir) เริ่มที่ 1
                  minY: 0, // แกน Y (t) เริ่มที่ 0
                  lineBarsData: [
                    LineChartBarData(
                      spots: dataPoints,
                      isCurved: true, // ให้เส้นกราฟมีความโค้ง
                      color: Colors.blue,
                      dotData: const FlDotData(show: true), // แสดงจุดบนกราฟ
                      belowBarData: BarAreaData(show: false), // ไม่แสดงแถบใต้เส้นกราฟ
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
