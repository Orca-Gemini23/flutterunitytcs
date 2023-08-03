import 'package:flutter/material.dart';
import 'dart:math';

class LineMoveWithAngles extends StatefulWidget {
  @override
  _LineMoveWithAnglesState createState() => _LineMoveWithAnglesState();
}

class _LineMoveWithAnglesState extends State<LineMoveWithAngles> {
  double angle = 0; // Initialize with 0-degree angle

  void moveLine(double newAngle) {
    setState(() {
      angle = newAngle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Line Movement with Angles'),
      ),
      body: Center(
        child: CustomPaint(
          painter:
              LinePainter(angle, Image.asset("assets/images/legimage.jpg")),
          size: const Size(200, 200),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () => moveLine(angle +
                pi / 6), // Move line clockwise by 30 degrees (pi/6 radians)
            child: const Icon(Icons.rotate_left),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => moveLine(angle -
                pi /
                    6), // Move line counterclockwise by 30 degrees (pi/6 radians)
            child: const Icon(Icons.rotate_right),
          ),
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final double angle;
  final Image image;

  LinePainter(this.angle, this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    const double lineLength = 100;

    // Set the origin to the center of the canvas
    canvas.translate(centerX, centerY);

    // Rotate the canvas by the specified angle
    canvas.rotate(angle);

    final double imageX = lineLength * cos(angle);
    final double imageY = lineLength * sin(angle);

    final Paint rightpaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3;
    canvas.drawLine(
        const Offset(0, 0), const Offset(80, lineLength), rightpaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
