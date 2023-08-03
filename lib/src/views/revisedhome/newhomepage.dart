import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/controllers/device_controller.dart';
import 'package:walk/src/db/local_db.dart';
import 'package:walk/src/models/user_model.dart';
import 'package:walk/src/utils/custom_navigation.dart';

import 'package:walk/src/views/artherapy/rivetherapypage.dart';

import 'package:walk/src/views/reviseddevicecontrol/connectionscreen.dart';
import 'package:walk/src/views/reviseddevicecontrol/newdevicecontrol.dart';
import 'package:walk/src/views/user/revisedaccountpage.dart';
import 'package:walk/src/widgets/navigation_drawer.dart';

class RevisedHomePage extends StatefulWidget {
  const RevisedHomePage({super.key});

  @override
  State<RevisedHomePage> createState() => _RevisedHomePageState();
}

class _RevisedHomePageState extends State<RevisedHomePage> {
  @override
  void initState() {
    super.initState();
    ////Can check for tutorial completion if not display a simple dialog
  }

  bool _isDeviceButtonTapped = false;
  bool _isTherapyButtonTapped = false;

  @override
  Widget build(BuildContext context) {
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
              Icons.person,
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
              ValueListenableBuilder<Box<UserModel>>(
                valueListenable: LocalDB.listenableUser(),
                builder: (contex, userBox, child) {
                  return Text(
                    "Hello ${userBox.get(
                          0,
                          defaultValue: LocalDB.defaultUser,
                        )!.name},",
                    style: TextStyle(
                      color: AppColor.greenDarkColor,
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
              ),
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
              Container(
                ////Todays's goal Container

                padding: const EdgeInsets.only(
                    top: 20, bottom: 20, left: 10, right: 10),
                width: double.maxFinite,
                height: 158.h,
                decoration: BoxDecoration(
                  color: AppColor.greenDarkColor,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 2,
                      color: AppColor.greyLight,
                    )
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      child: Image(
                        fit: BoxFit.contain,
                        width: 143.w,
                        height: 105.h,
                        image: const AssetImage("assets/images/re1.png"),
                      ),
                    ),
                    Positioned(
                      right: 25,
                      top: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today's Goal",
                            style: TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 16.sp,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Completed',
                                  style: TextStyle(
                                    color: AppColor.whiteColor,
                                    fontSize: 16.sp,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(
                                    width: 5,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: Icon(
                                    Icons.verified,
                                    color: AppColor.amberColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Gait Score : ",
                            style: TextStyle(
                                color: AppColor.whiteColor, fontSize: 12.sp),
                          ),
                          Text(
                            "Balance Score : ",
                            style: TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 12.sp,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ////Device Control and AI therapy session control buttons
              Consumer<DeviceController>(builder: (
                context,
                deviceController,
                widget,
              ) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: AppColor.greenDarkColor,
                      onHighlightChanged: (value) {
                        setState(() {
                          _isDeviceButtonTapped = value;
                        });
                      },
                      onTap: () async {
                        await deviceController.checkPrevConnection();
                        if (deviceController.connectedDevice ==
                            null) ////no device yet connected
                        {
                          Go.to(
                            context: context,
                            push: const ConnectionScreen(),
                          );
                        } else {
                          Go.to(
                            context: context,
                            push: const DeviceControlPage(),
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastLinearToSlowEaseIn,
                        height: _isDeviceButtonTapped ? 145.h : 150.h,
                        width: _isDeviceButtonTapped ? 147.w : 154.w,
                        child: Container(
                          height: 150.h,
                          width: 154.w,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.lightgreen,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              deviceController.connectedDevice != null
                                  ? const BoxShadow(
                                      color: AppColor.greenDarkColor,
                                      blurRadius: 4,
                                      spreadRadius: 1)
                                  : const BoxShadow(
                                      color: AppColor.greyLight,
                                      offset: Offset(0, 4),
                                      blurRadius: 4,
                                      spreadRadius: 2),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 92.w,
                                height: 92.h,
                                child: const Image(
                                  fit: BoxFit.contain,
                                  color: AppColor.blackColor,
                                  image: AssetImage(
                                    "assets/images/devicecontrol.png",
                                  ),
                                ),
                              ),
                              Text(
                                "Device Control",
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: AppColor.greenDarkColor,
                      onHighlightChanged: (value) {
                        setState(() {
                          _isTherapyButtonTapped = value;
                        });
                      },
                      onTap: () async {
                        AwesomeDialog(
                                dismissOnBackKeyPress: false,
                                dismissOnTouchOutside: false,
                                context: context,
                                dialogType: DialogType.info,
                                title: "Getting The Game Ready")
                            .show();
                        RiveFile riveAnimtion;

                        await RiveFile.asset(
                                "assets/images/animations/3795-7943-calibration-2.riv")
                            .then(
                          (value) {
                            riveAnimtion = value;
                            Navigator.of(context, rootNavigator: true).pop();
                            Go.to(
                              context: context,
                              push: Rivetherapypage(
                                riveFile: riveAnimtion,
                              ),
                            );
                          },
                        );

                        // ignore: use_build_context_synchronously
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastLinearToSlowEaseIn,
                        height: _isTherapyButtonTapped ? 145.h : 150.h,
                        width: _isTherapyButtonTapped ? 147.w : 154.w,
                        child: Container(
                          height: 150.h,
                          width: 154.w,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: AppColor.greyLight,
                                  offset: Offset(0, 4),
                                  blurRadius: 4,
                                  spreadRadius: 2)
                            ],
                            color: AppColor.lightgreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 92.w,
                                height: 92.h,
                                child: const Image(
                                  fit: BoxFit.contain,
                                  color: AppColor.blackColor,
                                  image: AssetImage(
                                    "assets/images/therapysession.png",
                                  ),
                                ),
                              ),
                              Text(
                                "Therapy Session",
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
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
                  decoration: BoxDecoration(
                    color: AppColor.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text("Coming Soon"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
