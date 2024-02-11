import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

class LineGraph extends StatelessWidget {
  double minX;
  double minY;
  double maxX;
  double maxY;
  List<FlSpot> dataPoints;
  LineGraph(
      {super.key,
      required this.minX,
      required this.minY,
      required this.maxX,
      required this.maxY,
      required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [LineChartBarData(spots: dataPoints)],
      titlesData: FlTitlesData(
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    "Day ${value.toInt().toString()}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                  );
                })),
      ),
    ));
  }
}
