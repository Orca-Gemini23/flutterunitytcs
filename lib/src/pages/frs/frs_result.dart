import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _frsData = _fetchFrsData();
    _frsData.then((docs) {
      for (var doc in docs) {
        var date = DateTime.parse(doc.id);
        var leftValue = doc.data()['left_angles'];
        var rightValue = doc.data()['right_angles'];
        var leftReactionTimeValue = doc.data()['left_reaction_time'];
        var rightReactionTimeValue = doc.data()['right_reaction_time'];
        var leftY = leftValue.cast<double>() as List<double>;
        var rightY = rightValue.cast<double>() as List<double>;
        var leftReactionTimeY = leftReactionTimeValue.cast<int>() as List<int>;
        var rightReactionTimeY =
            rightReactionTimeValue.cast<int>() as List<int>;
        var leftSum = 0.0;
        var rightSum = 0.0;
        for (var i in leftY) {
          leftSum += i;
        }
        for (var i in rightY) {
          rightSum += i;
        }
        var minLeft = 9999999999999;
        for (var i in leftReactionTimeY) {
          if (i < minLeft) {
            minLeft = i;
          }
        }
        var minRight = 9999999999999;
        for (var i in rightReactionTimeY) {
          if (i < minRight) {
            minRight = i;
          }
        }

        setState(() {
          leftLegUpData[date] = leftSum / leftY.length;
          rightLegUpData[date] = rightSum / rightY.length;
          leftReactionTime[date] = minLeft;
          rightReactionTime[date] = minRight;
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

  @override
  Widget build(BuildContext context) {
    debugPrint('Building FRS Results screen');
    return Scaffold(
      appBar: AppBar(
        title: const Text('FRS Results'),
        backgroundColor: AppColor.greenDarkColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: 200, // Set the desired height for the graph
                child: LineChart(
                  LineChartData(
                    // minX: 1,
                    // maxX: 31,
                    // minY: 0,
                    // maxY: 100,
                    titlesData: const FlTitlesData(
                      topTitles: AxisTitles(),
                      rightTitles: AxisTitles(),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: leftLegUpData.entries
                            .map((e) => FlSpot(e.key.month.toDouble(), e.value))
                            .toList(),
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 2,
                        belowBarData: BarAreaData(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200, // Set the desired height for the graph
                child: LineChart(
                  LineChartData(
                    // minX: 1,
                    // maxX: 31,
                    // minY: 0,
                    // maxY: 100,
                    titlesData: const FlTitlesData(
                      topTitles: AxisTitles(),
                      rightTitles: AxisTitles(),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: rightLegUpData.entries
                            .map((e) => FlSpot(e.key.month.toDouble(), e.value))
                            .toList(),
                        isCurved: true,
                        color: Colors.red,
                        barWidth: 2,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200, // Set the desired height for the graph
                child: LineChart(
                  LineChartData(
                    titlesData: const FlTitlesData(
                      topTitles: AxisTitles(),
                      rightTitles: AxisTitles(),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: leftReactionTime.entries
                            .map((e) => FlSpot(
                                e.key.month.toDouble(), e.value.toDouble()))
                            .toList(),
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 2,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200, // Set the desired height for the graph
                child: LineChart(
                  LineChartData(
                    titlesData: const FlTitlesData(
                      topTitles: AxisTitles(),
                      rightTitles: AxisTitles(),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: rightReactionTime.entries
                            .map((e) => FlSpot(
                                e.key.month.toDouble(), e.value.toDouble()))
                            .toList(),
                        isCurved: true,
                        color: Colors.red,
                        barWidth: 2,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
