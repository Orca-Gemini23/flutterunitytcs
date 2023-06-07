import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomShowCaseWidget extends StatelessWidget {
  const CustomShowCaseWidget(
      {super.key,
      required this.child,
      required this.description,
      required this.showCaseKey});
  final Widget child;
  final String description;
  final GlobalKey showCaseKey;

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: showCaseKey,
      description: description,
      child: child,
    );
  }
}
