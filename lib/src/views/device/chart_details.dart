import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/models/game_history_model.dart';

class DetailChart extends StatefulWidget {
  const DetailChart({super.key, required this.historyData});

  final GameHistory historyData;
  @override
  State<DetailChart> createState() => _DetailChartState();
}

class _DetailChartState extends State<DetailChart> {
  @override
  Widget build(BuildContext context) {
    // Filter the game history data to include only scores >= 5
    final filteredHistoryData = widget.historyData.gameHistory
        ?.where((element) => element.score! >= 3)
        .toList();

    return Container(
        height: 400.h,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10),
        child: SfCartesianChart(
          // title: const ChartTitle(text: 'Game History'),
          primaryXAxis: const DateTimeAxis(
            title: AxisTitle(text: 'Date', textStyle: TextStyle(fontSize: 12)),
            isVisible: true,
            axisLine: AxisLine(color: AppColor.primary, width: 2),
            majorGridLines: MajorGridLines(width: 0),
          ),
          primaryYAxis: const NumericAxis(
            title: AxisTitle(text: 'Score', textStyle: TextStyle(fontSize: 12)),
            isVisible: true,
            axisLine: AxisLine(color: AppColor.primary, width: 2),
            majorGridLines: MajorGridLines(width: 0),
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            header: '',
            format: 'point.x : point.y',
          ),
          zoomPanBehavior:
              ZoomPanBehavior(enablePinching: true, enablePanning: true),
          series: <CartesianSeries<GameHistoryElement, DateTime>>[
            LineSeries<GameHistoryElement, DateTime>(
              dataSource: filteredHistoryData ?? [],
              xValueMapper: (GameHistoryElement element, _) =>
                  DateTime.tryParse(element.playedOn ?? '') ?? DateTime(1970),
              yValueMapper: (GameHistoryElement element, _) => element.score,
              enableTooltip: true,
              xAxisName: "Date",
              yAxisName: "Score",
              name: 'Score',
              color: AppColor.secondary,
              markerSettings: const MarkerSettings(
                  isVisible: true,
                  height: 1,
                  width: 1,
                  shape: DataMarkerType.circle,
                  borderWidth: 2,
                  borderColor: AppColor.primary),
            ),
          ],
        ));
  }
}
