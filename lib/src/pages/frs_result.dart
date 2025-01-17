import 'package:flutter/material.dart';

class FrsResult extends StatelessWidget {
  const FrsResult(
      {super.key, required this.rightAngles, required this.leftAngles});

  final List<double> rightAngles;
  final List<double> leftAngles;

  double calculateAverage(List<double> angles) {
    if (angles.isEmpty) return 0.0;
    return angles.reduce((a, b) => a + b) / angles.length;
  }

  @override
  Widget build(BuildContext context) {
    double rightAverage = calculateAverage(rightAngles);
    double leftAverage = calculateAverage(leftAngles);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FRS Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Right Angles Average: ${1 - rightAverage}'),
            Text('Left Angles Average: ${1 - leftAverage}'),
          ],
        ),
      ),
    );
  }
}
