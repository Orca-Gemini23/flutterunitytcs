import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:walk/controllers/sharedpreferences.dart';
import 'package:walk/views/homepage.dart';
import 'package:walk/views/loginandregisterpage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isShowCasedone = true;

  checkshowcase() async {
    bool result = await PreferenceController.getboolData(showCaseKey);
    log("Showcase result is $result ");
    _isShowCasedone = result;
  }

  Route _createRoute(bool showCaseDone) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) => ShowCaseWidget(
        builder: Builder(
          builder: (context) => Homepage(isShowCaseDone: showCaseDone),
        ),
      ),
      transitionsBuilder: ((context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 10.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;
        var tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    checkshowcase();

    Timer(
      const Duration(seconds: 2),
      (() => Navigator.pushReplacement(
            context,
            _createRoute(_isShowCasedone),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -140,
              left: -140,
              child: Image.asset(
                "assets/images/dottedbackground.png",
              ),
            ),
            const Center(
              child: Text(
                "LT",
                style: TextStyle(
                  fontSize: 80,
                  letterSpacing: 8,
                  color: Color(
                    0xff005749,
                  ),
                ),
              ),
            ),
            const Positioned(
              bottom: 80,
              child: Text(
                "Lifespark Technologies",
                style: TextStyle(
                    color: Color(0xff005749),
                    fontSize: 30,
                    fontWeight: FontWeight.w300),
              ),
            )
          ],
        ),
      ),
    );
  }
}
