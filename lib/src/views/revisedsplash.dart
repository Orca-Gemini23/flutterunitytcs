import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/shared_preferences.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/server/api.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/firebasehelper.dart/firebasedb.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/views/auth/guest_login_ios.dart';
import 'package:walk/src/views/auth/phone_auth.dart';
import 'package:walk/src/views/revisedhome/newhomepage.dart';
import 'package:walk/src/views/user/newrevisedaccountpage.dart';

bool tour = false;

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

  double imageSize = 4;

  late AnimationController _controller;
  late Animation<double> animation1;

  @override
  void initState() {
    super.initState();

    // if (Platform.isIOS && LocalDB.user!.phone == "") {
    //   FirebaseAuth.instance.signOut();
    // }
    // if (LocalDB.user!.name == "Unknown User") {
    //   API.getUserDetails();
    // }
    // if (LocalDB.user!.name == "Unknown User") {
    //   API.getUserDetailsFireStore();
    // }
    // API.getUserDetailsFireStore();
    FirebaseDB.getNumbers();

    PreferenceController.getstringData("Height").then((value) {
      setState(() {
        DetailsPage.height = value;
      });
    });
    PreferenceController.getstringData("Weight").then((value) {
      setState(() {
        DetailsPage.weight = value;
        // weightController = TextEditingController(text: value);
      });
    });
    PreferenceController.getstringData("profileImage").then((value) {
      setState(() {
        ImagePath.path = value;
      });
    });

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
        imageSize = 5;
      });
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _containerSize = 1.5;
        _containerOpacity = 1;
      });
    });

    Timer(
      const Duration(seconds: 4),
      () async {
        if (FirebaseAuth.instance.currentUser == null) {
          debugPrint('User is currently signed out!');
          setState(() {
            tour = false;
          });
          if (Platform.isIOS) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GuestUserLogin()));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const PhoneAuthPage()));
          }
        } else {
          debugPrint('User is signed in!');
          if (LocalDB.user!.name == "Unknown User") {
            log("splash screen rds data call");
            await API.getUserDetails();
          }
          if (LocalDB.user!.name == "Unknown User") {
            log("splash screen firebase data call");
            await API.getUserDetailsFireStore();
          }
          if (mounted) {
            setState(() {
              tour = true;
            });
            if (LocalDB.user!.name == "Unknown User") {
              setState(() {
                UserDetails.unavailable = true;
              });
              Go.pushReplacement(
                  context: context,
                  pushReplacement: const NewRevisedAccountPage());
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RevisedHomePage()));
            }
          }
        }
      },
    );
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
      ///change here
      backgroundColor: AppColor.greenDarkColor,
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
                child: Image.asset(
                  "assets/images/group89.png",
                  scale: imageSize,
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
                  ///change here
                  // color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                // child: Image.asset('assets/images/file_name.png')
                child: Text(
                  "WALK",
                  style: TextStyle(
                    ///change here
                    color: AppColor.whiteColor,
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
