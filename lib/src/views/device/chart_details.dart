import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/models/game_history_model.dart';

class DetailChart extends StatefulWidget {
  const DetailChart({super.key, required this.historyData});

  final GameHistory historyData;
  @override
  State<DetailChart> createState() => _DetailChartState();
}

class _DetailChartState extends State<DetailChart> {
  Map<int, DateTime> testGameDataMap = {};
  Map<int, GameHistoryElement> gameDataMap = {};

  void processData() {
    widget.historyData.gameHistory?.forEach((element) {
      gameDataMap.containsValue(element.playedOn)
          ? null
          : gameDataMap.addAll({
              element.score!: element,
            });

      testGameDataMap.containsValue(element.playedOn)
          ? null
          : testGameDataMap.addAll(
              {
                element.score ?? 0: DateTime.parse(
                  element.playedOn!,
                ),
              },
            );
    });
  }

  @override
  void initState() {
    super.initState();
    processData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400.h,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10),
        child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(
            isVisible: true,
            axisLine: const AxisLine(color: AppColor.greenDarkColor, width: 4),
            intervalType: DateTimeIntervalType.auto,
          ),
          primaryYAxis: NumericAxis(
            isVisible: true,
            axisLine: const AxisLine(color: AppColor.greenDarkColor, width: 4),
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
          ),
          zoomPanBehavior:
              ZoomPanBehavior(enablePinching: true, enablePanning: true),
          series: <ChartSeries<GameHistoryElement, DateTime>>[
            LineSeries<GameHistoryElement, DateTime>(
              dataSource: widget.historyData.gameHistory!,
              xValueMapper: (GameHistoryElement element, _) =>
                  DateTime.tryParse(element.playedOn!)!,
              yValueMapper: (GameHistoryElement element, _) => element.score,
              enableTooltip: true,
              xAxisName: "Date",
              yAxisName: "Score",
              name: 'Score',
              markerSettings: const MarkerSettings(
                  isVisible: true,
                  height: 6,
                  width: 6,
                  shape: DataMarkerType.circle,
                  borderWidth: 3,
                  borderColor: AppColor.greenDarkColor),
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(
                  color: AppColor.blackColor,
                  fontSize: 12.sp,
                ),
                labelAlignment: ChartDataLabelAlignment.auto,
              ),
            ),
          ],
        )
        // child: LineChart(
        //   LineChartData(
        //     titlesData: FlTitlesData(
        //       leftTitles: AxisTitles(
        //         sideTitles: SideTitles(
        //           showTitles: true,
        //           getTitlesWidget: (value, meta) => Text(
        //             value.toString(),
        //             style: TextStyle(
        //               color: const Color(0XFF6B6B6B),
        //               fontSize: 12.sp,
        //             ),
        //           ),
        //         ),
        //       ),
        //       rightTitles: AxisTitles(
        //         sideTitles: SideTitles(showTitles: false),
        //       ),
        //       topTitles: AxisTitles(
        //         sideTitles: SideTitles(showTitles: false),
        //       ),
        //       bottomTitles: AxisTitles(
        //         sideTitles: SideTitles(
        //           showTitles: true,
        //           getTitlesWidget: (value, meta) => Text(
        //             value.toString(),
        //             style: TextStyle(
        //               color: const Color(0XFF6B6B6B),
        //               fontSize: 12.sp,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //     borderData: FlBorderData(
        //       show: false,
        //       border: Border.all(),
        //     ),
        //     lineBarsData: [
        //       LineChartBarData(
        //         spots: chartData,
        //         dotData: FlDotData(show: false),
        //       ),
        //     ],
        //     gridData: FlGridData(
        //       show: true,
        //       drawHorizontalLine: true,
        //       drawVerticalLine: false,
        //     ),
        //   ),
        // ),
        );
  }
}
