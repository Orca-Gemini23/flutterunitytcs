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
import 'package:walk/src/models/game_history_model.dart';

import 'package:walk/src/views/revisedsplash.dart';

class WalkApp extends StatelessWidget {
  const WalkApp({super.key});

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
              home: const Revisedsplash(),
              theme: ThemeData(fontFamily: "Poppins"),
              debugShowCheckedModeBanner: false,
            );
          }),
    );
  }
}
