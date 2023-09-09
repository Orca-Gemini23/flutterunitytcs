import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/shared_preferences.dart';
import 'package:walk/src/views/revisedhome/newhomepage.dart';

class Revisedsplash extends StatefulWidget {
  const Revisedsplash({super.key});

  @override
  State<Revisedsplash> createState() => _RevisedsplashState();
}

class _RevisedsplashState extends State<Revisedsplash>
    with TickerProviderStateMixin {
  double _fontSize = 2;
  double _containerSize = 2;
  double _textOpacity = 0.0;
  double _containerOpacity = 0.0;
  String userToken = "";

  late AnimationController _controller;
  late Animation<double> animation1;

  void getUserToken() async {
    userToken = await PreferenceController.getstringData("customerAuthToken");
    log("userToken is $userToken");
  }

  @override
  void initState() {
    super.initState();
    getUserToken();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    animation1 = Tween<double>(begin: 40, end: 20).animate(CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        setState(() {
          _textOpacity = 1.0;
        });
      });

    _controller.forward();

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _fontSize = 1.06;
      });
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _containerSize = 1.5;
        _containerOpacity = 1;
      });
    });

    Timer(const Duration(seconds: 4), () {
      setState(() {
        userToken == ""
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/"),
                  builder: (context) =>
                      const RevisedHomePage(), ////To be changed back to login page after ensuring that the flask servers are up and running
                ),
              )
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RevisedHomePage(),
                ),
              );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Stack(
        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 2000),
                curve: Curves.fastLinearToSlowEaseIn,
                height: height / _fontSize - 100,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: _textOpacity,
                child: const Image(
                  image: AssetImage("assets/images/group43.png"),
                ),
              ),
            ],
          ),
          Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              curve: Curves.fastLinearToSlowEaseIn,
              opacity: _containerOpacity,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 2000),
                curve: Curves.fastLinearToSlowEaseIn,
                height: (width / _containerSize).h,
                width: (width / _containerSize).w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                // child: Image.asset('assets/images/file_name.png')
                child: Text(
                  "WALK",
                  style: TextStyle(
                    color: AppColor.greenDarkColor,
                    letterSpacing: 2,
                    fontSize: 55.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageTransition extends PageRouteBuilder {
  final Widget page;

  PageTransition(this.page)
      : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: const Duration(milliseconds: 2000),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
              curve: Curves.fastLinearToSlowEaseIn,
              parent: animation,
            );
            return Align(
              alignment: Alignment.bottomCenter,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: 0,
                child: page,
              ),
            );
          },
        );
}
