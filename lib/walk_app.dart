import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/controllers/game_history_controller.dart';
import 'package:walk/src/controllers/user_controller.dart';
import 'package:walk/src/views/revisedsplash.dart';

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DeviceController(
            performScan: false,
            checkPrevconnection: true,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => UserController(),
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
              theme: ThemeData(
                  useMaterial3: false, fontFamily: "Poppins"), //Helvetica
              debugShowCheckedModeBanner: false,
            );
          }),
    );
  }
}
