// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:walk/src/constants/app_color.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/auth_controller.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/screen_context.dart';
import 'package:walk/src/views/auth/signup_page.dart';
import 'package:walk/src/views/welcomedetailspage/welcome_details_page.dart';

class DeviceCodePage extends StatefulWidget {
  const DeviceCodePage({super.key});

  @override
  State<DeviceCodePage> createState() => _DeviceCodePageState();
}

class _DeviceCodePageState extends State<DeviceCodePage> {
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();

  final TextEditingController _deviceCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(
              top: 50,
              child: Image(
                height: 120,
                width: 120,
                image: AssetImage("assets/images/walk.png"),
              ),
            ),
            const Positioned(
                top: 200,
                left: 10,
                child: Text(
                  "Device Code",
                  style: TextStyle(
                    color: AppColor.blackColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                )),
            Positioned(
                top: 240,
                left: 10,
                child: Text(
                  "Enter the 6 digit code mentioned in your\nonboarding card",
                  style: TextStyle(
                    color: AppColor.blackColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                )),
            Container(
              height: Screen.height(context: context),
              width: Screen.width(context: context),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: Screen.height(context: context) * 0.45,
                  ),
                  Pinput(
                    length: 6,
                    controller: _deviceCodeController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: Screen.height(context: context) * 0.1,
                  ),
                  Consumer<AuthController>(
                    builder: (context, authController, child) {
                      return RoundedLoadingButton(
                        animateOnTap: false,
                        controller: _buttonController,
                        color: AppColor.greenDarkColor,
                        successColor: AppColor.greenDarkColor,
                        onPressed: () async {
                          if (_deviceCodeController.text.length == 6) {
                            _buttonController.start();
                            bool otpSent = false;
                            await Future.delayed(const Duration(seconds: 3),
                                () {
                              otpSent = true;
                            });
                            if (otpSent) {
                              _buttonController.success();
                              _buttonController.reset();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const WelcomeDetailsPage();
                                  },
                                ),
                              );
                            } else {
                              _buttonController.error();
                              Timer(const Duration(seconds: 2), () {
                                _buttonController.reset();
                              });
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please enter the code");
                          }
                        },
                        child: const Text(
                          AppString.register,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    "Or",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  InkWell(
                    onTap: () {
                      Go.to(
                        context: context,
                        push: const SignupPage(),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Enter details and ",
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 18,
                            fontWeight: FontWeight.w300),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                              color: AppColor.greenDarkColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
