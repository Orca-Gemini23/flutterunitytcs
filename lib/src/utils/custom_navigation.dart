import 'package:flutter/material.dart';

class Go extends Navigator {
  const Go({super.key});

// main navigation stack
  static to({required BuildContext context, required Widget push}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => push));
  }

  static back({
    required BuildContext context,
  }) {
    Navigator.of(context).pop();
  }

  static pushReplacement(
      {required BuildContext context, required Widget pushReplacement}) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => pushReplacement));
  }

  static pushAndRemoveUntil(
      {required BuildContext context, required Widget pushReplacement}) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => pushReplacement),
        (route) => false);
  }

// account navigation
  static Future<void> navigatoTo(
      {required BuildContext context,
      required String route,
      Object? arguments,
      bool isRootNavigator = false}) {
    return Navigator.of(context, rootNavigator: isRootNavigator)
        .pushNamed(route, arguments: arguments);
  }

  static void navigateBack(
      {required BuildContext context,
      required GlobalKey<NavigatorState> key,
      bool isRootNavigator = false}) {
    return key.currentState?.pop();
  }
}
