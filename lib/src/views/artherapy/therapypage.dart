import 'package:flutter/material.dart';

class MyTherapy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Moving Legs Animation')),
      body: MovingLegsAnimation(),
    );
  }
}

class MovingLegsAnimation extends StatefulWidget {
  @override
  _MovingLegsAnimationState createState() => _MovingLegsAnimationState();
}

class _MovingLegsAnimationState extends State<MovingLegsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: -20, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(150, 200),
            painter: LegsPainter(animation: _animation.value),
          );
        },
      ),
    );
  }
}

class LegsPainter extends CustomPainter {
  final double animation;

  LegsPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Hip
    final hipCenter = Offset(size.width / 2, size.height / 3);
    final hipRadius = 15.0;
    canvas.drawCircle(hipCenter, hipRadius, paint);

    // Left Leg
    final leftLegStart = hipCenter;
    final leftLegEnd = Offset(size.width / 3 + animation, size.height * 0.8);
    canvas.drawLine(leftLegStart, leftLegEnd, paint);

    // Right Leg
    final rightLegStart = hipCenter;
    final rightLegEnd =
        Offset(size.width * 2 / 3 - animation, size.height * 0.8);
    canvas.drawLine(rightLegStart, rightLegEnd, paint);

    // Left Foot
    final leftFootStart = leftLegEnd;
    final leftFootEnd = Offset(size.width / 3 - 20 + animation, size.height);
    canvas.drawLine(leftFootStart, leftFootEnd, paint);

    // Right Foot
    final rightFootStart = rightLegEnd;
    final rightFootEnd =
        Offset(size.width * 2 / 3 + 20 - animation, size.height);
    canvas.drawLine(rightFootStart, rightFootEnd, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
