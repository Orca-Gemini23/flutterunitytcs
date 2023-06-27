import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:walk/src/controllers/auth_controller.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/controllers/help_controller.dart';
import 'package:walk/src/controllers/user_controller.dart';
import 'package:walk/src/controllers/wifi_controller.dart';
import 'package:walk/src/views/splash_page.dart';

class WalkApp extends StatelessWidget {
  const WalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => DeviceController(
              performScan: true,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => WifiController(),
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
        ],
        child: const MaterialApp(
          home: SplashPage(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
