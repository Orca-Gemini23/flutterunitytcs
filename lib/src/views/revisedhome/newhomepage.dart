import 'dart:developer';
import 'dart:ui';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/global_variables.dart';
import 'package:walk/src/views/revisedsplash.dart';
import 'package:walk/src/views/user/newrevisedaccountpage.dart';

import 'package:walk/src/widgets/homepage/devicecontrolbutton.dart';
import 'package:walk/src/widgets/homepage/gamehistorybuilder.dart';
import 'package:walk/src/widgets/homepage/therapysessionbutton.dart';
import 'package:walk/src/widgets/homepage/todaysgoalcontainer.dart';
import 'package:walk/src/widgets/navigation_drawer.dart';
import 'package:walk/src/widgets/homepage/usernametext.dart';

import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

final GlobalKey keyMenu = GlobalKey();

class RevisedHomePage extends StatefulWidget {
  const RevisedHomePage({super.key});

  @override
  State<RevisedHomePage> createState() => _RevisedHomePageState();
}

////To be added : Wifi scanning , animation ball thing , app shortcut
////App shortcut is necessary

class _RevisedHomePageState extends State<RevisedHomePage>
    with WidgetsBindingObserver {
  // late DeviceController deviceController;
  final GlobalKey homePagekey = GlobalKey();

  // homepage tour

  late TutorialCoachMark tutorialCoachMark;

  //global keys for each widget
  final GlobalKey keyPage = GlobalKey();
  final GlobalKey keyGames = GlobalKey();
  final GlobalKey keyControl = GlobalKey();
  final GlobalKey keyScore = GlobalKey();
  final GlobalKey keyGoalBox = GlobalKey();

  //keys for app bar
  final GlobalKey keyAccount = GlobalKey();
  final GlobalKey keyBattery = GlobalKey();

  ////Also add the option for adding the app shortcut icon in the homescreen
  @override
  void initState() {
    debugPrint(tour.toString());
    FirebaseAnalytics.instance.logScreenView(screenName: 'Homepage').then(
          (value) => debugPrint("Analytics stated"),
        );
    UserDetails.unavailable = false;
    if (!tour) {
      tour = !tour;
      createTutorial();
      Future.delayed(Duration.zero, showTutorial);
    }
    super.initState();
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

    WidgetsBinding.instance.addObserver(this);
    WidgetsFlutterBinding.ensureInitialized();
    context.read<DeviceController>().homeContext = homePagekey.currentContext;
    // UploadData.uplaod();
    // FirebaseStorageDB.getData();
    // FilePathChange.getExternalFiles();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        {
          log("Application is paused");
          //Trigger Notification here
          // if (deviceController.connectedDevice == null) {
          //   await NotificationService.sendNotificationWithButtons();
          // } else {
          //   NotificationService.sendNormalTestNotification();
          // }
          //FlutterBackgroundService().invoke("setAsForeground");

          break;
        }

      case AppLifecycleState.resumed:
        {
          // log("Application resumed");
          // if (await FlutterBackgroundService().isRunning()) {
          //   FlutterBackgroundService().invoke("setAsBackground");
          // }
          // await AwesomeNotifications().cancelAll();
          break;
        }

      default:
        {
          break;
        }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     "------------------------Building Home Page UI--------------------------");
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      key: homePagekey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        actions: [
          IconButton(
            key: keyAccount,
            onPressed: () {
              // FirebaseCrashlytics.instance.crash();
              Go.to(
                context: context,
                push: const NewRevisedAccountPage(),
              );
            },
            icon: const Icon(
              Icons.person_2_outlined,
            ),
          ),
        ],
      ),
      drawer: navigationDrawer(context),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: 15,
        ),
        decoration: const BoxDecoration(
          color: AppColor.whiteColor,
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UsernameText(),
                  Text(
                    "How are you feeling today?",
                    style: TextStyle(
                        color: AppColor.greenDarkColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TodaysGoalBox(goalBoxKey: keyGoalBox),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ////Device Control and AI therapy session control buttons
                      DeviceControlBtn(deviceControlKey: keyControl),
                      TherapySessionBtn(therapySessionKey: keyGames),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Monthly Statistics",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    ////Report And Charts
                    child: Container(
                      key: keyScore,
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: AppColor.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const GameHistoryBuilder(),
                    ),
                  ),
                  SizedBox(height: bottomPadding),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: AppColor.greenDarkColor,
      //   onPressed: () {
      //     setState(() {});
      //   },
      //   child: const Icon(
      //     Icons.refresh,
      //     size: 30,
      //   ),
      // ),
    );
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: const Color.fromRGBO(0, 0, 0, 0.5),
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.5,
      pulseEnable: false,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        log("finish");
      },
      onClickTarget: (target) {
        log('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        log("target: $target");
        log("clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        log('onClickOverlay: $target');
      },
      onSkip: () {
        return true;
      },
      // focusAnimationDuration: const Duration(milliseconds: 200),
      // unFocusAnimationDuration: const Duration(milliseconds: 200),
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: keyAccount,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(left: 0),
            builder: (context, controller) {
              return Image.asset(
                'assets/images/tour/2.png',
                scale: 3,
              );
            },
          ),
        ],
      ),
    );
    // targets.add(
    //   TargetFocus(
    //     identify: "Target 6",
    //     keyTarget: keyMenu,
    //     enableOverlayTab: true,
    //     contents: [
    //       TargetContent(
    //         align: ContentAlign.right,
    //         // customPosition: CustomTargetContentPosition(top: 425, right: 70),
    //         builder: (context, controller) {
    //           return Image.asset('assets/images/tour/menu.png');
    //         },
    //       ),
    //     ],
    //     shape: ShapeLightFocus.RRect,
    //   ),
    // );
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyGoalBox,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            // customPosition: CustomTargetContentPosition(top: 425, right: 70),
            builder: (context, controller) {
              return Image.asset(
                'assets/images/tour/6.png',
                scale: 3,
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: keyControl,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            // customPosition: CustomTargetContentPosition(top: 425, right: 70),
            builder: (context, controller) {
              return Image.asset('assets/images/tour/1.png', scale: 3);
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 3",
        keyTarget: keyGames,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            // customPosition: CustomTargetContentPosition(top: 425, left: 70),
            child: Image.asset(
              'assets/images/tour/7.png',
              scale: 3,
            ),
          ),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 4",
        keyTarget: keyScore,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            // customPosition: CustomTargetContentPosition(top: 350),
            child: Image.asset(
              'assets/images/tour/5.png',
              scale: 3,
            ),
          ),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );

    return targets;
  }
}
