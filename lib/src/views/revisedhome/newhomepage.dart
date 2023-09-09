// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks, unused_import

import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_color.dart';

import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/models/game_history_model.dart';

import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/firebasehelper.dart/firebasedb.dart';
import 'package:walk/src/views/device/chart_details.dart';

import 'package:walk/src/views/user/revisedaccountpage.dart';
import 'package:walk/src/widgets/homepage/devicecontrolbutton.dart';
import 'package:walk/src/widgets/homepage/therapysessionbutton.dart';
import 'package:walk/src/widgets/homepage/todaysgoalcontainer.dart';
import 'package:walk/src/widgets/navigation_drawer.dart';
import 'package:walk/src/widgets/homepage/usernametext.dart';

class RevisedHomePage extends StatefulWidget {
  const RevisedHomePage({super.key});

  @override
  State<RevisedHomePage> createState() => _RevisedHomePageState();
}

////To be added : Wifi scanning , animation ball thing , app shortcut
////App shortcut is necessary

class _RevisedHomePageState extends State<RevisedHomePage>
    with WidgetsBindingObserver {
  late DeviceController deviceController;
  late Future<GameHistory?> userGameHistoryFuture;

  ////Also add the option for adding the app shortcut icon in the homescreen
  @override
  void initState() {
    super.initState();
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

    WidgetsBinding.instance.addObserver(this);
    WidgetsFlutterBinding.ensureInitialized();
    deviceController = DeviceController();
    userGameHistoryFuture = FirebaseDB.getUserGameHistory();

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
    print(
        "------------------------Building Home Page UI--------------------------");
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        actions: [
          IconButton(
            onPressed: () {
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
        child: SafeArea(
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ////Device Control and AI therapy session control buttons
                  DeviceControlBtn(),
                  TherapySessionBtn(),
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
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: AppColor.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FutureBuilder<GameHistory?>(
                    future: userGameHistoryFuture,
                    builder: (context, snapshot) {
                      print(snapshot.data.toString());
                      if (snapshot.hasData) {
                        if (snapshot.data == null) {
                          return const Center(
                            child: Text(
                                "No data to show , please do a therapy sesssion"),
                          );
                        } else {
                          return DetailChart(historyData: snapshot.data!);
                        }
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Coming Soon"),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.greenDarkColor,
                            strokeWidth: 5,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.greenDarkColor,
        onPressed: () {
          setState(() {});
        },
        child: const Icon(
          Icons.refresh,
          size: 30,
        ),
      ),
    );
  }
}
