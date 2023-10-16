import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:walk/src/constants/app_assets.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/shared_preferences.dart';
import 'package:walk/src/views/devicecodepage/device_code_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

String userToken = "";

class _SplashPageState extends State<SplashPage> {
  bool _isUnboxingdone = true;

  checkShowcase() async {
    bool result = await PreferenceController.getboolData(showCaseKey);
    _isUnboxingdone = await PreferenceController.getboolData("isUnboxingDone");
    log("Showcase result is $result ");
    log("Unbox result is $_isUnboxingdone");
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) => ShowCaseWidget(
        builder: Builder(builder: (context) {
          if (userToken == "") {
            return const DeviceCodePage();
            // return Homepage(
            //   isShowCaseDone: _isShowCasedone,
            //   isUnboxingDone: _isUnboxingdone,
            // ); //const LoginRegister();
          } else {
            return const DeviceCodePage();
          }
        }),
      ),
      transitionsBuilder: ((context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 10.0);
        const end = Offset.zero;

        Tween(begin: begin, end: end);

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
    checkShowcase();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, _createRoute());
    });
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
