import 'package:flutter/cupertino.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseView extends StatelessWidget {
  ///Provides Showcase to widgets ie: When the user first time opens the application he/she is guided as to what the different buttons do where will the scanned items be shown.A bit like a tutorial of the application.
  const ShowCaseView({
    super.key,
    required this.globalKey,
    required this.title,
    required this.description,
    required this.child,
    this.shapeBorder = const CircleBorder(),
  });

  final GlobalKey globalKey;
  final String title;
  final String description;
  final Widget child;
  final ShapeBorder shapeBorder;

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: globalKey,
      title: title,
      description: description,
      shapeBorder: shapeBorder,
      child: child,
    );
  }
}
