import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:walk/main.dart';
import 'package:walk/src/constants/app_assets.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/shared_preferences.dart';
import 'package:walk/src/views/auth/first_page.dart';
import 'package:walk/src/views/home_page.dart';

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
        builder: Builder(builder: (context) {
          if (userToken == "") {
            return const LoginRegister();
          } else {
            return Homepage(isShowCaseDone: _isShowCasedone);
          }
        }),
      ),
      transitionsBuilder: ((context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 10.0);
        const end = Offset.zero;
        // const curve = Curves.easeIn;
        // var tween =
        Tween(begin: begin, end: end);
        // final curvedAnimation = CurvedAnimation(
        //   parent: animation,
        //   curve: curve,
        // );
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
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -140,
            left: -140,
            child: Image.asset(
              AppAssets.backgroundImage,
            ),
          ),
          const Center(
            child: Text(
              AppString.org,
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
              AppString.orgName,
              style: TextStyle(
                  color: Color(0xff005749),
                  fontSize: 30,
                  fontWeight: FontWeight.w300),
            ),
          )
        ],
      ),
    );
  }
}
