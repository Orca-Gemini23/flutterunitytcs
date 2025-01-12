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
          series: <CartesianSeries<GameHistoryElement, DateTime>>[
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
              ),
            ),
          ],
        ));
  }
}
