import 'package:flutter/material.dart';
import "package:fl_chart/fl_chart.dart";
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/models/chart_model.dart';

class DetailChart extends StatefulWidget {
  const DetailChart({super.key});

  @override
  State<DetailChart> createState() => _DetailChartState();
}

class _DetailChartState extends State<DetailChart> {
  List<FlSpot> chartData = [];

  List<FlSpot> getchartData() {
    List<FlSpot> temp = [];
    for (int i = 0; i < 1313; i++) {
      temp.add(
        FlSpot(
          i.toDouble(),
          voltageValues[i],
        ),
      );
    }
    return temp;
  }

  @override
  void initState() {
    super.initState();
    chartData = getchartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Usage chart",
          style: TextStyle(
            color: AppColor.greenDarkColor,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.whiteColor,
      ),
      body: Container(
        color: AppColor.whiteColor,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(20),
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                        value.toString(),
                        style: const TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                        value.toString(),
                        style: const TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                  border: Border.all(),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: chartData,
                    dotData: FlDotData(show: false),
                  ),
                ],
                gridData: FlGridData(
                  show: false,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
