import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
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
  int? selectedMonth;
  int? selectedYear;

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
        var rightReactionTimeY = rightReactionTimeValue.cast<int>() as List<int>;
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
        var minRight = double.maxFinite.toInt();
        for (var i in rightReactionTimeY) {
          if (i < minRight) {
            minRight = i;
          }
        }

        setState(() {
          leftLegUpData[date] = 10 - leftSum / 10;
          rightLegUpData[date] = 10 - rightSum / 10;
          leftReactionTime[date] = minLeft;
          rightReactionTime[date] = minRight;
        });
      }
    });
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _fetchFrsData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('frs')
        .where('user_id', isEqualTo: userId)
        .get();
    return querySnapshot.docs;
  }

  String getMonthName(int month) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }

  List<int> getYears() {
    return leftLegUpData.keys.map((date) => date.year).toSet().toList()..sort();
  }

  Map<DateTime, double> _filterData(Map<DateTime, double> data) {
    return Map.fromEntries(
      data.entries.where((entry) =>
      (selectedMonth == null || entry.key.month == selectedMonth) &&
          (selectedYear == null || entry.key.year == selectedYear)),
    );
  }

  Map<DateTime, int> _filterReactionTimeData(Map<DateTime, int> data) {
    return Map.fromEntries(
      data.entries.where((entry) =>
      (selectedMonth == null || entry.key.month == selectedMonth) &&
          (selectedYear == null || entry.key.year == selectedYear)),
    );
  }

  double _getMinX() {
    return selectedMonth != null ? 0 : 1;
  }

  double _getMaxX() {
    return selectedMonth != null ? 31 : 12;
  }
  String getXAxisLabel() {
    return selectedMonth != null ? 'Day' : 'Month';
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Building FRS Results screen');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('FRS Results'),
          backgroundColor: AppColor.greenDarkColor,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Leg Standing'),
              Tab(text: 'Reaction Time'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<int>(
                      hint: const Text('Select Year'),
                      value: selectedYear,
                      items: getYears().map((year) {
                        return DropdownMenuItem(
                          value: year,
                          child: Text(year.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: DropdownButton<int>(
                      hint: const Text('Select Month'),
                      value: selectedMonth,
                      items: List.generate(12, (index) {
                        return DropdownMenuItem(
                          value: index + 1,
                          child: Text(getMonthName(index + 1)),
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          selectedMonth = value;
                        });
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedMonth = null;
                        selectedYear = null;
                      });
                    },
                    child: const Text('Reset Filters'),
                  ),
                ],
              ),
            ),
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
                              height: 400, // Set the desired height for the graph
                              child: LineChart(
                                LineChartData(
                                  rangeAnnotations: RangeAnnotations(
                                    horizontalRangeAnnotations: [
                                      HorizontalRangeAnnotation(
                                        y1: 0,
                                        y2: 3,
                                        color: Colors.red.withOpacity(0.3),
                                      ),
                                      HorizontalRangeAnnotation(
                                        y1: 3,
                                        y2: 6,
                                        color: Colors.yellow.withOpacity(0.3),


                                      ),
                                      HorizontalRangeAnnotation(
                                        y1: 6,
                                        y2: 10,
                                        color: Colors.green.withOpacity(0.3),

                                      ),
                                    ],
                                  ),
                                  minX: _getMinX(),
                                  maxX: _getMaxX(),
                                  minY: 0,
                                  maxY: 10,
                                  titlesData: FlTitlesData(
                                    topTitles: const AxisTitles(
                                      axisNameWidget: Text('Leg Standing'),
                                    ),
                                    rightTitles: const AxisTitles(),
                                    bottomTitles: AxisTitles(
                                      axisNameWidget: Text(getXAxisLabel()),
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return Text(value.toInt().toString());
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      axisNameWidget: const Text('Score'),
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 1,
                                        getTitlesWidget: (value, meta) {
                                          return Text(value.toInt().toString());
                                        },
                                      ),
                                    ),
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: _filterData(leftLegUpData)
                                          .entries
                                          .map((e) => FlSpot(
                                          selectedMonth != null ? e.key.day.toDouble() : e.key.month.toDouble(),
                                          e.value))
                                          .toList(),
                                      isCurved: true,
                                      color: Colors.blue,
                                      belowBarData: BarAreaData(),
                                    ),
                                    LineChartBarData(
                                      spots: _filterData(rightLegUpData)
                                          .entries
                                          .map((e) => FlSpot(
                                          selectedMonth != null ? e.key.day.toDouble() : e.key.month.toDouble(),
                                          e.value))
                                          .toList(),
                                      isCurved: true,
                                      color: Colors.red,
                                      belowBarData: BarAreaData(),
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
                  ),
                  SingleChildScrollView(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 400, // Set the desired height for the graph
                              child: LineChart(
                                LineChartData(
                                  minX: _getMinX(),
                                  maxX: _getMaxX(),
                                  titlesData: FlTitlesData(
                                    topTitles: const AxisTitles(
                                      axisNameWidget: Text('Reaction Time'),
                                    ),
                                    rightTitles: const AxisTitles(),
                                    bottomTitles: AxisTitles(
                                      axisNameWidget: Text(getXAxisLabel()),
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return Text(value.toInt().toString());
                                        },
                                      ),
                                    ),
                                    leftTitles: const AxisTitles(
                                      axisNameWidget: Text('Time (ms)'),
                                    ),
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: _filterReactionTimeData(leftReactionTime)
                                          .entries
                                          .map((e) => FlSpot(
                                          selectedMonth != null ? e.key.day.toDouble() : e.key.month.toDouble(),
                                          e.value.toDouble()))
                                          .toList(),
                                      isCurved: true,
                                      color: Colors.blue,
                                      belowBarData: BarAreaData(),
                                    ),
                                    LineChartBarData(
                                      spots: _filterReactionTimeData(rightReactionTime)
                                          .entries
                                          .map((e) => FlSpot(
                                          selectedMonth != null ? e.key.day.toDouble() : e.key.month.toDouble(),
                                          e.value.toDouble()))
                                          .toList(),
                                      isCurved: true,
                                      color: Colors.red,
                                      belowBarData: BarAreaData(),
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