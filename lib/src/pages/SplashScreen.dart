import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/shared_preferences.dart';
import 'package:walk/src/db/firebase_storage.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/pages/AccountPage.dart';
import 'package:walk/src/pages/HomePage.dart';
import 'package:walk/src/server/api.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/firebasehelper.dart/firebasedb.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/views/auth/guest_login_ios.dart';
import 'package:walk/src/views/auth/phone_auth.dart';

bool tour = false;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _fontSize = 2;
  double _containerSize = 2;
  double _textOpacity = 0.0;
  double _containerOpacity = 0.0;
  double imageSize = DeviceSize.isTablet ? 3 : 4;

  late AnimationController _controller;
  late Animation<double> animation1;

  @override
  void initState() {
    super.initState();

    _loadPreferences();
    _initializeAnimation();

    Timer(const Duration(seconds: 1), () {
      setState(() {
        _fontSize = 1.06;
        // imageSize = 5;
      });
    });

    Timer(const Duration(seconds: 1), () {
      setState(() {
        _containerSize = 1.5;
        _containerOpacity = 1;
      });
    });

    Timer(const Duration(seconds: 3), _navigateUser);
  }

  void _loadPreferences() {
    PreferenceController.getstringData("Height").then((value) {
      setState(() {
        DetailsPage.height = value;
      });
    });
    PreferenceController.getstringData("Weight").then((value) {
      setState(() {
        DetailsPage.weight = value;
      });
    });
    PreferenceController.getstringData("profileImage").then((value) {
      setState(() {
        ImagePath.path = value;
      });
    });
  }

  void _initializeAnimation() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation1 = Tween<double>(begin: 40, end: 20)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {
          _textOpacity = 1.0;
        });
      });
    _controller.forward();
  }

  Future<void> _navigateUser() async {
    if (FirebaseAuth.instance.currentUser == null) {
      debugPrint('User is currently signed out!');
      setState(() {
        tour = false;
      });
      _navigateToAuthPage();
    } else {
      debugPrint('User is signed in!');
      await Analytics.start();
      await _loadUserData();
      if (mounted) {
        setState(() {
          tour = true;
        });
        _navigateToHomePage();
      }
    }
  }

  void _navigateToAuthPage() {
    if (Platform.isIOS) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GuestUserLogin(),
          settings: const RouteSettings(name: '/iosguestuser'),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PhoneAuthPage(),
          settings: const RouteSettings(name: '/authpage'),
        ),
      );
    }
  }

  Future<void> _loadUserData() async {
    if (LocalDB.user!.name == "Unknown User") {
      FirebaseStorageDB.downloadFiles();
    }
    if (LocalDB.user!.name == "Unknown User") {
      debugPrint("splash screen rds data call");
      await API.getUserDetails();
    }
    if (LocalDB.user!.name == "Unknown User") {
      debugPrint("splash screen firebase data call");
      await API.getUserDetailsFireStore();
    }
  }

  void _navigateToHomePage() {
    if (LocalDB.user!.name == "Unknown User") {
      setState(() {
        UserDetails.unavailable = true;
      });
      Go.pushReplacement(
          context: context, pushReplacement: const AccountPage());
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
          settings: const RouteSettings(name: '/home'),
        ),
      );
    }
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
      backgroundColor: AppColor.greenDarkColor,
      body: Stack(
        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeInOut,
                height: height / _fontSize - 100,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1500),
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
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOut,
              opacity: _containerOpacity,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeInOut,
                height: (width / _containerSize).h,
                width: (width / _containerSize).w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "WALK",
                  style: TextStyle(
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
          transitionDuration: const Duration(milliseconds: 1500),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
              curve: Curves.easeInOut,
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
