import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:walk/src/constants/app_color.dart';

class FrsResult extends StatefulWidget {
  const FrsResult({super.key});

  @override
  State<FrsResult> createState() => _FrsResultState();
}

class _FrsResultState extends State<FrsResult> {
  late Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _frsData;
  Map<DateTime, double> leftLegUpData = {};
  Map<DateTime, double> rightLegUpData = {};
  Map<DateTime, int> leftReactionTime = {};
  Map<DateTime, int> rightReactionTime = {};
  Map<DateTime, int> fallRiskScore = {};

  @override
  void initState() {
    super.initState();
    _frsData = _fetchFrsData();
    _frsData.then((docs) {
      for (var doc in docs) {
        var date = DateTime.parse(doc.id);
        var leftValue = doc.data()['left_angles'] ?? [0.0];
        var rightValue = doc.data()['right_angles'] ?? [0.0];
        var leftReactionTimeValue = doc.data()['left_reaction_time'] ?? [];
        var rightReactionTimeValue = doc.data()['right_reaction_time'] ?? [];

        var leftY = leftValue.cast<double>() as List<double>;

        // log(leftY.toString());
        var rightY = rightValue.cast<double>() as List<double>;
        var leftReactionTimeY = leftReactionTimeValue.cast<int>() as List<int>;
        var rightReactionTimeY =
            rightReactionTimeValue.cast<int>() as List<int>;

        var leftSum = 0.0;
        var rightSum = 0.0;
        for (var i in leftY) {
          leftSum += i;
        }
        leftSum = (leftSum * 100 / leftY.length).roundToDouble();
        for (var i in rightY) {
          rightSum += i;
        }
        rightSum = (rightSum * 100 / rightY.length).roundToDouble();

        var minLeft = double.maxFinite.toInt();
        for (var i in leftReactionTimeY) {
          if (i < minLeft) {
            minLeft = i;
          }
        }
        if (!leftReactionTimeY.contains(minLeft)) {
          minLeft = 0;
        }
        var minRight = double.maxFinite.toInt();
        for (var i in rightReactionTimeY) {
          if (i < minRight) {
            minRight = i;
          }
        }
        if (!rightReactionTimeY.contains(minRight)) {
          minRight = 0;
        }
        // log('leftSum: $leftSum');
        // log('rightSum: $rightSum');
        log('minLeft: $minLeft');
        log('minRight: $minRight');
        int l_range, r_range, l_rt, r_rt;
        if (leftSum > 7) {
          l_range = 3;
        } else if (leftSum > 5) {
          l_range = 2;
        } else if (leftSum > 3) {
          l_range = 1;
        } else {
          l_range = 0;
        }
        if (rightSum > 7) {
          r_range = 3;
        } else if (rightSum > 5) {
          r_range = 2;
        } else if (rightSum > 3) {
          r_range = 1;
        } else {
          r_range = 0;
        }

        if (minLeft < 350) {
          l_rt = 3;
        } else if (minLeft < 600) {
          l_rt = 2;
        } else if (minLeft < 1000) {
          l_rt = 1;
        } else {
          l_rt = 0;
        }

        if (minRight < 350) {
          r_rt = 3;
        } else if (minRight < 600) {
          r_rt = 2;
        } else if (minRight < 1000) {
          r_rt = 1;
        } else {
          r_rt = 0;
        }

        setState(() {
          leftLegUpData[date] = 10 - leftSum / 10;
          rightLegUpData[date] = 10 - rightSum / 10;
          leftReactionTime[date] = minLeft;
          rightReactionTime[date] = minRight;
          //Scoring:
          // RT : 	300 < 350 < more (adjust as per actual values, accounting for delays)
          // 	  4        2.5       0
          // ROM:	 60 > 40 > 30 > less
          // 	  3      2      1       0
          // HT:	 3 > 2 > 1 > less
          // 	 3    2    1      0
          fallRiskScore[date] = 10 - l_rt + r_rt + l_range + r_range;
        });
      }
    });
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _fetchFrsData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('frs')
        .where('user_id', isEqualTo: userId)
        .get();
    return querySnapshot.docs;
  }

  String getTrendText(Map<DateTime, dynamic> data) {
    if (data.isEmpty) return 'No data available to determine trend.';
    var sortedEntries = data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    var firstValue = sortedEntries.first.value;
    var lastValue = sortedEntries.last.value;
    if (lastValue > firstValue) {
      return 'The trend shows an improvement over time.';
    } else if (lastValue < firstValue) {
      return 'The trend shows a decline over time.';
    } else {
      return 'The trend shows no significant change over time.';
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building FRS Results screen');
    return DefaultTabController(
      length: 3, // Update the length to 3
      initialIndex: 0, // Set the default tab index to 0
      child: Scaffold(
        appBar: AppBar(
          shadowColor: AppColor.secondary,
          surfaceTintColor: AppColor.secondary,
          foregroundColor: AppColor.secondary,
          titleTextStyle: const TextStyle(color: AppColor.secondary),
          title: const Text('FRS Results'),
          backgroundColor: AppColor.primary,
          bottom: const TabBar(
            labelColor: AppColor.secondary,
            unselectedLabelColor: Colors.white30,
            indicatorColor: AppColor.secondary,
            dividerColor: AppColor.secondary,
            tabs: [
              Tab(text: 'Fall Risk Score'), // New tab
              Tab(text: 'Standing range of motion'), Tab(text: 'Reaction Time'),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            SizedBox(
                              height:
                                  400, // Set the desired height for the graph
                              child: SfCartesianChart(
                                primaryXAxis: DateTimeAxis(
                                  intervalType: DateTimeIntervalType.auto,
                                  title: AxisTitle(text: 'Time'),
                                ),
                                primaryYAxis: NumericAxis(
                                  minimum: 0,
                                  maximum: 10,
                                  interval: 1,
                                  title: AxisTitle(text: 'Fall Risk Score'),
                                ),
                                zoomPanBehavior: ZoomPanBehavior(
                                  enablePinching: true,
                                  enablePanning: true,
                                  enableDoubleTapZooming: true,
                                ),
                                series: <ChartSeries>[
                                  LineSeries<MapEntry<DateTime, int>, DateTime>(
                                    dataSource: fallRiskScore.entries.toList(),
                                    xValueMapper: (entry, _) => entry.key,
                                    yValueMapper: (entry, _) =>
                                        entry.value.toDouble(),
                                    name: 'Fall Risk Score',
                                    color: AppColor.secondary,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'This graph shows the fall risk score over time. Higher values indicate a higher risk of falling.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              getTrendText(fallRiskScore.cast()),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            SizedBox(
                              height:
                                  400, // Set the desired height for the graph
                              child: SfCartesianChart(
                                primaryXAxis: DateTimeAxis(
                                  intervalType: DateTimeIntervalType.auto,
                                  title: AxisTitle(text: 'Time'),
                                ),
                                primaryYAxis: NumericAxis(
                                  minimum: 0,
                                  maximum: 10,
                                  interval: 1,
                                  title: AxisTitle(text: 'Score'),
                                ),
                                zoomPanBehavior: ZoomPanBehavior(
                                  enablePinching: true,
                                  enablePanning: true,
                                  enableDoubleTapZooming: true,
                                ),
                                series: <ChartSeries>[
                                  LineSeries<MapEntry<DateTime, double>,
                                      DateTime>(
                                    dataSource: leftLegUpData.entries.toList(),
                                    xValueMapper: (entry, _) => entry.key,
                                    yValueMapper: (entry, _) => entry.value,
                                    name: 'Left Leg',
                                    color: AppColor.secondary,
                                  ),
                                  LineSeries<MapEntry<DateTime, double>,
                                      DateTime>(
                                    dataSource: rightLegUpData.entries.toList(),
                                    xValueMapper: (entry, _) => entry.key,
                                    yValueMapper: (entry, _) => entry.value,
                                    name: 'Right Leg',
                                    color: AppColor.primary,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'This graph shows the range of motion for the left and right legs over time. The green areas indicate good range, yellow areas indicate moderate range, and red areas indicate poor range.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              getTrendText(leftLegUpData),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            SizedBox(
                              height:
                                  400, // Set the desired height for the graph
                              child: SfCartesianChart(
                                primaryXAxis: DateTimeAxis(
                                  intervalType: DateTimeIntervalType.auto,
                                  title: AxisTitle(text: 'Time'),
                                ),
                                primaryYAxis: NumericAxis(
                                  maximum: 1000,
                                  minimum: 300,
                                  title: AxisTitle(text: 'Time (ms)'),
                                ),
                                zoomPanBehavior: ZoomPanBehavior(
                                  enablePinching: true,
                                  enablePanning: true,
                                  enableDoubleTapZooming: true,
                                ),
                                series: <ChartSeries>[
                                  LineSeries<MapEntry<DateTime, int>, DateTime>(
                                    dataSource:
                                        leftReactionTime.entries.toList(),
                                    xValueMapper: (entry, _) => entry.key,
                                    yValueMapper: (entry, _) =>
                                        entry.value.toDouble(),
                                    name: 'Left Leg',
                                    color: AppColor.secondary,
                                  ),
                                  LineSeries<MapEntry<DateTime, int>, DateTime>(
                                    dataSource:
                                        rightReactionTime.entries.toList(),
                                    xValueMapper: (entry, _) => entry.key,
                                    yValueMapper: (entry, _) =>
                                        entry.value.toDouble(),
                                    name: 'Right Leg',
                                    color: AppColor.primary,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'This graph shows the reaction times for the left and right legs over time. Lower values indicate faster reaction times.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              getTrendText(leftReactionTime.cast()),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
