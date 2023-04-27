// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walk/src/constants/app_assets.dart';
import 'package:walk/src/constants/app_strings.dart';
import 'package:walk/src/controllers/auth_controller.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/utils/screen_context.dart';
import 'package:walk/src/views/auth/otp_page.dart';
import 'package:walk/src/views/auth/phone_auth.dart';
import 'package:walk/src/widgets/textfields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -140,
              left: -140,
              child: Image.asset(AppAssets.backgroundImage),
            ),
            Container(
              height: Screen.height(context: context),
              width: Screen.width(context: context),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: Screen.height(context: context) * 0.45,
                    ),
                    getTextfield("Email", _emailController, Icons.mail),
                    // getTextfield("Password", _passwordController, Icons.lock),
                    SizedBox(
                      height: Screen.height(context: context) * 0.1,
                    ),
                    Consumer<AuthController>(
                        builder: (context, authController, child) {
                      return ElevatedButton(
                        onPressed: () async {
                          bool otpSent = await authController
                              .sendOtp(_emailController.text);
                          if (otpSent) {
                            log("coming here");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return OTPPage(
                                    email: _emailController.text,
                                  );
                                },
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          minimumSize: const Size(180, 50),
                          side: const BorderSide(
                              color: Color(0xff005749), width: 3),
                          backgroundColor: Colors.white,
                          elevation: 7,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: const Text(
                          AppString.sendOtp,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      );
                    }),
                    SizedBox(
                      height: Screen.height(context: context) * 0.1,
                    ),
                    const Text(
                      AppString.forgotPassword,
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
