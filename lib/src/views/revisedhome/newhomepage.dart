// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks, unused_import

import 'dart:developer';
import 'dart:ui';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/models/game_history_model.dart';
import 'package:walk/src/server/api.dart';
import 'package:walk/src/utils/awshelper.dart/awsauth.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/custom_notification.dart';
import 'package:walk/src/utils/firebasehelper.dart/firebasedb.dart';
import 'package:walk/src/views/device/chart_details.dart';
import 'package:walk/src/views/home_page.dart';

import 'package:walk/src/views/user/revisedaccountpage.dart';
import 'package:walk/src/widgets/homepage/devicecontrolbutton.dart';
import 'package:walk/src/widgets/homepage/gamehistorybuilder.dart';
import 'package:walk/src/widgets/homepage/therapysessionbutton.dart';
import 'package:walk/src/widgets/homepage/todaysgoalcontainer.dart';
import 'package:walk/src/widgets/navigation_drawer.dart';
import 'package:walk/src/widgets/homepage/usernametext.dart';

import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class RevisedHomePage extends StatefulWidget {
  const RevisedHomePage(
      {super.key, required this.isLoggedIn, required this.logOut});

  final Function isLoggedIn;
  final Function logOut;

  @override
  State<RevisedHomePage> createState() => _RevisedHomePageState();
}

////To be added : Wifi scanning , animation ball thing , app shortcut
////App shortcut is necessary

class _RevisedHomePageState extends State<RevisedHomePage>
    with WidgetsBindingObserver {
  // late DeviceController deviceController;
  GlobalKey homePagekey = GlobalKey();

  // homepage tour

  late TutorialCoachMark tutorialCoachMark;

  //global keys for each widget
  GlobalKey keyPage = GlobalKey();
  GlobalKey keyGoalBox = GlobalKey();
  GlobalKey keyGames = GlobalKey();
  GlobalKey keyControl = GlobalKey();
  GlobalKey keyScore = GlobalKey();

  //keys for app bar
  GlobalKey keyAccount = GlobalKey();
  GlobalKey keyBattery = GlobalKey();
  GlobalKey keyMenu = GlobalKey();

  ////Also add the option for adding the app shortcut icon in the homescreen
  @override
  void initState() {
    createTutorial();
    Future.delayed(Duration.zero, showTutorial);
    super.initState();
    widget.isLoggedIn();
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

    // NotificationService.notificationPermission(context);
    //
    // // send data to cloud when network is availabe
    // sendDataWhenNetworkAvailable();
    // //triggering the scheduled notifications
    // // NotificationService.cancelScheduledNotifications();
    // // NotificationService.sendScheduledTestNotification();
    // AwesomeNotifications().getGlobalBadgeCounter().then(
    //   (value) {
    //     log(value.toString());
    //     value = 0;
    //     AwesomeNotifications().setGlobalBadgeCounter(0);
    //   },
    // );
    // NotificationService(context).listenToNotificationResults();

    WidgetsBinding.instance.addObserver(this);
    WidgetsFlutterBinding.ensureInitialized();
    // deviceController = DeviceController();
    context.read<DeviceController>().homeContext = homepageKey.currentContext;

    // NotificationService.listenToNotificationResults();
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
    // print(AWSAuth.fetchAuthSession());

    return Scaffold(
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
                push: const Revisedaccountpage(),
              );
            },
            icon: const Icon(
              Icons.person_2_outlined,
            ),
          ),
        ],
      ),
      drawer: navigationDrawer(context, widget.isLoggedIn, widget.logOut),
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
                  const TodaysGoalBox(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ////Device Control and AI therapy session control buttons
                      DeviceControlBtn(
                        pKey: keyControl,
                      ),
                      TherapySessionBtn(pKey: keyGames),
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
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    // targets.add(
    //   TargetFocus(
    //     identify: "keyBottomNavigation1",
    //     keyTarget: homePagekey,
    //     alignSkip: Alignment.topRight,
    //     enableOverlayTab: true,
    //     contents: [
    //       TargetContent(
    //         align: ContentAlign.top,
    //         builder: (context, controller) {
    //           return const Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    //               Text(
    //                 "Titulo lorem ipsum",
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ],
    //           );
    //         },
    //       ),
    //     ],
    //   ),
    // );

    // targets.add(
    //   TargetFocus(
    //     identify: "keyBottomNavigation2",
    //     // keyTarget: keyBottomNavigation2,
    //     alignSkip: Alignment.topRight,
    //     contents: [
    //       TargetContent(
    //         align: ContentAlign.top,
    //         builder: (context, controller) {
    //           return const Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    //               Text(
    //                 "Titulo lorem ipsum",
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ],
    //           );
    //         },
    //       ),
    //     ],
    //   ),
    // );

    // targets.add(
    //   TargetFocus(
    //     identify: "keyBottomNavigation3",
    //     // keyTarget: keyBottomNavigation3,
    //     alignSkip: Alignment.topRight,
    //     contents: [
    //       TargetContent(
    //         align: ContentAlign.top,
    //         builder: (context, controller) {
    //           return Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    //               const Text(
    //                 "Titulo lorem ipsum",
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 10,
    //               ),
    //               ElevatedButton(
    //                 onPressed: () {
    //                   tutorialCoachMark.goTo(0);
    //                 },
    //                 child: const Text('Go to index 0'),
    //               ),
    //             ],
    //           );
    //         },
    //       ),
    //     ],
    //   ),
    // );
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: keyAccount,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
    // targets.add(
    //   TargetFocus(
    //     identify: "Target 1",
    //     // keyTarget: keyButton,
    //     color: Colors.purple,
    //     contents: [
    //       TargetContent(
    //         align: ContentAlign.bottom,
    //         builder: (context, controller) {
    //           return Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    //               const Text(
    //                 "Titulo lorem ipsum",
    //                 style: TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.white,
    //                   fontSize: 20.0,
    //                 ),
    //               ),
    //               const Padding(
    //                 padding: EdgeInsets.only(top: 10.0),
    //                 child: Text(
    //                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
    //                   style: TextStyle(color: Colors.white),
    //                 ),
    //               ),
    //               ElevatedButton(
    //                 onPressed: () {
    //                   controller.previous();
    //                 },
    //                 child: const Icon(Icons.chevron_left),
    //               ),
    //             ],
    //           );
    //         },
    //       )
    //     ],
    //     shape: ShapeLightFocus.RRect,
    //     radius: 5,
    //   ),
    // );
    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: keyControl,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Titulo lorem ipsum",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
      ),
    );
    targets.add(TargetFocus(
      identify: "Target 3",
      keyTarget: keyGames,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            // customPosition: CustomTargetContentPosition(
            //   top: 200,
            //   left: 50,
            // ),
            child: Stack(
              children: [
                Container(
                  color: const Color.fromRGBO(0, 0, 0, 0.5),
                  child: Container(
                    color: Colors.white,
                    child: const Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                        ),
                      ],
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.settings,
                  ),
                ),
              ],
            )

            // Column(
            //   mainAxisSize: MainAxisSize.min,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: <Widget>[
            //     Text(
            //       "Title lorem ipsum",
            //       style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white,
            //           fontSize: 20.0),
            //     ),
            //     Padding(
            //       padding: EdgeInsets.only(top: 10.0),
            //       child: Text(
            //         "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
            //         style: TextStyle(color: Colors.white),
            //       ),
            //     )
            //   ],
            // ),
            ),
      ],
      shape: ShapeLightFocus.RRect,
    ));
    targets.add(TargetFocus(
      identify: "Target 4",
      keyTarget: keyScore,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  tutorialCoachMark.previous();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.network(
                    "https://juststickers.in/wp-content/uploads/2019/01/flutter.png",
                    height: 200,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Image Load network",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
              const Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
      shape: ShapeLightFocus.Circle,
    ));
    // targets.add(
    //   TargetFocus(
    //     identify: "Target 5",
    //     // keyTarget: keyButton2,
    //     shape: ShapeLightFocus.Circle,
    //     contents: [
    //       TargetContent(
    //         align: ContentAlign.top,
    //         child: const Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: <Widget>[
    //             Padding(
    //               padding: EdgeInsets.only(bottom: 20.0),
    //               child: Text(
    //                 "Multiples contents",
    //                 style: TextStyle(
    //                     color: Colors.white,
    //                     fontWeight: FontWeight.bold,
    //                     fontSize: 20.0),
    //               ),
    //             ),
    //             Text(
    //               "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
    //               style: TextStyle(color: Colors.white),
    //             ),
    //           ],
    //         ),
    //       ),
    //       TargetContent(
    //           align: ContentAlign.bottom,
    //           child: const Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: <Widget>[
    //               Padding(
    //                 padding: EdgeInsets.only(bottom: 20.0),
    //                 child: Text(
    //                   "Multiples contents",
    //                   style: TextStyle(
    //                       color: Colors.white,
    //                       fontWeight: FontWeight.bold,
    //                       fontSize: 20.0),
    //                 ),
    //               ),
    //               Text(
    //                 "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin pulvinar tortor eget maximus iaculis.",
    //                 style: TextStyle(color: Colors.white),
    //               ),
    //             ],
    //           ))
    //     ],
    //   ),
    // );

    return targets;
  }
}
