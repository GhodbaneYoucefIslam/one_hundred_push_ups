import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";

class LineGraph extends StatelessWidget {
  double minX;
  double minY;
  double maxX;
  double maxY;
  List<FlSpot> dataPoints;
  List<String>? dates;
  LineGraph(
      {super.key,
      required this.minX,
      required this.minY,
      required this.maxX,
      required this.maxY,
      this.dates,
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
                interval: (maxX/6).floorToDouble() + 1 ,
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (dates!=null){
                  DateTime date = DateTime.parse(dates![value.toInt()-1]);
                  return Text(
                    "${date.day}/${date.month}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                  );
                }else{
                    return Text(
                      "Day ${value.toInt()+1}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    );
                  }
                })),
      ),
    ));
  }
}
