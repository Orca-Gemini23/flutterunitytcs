import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/controllers/devicecontroller.dart';
import 'package:walk/src/controllers/wificontroller.dart';
import 'package:walk/src/views/splashpage.dart';

class WalkApp extends StatelessWidget {
  const WalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => DeviceController(),
          ),
          ChangeNotifierProvider(
            create: (_) => WifiController(),
          ),
        ],
        child: const MaterialApp(
          home: SplashPage(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
