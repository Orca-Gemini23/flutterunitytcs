import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:walk/main.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/controllers/game_history_controller.dart';
import 'package:walk/src/controllers/user_controller.dart';
import 'package:walk/src/models/firestoreusermodel.dart';
import 'package:walk/src/server/upload.dart';
import 'package:walk/src/utils/firebasehelper.dart/firebasedb.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/views/faqscreens/faqpage.dart';
import 'package:walk/src/views/org_info/about_us.dart';
import 'package:walk/src/views/org_info/contact_us.dart';
import 'package:walk/src/views/reports/reporttiles.dart';
import 'package:walk/src/views/reviseddevicecontrol/connectionscreen.dart';
import 'package:walk/src/views/reviseddevicecontrol/newdevicecontrol.dart';
import 'package:walk/src/views/revisedhome/newhomepage.dart';
import 'package:walk/src/views/revisedsplash.dart';
import 'package:walk/src/views/therapyentrypage/therapypage.dart';
import 'package:walk/src/views/user/newrevisedaccountpage.dart';
import 'package:walk/src/views/user/tutorial.dart';

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

  final MyNavigatorObserver myNavigatorObserver = MyNavigatorObserver();

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
        ChangeNotifierProvider(
          create: (_) => Report(),
        ),
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 800),
          builder: (context, child) {
            if (DeviceSize.checkTablet(context)) DeviceSize.isTablet = true;
            return MaterialApp(
              navigatorKey: navigatorKey,
              // home: const Revisedsplash(),
              navigatorObservers: [myNavigatorObserver],
              initialRoute: "/",
              routes: {
                ConnectionScreen.route: (context) => const ConnectionScreen(),
                '/': (context) => const Revisedsplash(),
                '/home': (context) => const RevisedHomePage(),
                '/connectionscreen': (context) => const ConnectionScreen(),
                '/devicecontrol': (context) => const DeviceControlPage(),
                '/therapypage': (context) => const TherapyEntryPage(),
                '/accountpage': (context) => const NewRevisedAccountPage(),
                '/reports': (context) => const ReportList(),
                '/aboutus': (context) => const AboutUsPage(),
                '/contactus': (context) => const ContactUsPage(),
                '/tutorial': (context) => const TutorialPage(),
                '/faq': (context) => const Faqpage(),
                // '/subscription': (context) => const SubscriptionPlans(),
              },
              theme: ThemeData(
                  textSelectionTheme: const TextSelectionThemeData(
                    selectionHandleColor: Colors.transparent,
                  ),
                  useMaterial3: false, fontFamily: "Poppins"), //Helvetica
              debugShowCheckedModeBanner: false,
            );
          }),
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  static final List<String> routeStack = [];
  String currentRoute = '';

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is MaterialPageRoute) {
      currentRoute = route.settings.name ?? 'Unknown';
      routeStack.add(currentRoute);
      if (CollectAnalytics.start) {
        Analytics.addNavigation(AnalyticsNavigationModel(
                landingPage: currentRoute, landTime: DateTime.timestamp())
            .toJson());
      } else {
        CollectAnalytics.initialData.add(AnalyticsNavigationModel(
                landingPage: currentRoute, landTime: DateTime.timestamp())
            .toJson());
      }
      // log('1. Navigated to: $currentRoute');
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    log(routeStack.toString());
    // routeStack.removeLast(); //  remove(route);
    if (previousRoute is MaterialPageRoute) {
      if (CollectAnalytics.start) {
        currentRoute = previousRoute.settings.name ?? routeStack.last;
        Analytics.addNavigation(AnalyticsNavigationModel(
                landingPage: currentRoute, landTime: DateTime.timestamp())
            .toJson());
      } else {
        CollectAnalytics.initialData.add(AnalyticsNavigationModel(
                landingPage: currentRoute, landTime: DateTime.timestamp())
            .toJson());
      }
      // log('2. Returned to: $currentRoute');
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    // if (CollectAnalytics.start) {
    //   Analytics.addNavigation(AnalyticsNavigationModel(
    //     landingPage: route.settings.name ?? routeStack.last,
    //     landTime: DateTime.timestamp(),
    //   ).toJson());
    // } else {
    //   CollectAnalytics.initialData.add(AnalyticsNavigationModel(
    //           landingPage: currentRoute, landTime: DateTime.timestamp())
    //       .toJson());
    // }
    // log('3. Removed route: ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is MaterialPageRoute) {
      currentRoute = newRoute.settings.name ?? 'Unknown';
      if (CollectAnalytics.start) {
        Analytics.addNavigation(AnalyticsNavigationModel(
                landingPage: currentRoute, landTime: DateTime.timestamp())
            .toJson());
      } else {
        CollectAnalytics.initialData.add(AnalyticsNavigationModel(
                landingPage: currentRoute, landTime: DateTime.timestamp())
            .toJson());
      }
      // log('4. Replaced with: $currentRoute');
    }
  }
}
