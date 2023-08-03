import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

// ignore: must_be_immutable
class Rivetherapypage extends StatefulWidget {
  RiveFile riveFile;

  Rivetherapypage({super.key, required this.riveFile});

  @override
  State<Rivetherapypage> createState() => _RivetherapypageState();
}

class _RivetherapypageState extends State<Rivetherapypage> {
  // late RiveAnimationController _controller;

  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation(
      "Animation",
      autoplay: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rive testitng page'),
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: RiveAnimation.direct(
              widget.riveFile,
              animations: const ["Animation"],
              controllers: [_controller],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // disable the button while playing the animation
        onPressed: () {
          setState(() => _controller.isActive = !_controller.isActive);
        },
        tooltip: 'Play',
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
