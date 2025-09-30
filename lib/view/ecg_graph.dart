import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EcgPlot extends StatelessWidget {
  final List<FlSpot> ecgData;

  const EcgPlot({super.key, required this.ecgData});

  @override
  Widget build(BuildContext context) {
    // Convert your JSON into FlSpot points
    // final spots = ecgData.map((d) {
    //   final x = (d['timestamp'] as num).toDouble();
    //   final y = (d['ecg_value'] as num).toDouble();
    //   return FlSpot(x, y);
    // }).toList();

    return LineChart(
      LineChartData(
        minX: ecgData.isNotEmpty ? ecgData.first.x : 0,
        maxX: ecgData.isNotEmpty ? ecgData.last.x : 1000,
        // minY: -5000, // set a fixed ECG range
        // maxY: 5000,
        
        gridData: FlGridData(show: true),
      
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        backgroundColor: const Color.fromARGB(255, 142, 201, 250),
        lineBarsData: [
          LineChartBarData(
            spots: ecgData,
            isCurved: true, // ECG is sharp, not smooth
            dotData: FlDotData(show: false),
            color: const Color.fromARGB(255, 3, 84, 236),
            barWidth: 2,
            
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
