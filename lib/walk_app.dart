import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:walk/src/controllers/animation_controller.dart';
import 'package:walk/src/controllers/auth_controller.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/controllers/game_controller.dart';
import 'package:walk/src/controllers/game_history_controller.dart';
import 'package:walk/src/controllers/help_controller.dart';
import 'package:walk/src/controllers/user_controller.dart';
import 'package:walk/src/controllers/wifi_controller.dart';
import 'package:walk/src/views/revisedhome/newhomepage.dart';
import 'package:walk/src/views/revisedsplash.dart';

bool _isLoggedIn = false;

class WalkApp extends StatefulWidget {
  const WalkApp({super.key});

  @override
  State<WalkApp> createState() => _WalkAppState();
}

class _WalkAppState extends State<WalkApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DeviceController(
            performScan: false,
            checkPrevconnection: true,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => WifiController(),
        ),
        ProxyProvider<DeviceController, AnimationValuesController>(
          update: (context, value, previous) => AnimationValuesController(
            leftAngleValue: value.leftAngleValue,
            rightAngleValue: value.rightAngleValue,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthController(),
        ),
        ChangeNotifierProvider(
          create: (_) => HelpController(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserController(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameController(),
        ),
        ChangeNotifierProvider(
          create: (_) => GameHistoryController(),
        ),
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 800),
          builder: (context, child) {
            return MaterialApp(
              home: RevisedHomePage(
                isLoggedIn: () {},
                logOut: () {},
              ), //Revisedsplash(isLoggedIn: () {}, logOut: () {}),
              // _isLoggedIn
              //     ? Revisedsplash(isLoggedIn: () {}, logOut: () {})
              //     : LoginRegister(isLoggedIn: () {}, logOut: () {}),
              theme: ThemeData(fontFamily: "Poppins"),
              debugShowCheckedModeBanner: false,
            );
          }),
    );
  }
}
